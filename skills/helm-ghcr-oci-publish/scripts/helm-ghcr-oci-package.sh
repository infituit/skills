#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  helm-ghcr-oci-package.sh --chart-dir <dir> --version <semver> [options]
  helm-ghcr-oci-package.sh --chart-dir <dir> --tag <vX.Y.Z[-suffix]> [options]

Personal debug helper for Helm charts published to GHCR as OCI artifacts.
It runs local-only verification and packaging, then prints login/push commands.
It never logs in or pushes for you.

Required:
  --chart-dir <dir>       Helm chart directory containing Chart.yaml
  --version <semver>      Chart version to write into the temporary copy
  --tag <tag>             Compatibility alias; v-prefix is stripped for chart version

Options:
  --app-version <value>   appVersion for the temporary copy (default: tag or version)
  --chart-name <name>     Temporary chart name override (default: Chart.yaml name)
  --owner <owner>         GHCR owner/namespace (default: current gh user)
  --username <name>       Username shown in login command (default: current gh user or owner)
  --registry <host>       Registry host only (default: ghcr.io)
  --path <path>           Registry path under owner (default: charts)
  --output-dir <dir>      Package output directory (default: .chart-packages)
  --keep-workdir          Keep temporary chart directory for inspection
  -h, --help              Show this help

Examples:
  helm-ghcr-oci-package.sh --chart-dir deploy/helm/multica --version 0.1.0-dev.1
  helm-ghcr-oci-package.sh --chart-dir deploy/helm/multica --tag v0.3.5-dev.1 --owner multica-ai
USAGE
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

trim_slashes() {
  local value="$1"
  value="${value#/}"
  value="${value%/}"
  printf '%s' "$value"
}

shell_quote() {
  printf '%q' "$1"
}

read_chart_field() {
  local file="$1"
  local field="$2"
  awk -F ':' -v key="$field" '$1 == key { sub(/^[[:space:]]+/, "", $2); sub(/[[:space:]]+$/, "", $2); gsub(/^"|"$/, "", $2); print $2; exit }' "$file"
}

set_chart_field() {
  local file="$1"
  local field="$2"
  local value="$3"
  local rendered="$4"

  if grep -Eq "^${field}:" "$file"; then
    sed -i -E "s|^${field}:.*|${field}: ${rendered}|" "$file"
  else
    printf '%s: %s\n' "$field" "$rendered" >>"$file"
  fi
}

CHART_DIR=""
CHART_VERSION=""
TAG=""
APP_VERSION=""
CHART_NAME_OVERRIDE=""
OWNER=""
USERNAME=""
REGISTRY_HOST="ghcr.io"
REGISTRY_PATH="charts"
OUTPUT_DIR=".chart-packages"
KEEP_WORKDIR=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chart-dir)
      CHART_DIR="${2:-}"
      shift 2
      ;;
    --version)
      CHART_VERSION="${2:-}"
      shift 2
      ;;
    --tag)
      TAG="${2:-}"
      shift 2
      ;;
    --app-version)
      APP_VERSION="${2:-}"
      shift 2
      ;;
    --chart-name)
      CHART_NAME_OVERRIDE="${2:-}"
      shift 2
      ;;
    --owner)
      OWNER="${2:-}"
      shift 2
      ;;
    --username)
      USERNAME="${2:-}"
      shift 2
      ;;
    --registry)
      REGISTRY_HOST="${2:-}"
      shift 2
      ;;
    --path)
      REGISTRY_PATH="${2:-}"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="${2:-}"
      shift 2
      ;;
    --keep-workdir)
      KEEP_WORKDIR=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[[ -n "$CHART_DIR" ]] || die "--chart-dir is required"
[[ -d "$CHART_DIR" ]] || die "chart directory does not exist: $CHART_DIR"
[[ -f "$CHART_DIR/Chart.yaml" ]] || die "Chart.yaml not found in: $CHART_DIR"

if [[ -n "$CHART_VERSION" && -n "$TAG" ]]; then
  die "use either --version or --tag, not both"
fi

if [[ -z "$CHART_VERSION" && -z "$TAG" ]]; then
  die "--version or --tag is required"
fi

if [[ -n "$TAG" ]]; then
  [[ "$TAG" != *-dirty* ]] || die "tag must not contain -dirty: $TAG"
  CHART_VERSION="${TAG#v}"
  if [[ -z "$APP_VERSION" ]]; then
    APP_VERSION="$TAG"
  fi
fi

if [[ -z "$APP_VERSION" ]]; then
  APP_VERSION="$CHART_VERSION"
fi

[[ "$CHART_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]] || die "chart version must be semantic version without leading v: $CHART_VERSION"

[[ "$REGISTRY_HOST" != *://* ]] || die "--registry must be a host only, not a URL: $REGISTRY_HOST"
[[ "$REGISTRY_HOST" != */* ]] || die "--registry must not include a path: $REGISTRY_HOST"
REGISTRY_PATH="$(trim_slashes "$REGISTRY_PATH")"
[[ -n "$REGISTRY_PATH" ]] || die "--path must not be empty"

require_cmd helm

GH_USER=""
if command -v gh >/dev/null 2>&1; then
  GH_USER="$(gh api user --jq .login 2>/dev/null || true)"
fi

if [[ -z "$OWNER" ]]; then
  [[ -n "$GH_USER" ]] || die "could not detect current GitHub user; pass --owner explicitly"
  OWNER="$GH_USER"
fi

if [[ -z "$USERNAME" ]]; then
  if [[ -n "$GH_USER" ]]; then
    USERNAME="$GH_USER"
  else
    USERNAME="$OWNER"
  fi
fi

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/helm-ghcr-oci.XXXXXX")"
cleanup() {
  if [[ "$KEEP_WORKDIR" == true ]]; then
    printf 'Temporary chart directory kept: %s\n' "$WORKDIR" >&2
  else
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

TEMP_CHART="$WORKDIR/chart"
cp -a "$CHART_DIR" "$TEMP_CHART"
TEMP_CHART_YAML="$TEMP_CHART/Chart.yaml"

if [[ -n "$CHART_NAME_OVERRIDE" ]]; then
  set_chart_field "$TEMP_CHART_YAML" "name" "$CHART_NAME_OVERRIDE" "$CHART_NAME_OVERRIDE"
fi

set_chart_field "$TEMP_CHART_YAML" "version" "$CHART_VERSION" "$CHART_VERSION"
set_chart_field "$TEMP_CHART_YAML" "appVersion" "$APP_VERSION" "\"$APP_VERSION\""

CHART_NAME="$(read_chart_field "$TEMP_CHART_YAML" "name")"
[[ -n "$CHART_NAME" ]] || die "could not read chart name from temporary Chart.yaml"

mkdir -p "$OUTPUT_DIR"

printf 'Chart debug package\n'
printf '  chart dir:    %s\n' "$CHART_DIR"
printf '  chart name:   %s\n' "$CHART_NAME"
printf '  version:      %s\n' "$CHART_VERSION"
printf '  appVersion:   %s\n' "$APP_VERSION"
printf '  registry:     oci://%s/%s/%s\n' "$REGISTRY_HOST" "$OWNER" "$REGISTRY_PATH"
printf '  temp chart:   %s\n' "$TEMP_CHART"
printf '\n'

helm lint "$TEMP_CHART"
helm package "$TEMP_CHART" --destination "$OUTPUT_DIR"

PACKAGE_PATH="${OUTPUT_DIR%/}/${CHART_NAME}-${CHART_VERSION}.tgz"
[[ -f "$PACKAGE_PATH" ]] || die "expected package was not created: $PACKAGE_PATH"

printf '\nPackaged chart metadata:\n'
helm show chart "$PACKAGE_PATH"

OCI_REGISTRY="oci://${REGISTRY_HOST}/${OWNER}/${REGISTRY_PATH}"
PUBLISHED_REF="${OCI_REGISTRY}/${CHART_NAME}"

printf '\nLocal package ready: %s\n' "$PACKAGE_PATH"
printf 'Intended OCI chart: %s --version %s\n' "$PUBLISHED_REF" "$CHART_VERSION"
printf '\nCopy and run manually if you want to publish this debug package:\n'
printf '  gh auth token | helm registry login %s -u %s --password-stdin\n' "$(shell_quote "$REGISTRY_HOST")" "$(shell_quote "$USERNAME")"
printf '  helm push %s %s\n' "$(shell_quote "$PACKAGE_PATH")" "$(shell_quote "$OCI_REGISTRY")"

---
name: helm-ghcr-oci-publish
description: >-
  Use when a developer wants to locally lint and package a Helm chart, temporarily set Chart.yaml version/appVersion for a debug build, and prepare copy-paste commands for publishing that chart to GitHub Container Registry (GHCR) as an OCI artifact. Trigger for Helm chart, GHCR, OCI, helm package, helm push, chart debug publish, personal chart testing, or publishing a development chart package. This is for personal development debugging, not formal release automation.
---

# Helm GHCR OCI Publish

Prepare a Helm chart package for personal GHCR OCI debugging without performing remote-changing actions.

## Core Rules

- Treat this as a personal development debugging workflow, not the official release path.
- Never execute `helm registry login` or `helm push` automatically from this skill.
- Use the bundled helper to run local-only steps: temporary chart copy, metadata override, `helm lint`, `helm package`, and `helm show chart`.
- Print login and push commands for the user to copy and run themselves.
- Default GHCR owner should be the current GitHub user from `gh api user --jq .login`; require explicit `--owner` for organization namespaces such as `multica-ai`.
- Do not modify the working tree `Chart.yaml`; all `version`, `appVersion`, and optional chart name changes happen in a temporary chart copy.

## When to Use

Use this skill when the user wants to debug-publish or test-package a Helm chart to GHCR OCI from a local checkout.

Common prompts:

- "publish this Helm chart to GHCR for testing"
- "package a Helm chart as OCI"
- "prepare helm push command for ghcr.io"
- "调试发布 helm chart 到 ghcr.io"
- "把 chart 打成 oci 包给我推送命令"

Do not use this skill for official release workflows, production release signing, chart repository migration, or CI/CD design unless the user explicitly asks to adapt the debugging flow.

## Helper Script

Run the bundled script from this skill directory:

```bash
bash scripts/helm-ghcr-oci-package.sh \
  --chart-dir deploy/helm/multica \
  --version 0.1.0-dev.1
```

The helper:

1. Copies the chart to a temporary directory.
2. Temporarily updates `Chart.yaml` in that copy.
3. Runs `helm lint`.
4. Runs `helm package` into `.chart-packages` by default.
5. Runs `helm show chart` on the package.
6. Prints a `helm registry login` hint and a `helm push` command.

It does not login or push.

## Inputs

Required:

- `--chart-dir <dir>`: chart directory containing `Chart.yaml`.
- `--version <semver>` or `--tag <vX.Y.Z>`: chart version source.

Common optional inputs:

- `--app-version <value>`: appVersion to write into the temporary chart. Defaults to `--tag` when using tag mode, otherwise defaults to `--version`.
- `--chart-name <name>`: optional temporary chart name override. Defaults to the chart's `Chart.yaml name`.
- `--owner <owner>`: GHCR namespace. Defaults to the current GitHub user if `gh` is available.
- `--username <username>`: username shown in the login command. Defaults to current GitHub user when available, otherwise owner.
- `--registry <host>`: registry host only. Default `ghcr.io`.
- `--path <path>`: namespace path under the owner. Default `charts`.
- `--output-dir <dir>`: package output directory. Default `.chart-packages`.
- `--keep-workdir`: preserve the temporary chart copy for inspection.

## Version Rules

- Prefer `--version` for generic Helm work, for example `--version 0.1.0-dev.1`.
- Use `--tag` for release-tag-shaped projects, for example `--tag v0.3.5`; the helper converts this to chart version `0.3.5` and defaults `appVersion` to `v0.3.5`.
- Helm OCI uses the chart `version` as the OCI artifact tag. The `helm push` destination must be the registry namespace only, for example `oci://ghcr.io/<owner>/charts`; do not append chart name or version to the push destination.

## Multica Example

For Multica-style local debugging:

```bash
bash scripts/helm-ghcr-oci-package.sh \
  --chart-dir /home/ubuntu/items/multica/deploy/helm/multica \
  --tag v0.3.5-dev.1
```

To prepare a command targeting the organization namespace instead of the current user, make the owner explicit:

```bash
bash scripts/helm-ghcr-oci-package.sh \
  --chart-dir /home/ubuntu/items/multica/deploy/helm/multica \
  --tag v0.3.5-dev.1 \
  --owner multica-ai
```

The user still runs the printed login and push commands manually.

## Verification

Before reporting success, confirm:

- `helm lint` passed.
- `helm package` produced the expected `.tgz`.
- `helm show chart <package>` displays the expected `name`, `version`, and `appVersion`.
- The printed `helm push` destination has the form `oci://ghcr.io/<owner>/<path>` and does not include the chart name or version.

## Troubleshooting

- If `helm` is missing, install Helm before running the helper.
- If owner auto-detection fails, pass `--owner <github-user-or-org>`.
- If the user later runs the printed login command and GHCR rejects it, refresh GitHub CLI auth with package write permission, for example `gh auth refresh --scopes write:packages`.
- If pushing to an organization namespace fails, use a personal namespace for debugging or confirm the org package permissions separately.

## Final Report

Report:

- Chart directory and temporary metadata used.
- Package path.
- Intended OCI chart reference, including chart name and version.
- The exact login and push commands printed for the user.
- That no login or push was executed by the helper.

# OpenCode V2 Documentation Route Map

Use the narrowest route first. Read the current page before relying on exact behavior or signatures.

| Question                                     | Start here                                              | Follow when needed                          |
| -------------------------------------------- | ------------------------------------------------------- | ------------------------------------------- |
| Build a server plugin                        | `https://opencode.ai/v2/docs/build/plugins/`            | `https://opencode.ai/v2/docs/plugins/`, API |
| Add or configure a plugin                    | `https://opencode.ai/v2/docs/plugins/`                  | Build plugins                               |
| Build a CLI/TUI plugin                       | `https://opencode.ai/v2/docs/build/plugins/cli/`        | CLI intro/settings/plugins                  |
| Plugin RPC                                   | `https://opencode.ai/v2/docs/build/plugins/rpc/`        | API RPC operation                           |
| Effect plugin or RPC                         | `https://opencode.ai/v2/docs/build/plugins/effect/`     | Effect RPC                                  |
| Connect to a running server                  | `https://opencode.ai/v2/docs/build/client/`             | API                                         |
| Embed OpenCode                               | `https://opencode.ai/v2/docs/build/sdk/`                | Effect or Cloudflare SDK                    |
| HTTP endpoint or schema                      | `https://opencode.ai/v2/docs/api/`                      | `https://opencode.ai/v2/openapi.json`       |
| CLI invocation or service                    | `https://opencode.ai/v2/docs/cli/`                      | CLI commands or troubleshooting             |
| CLI plugin configuration                     | `https://opencode.ai/v2/docs/cli/plugins/`              | CLI settings                                |
| Plugin loading or runtime failure            | `https://opencode.ai/v2/docs/troubleshooting/`          | Plugins and CLI                             |
| Config, permissions, skills, commands, tools | `https://opencode.ai/v2/docs/config/`                   | The specific configuration page             |
| V1 plugin migration                          | `https://opencode.ai/v2/docs/build/plugins/migrate-v1/` | Only when migration is explicitly in scope  |

## Discovery source

Use `https://opencode.ai/v2/llms.txt` to discover the current V2 documentation tree when the route map does not cover the question. Follow links only within `https://opencode.ai/v2/docs/` or to the official V2 OpenAPI document.

## API lookup

Use the API page for operation names and the OpenAPI document for exact request, response, and schema details. Treat routes marked experimental as version-sensitive and say so in the lookup result.

## Source rejection

Do not use the V1 `/docs/` tree, search-result snippets, third-party articles, or unverified repository examples as the source of an OpenCode V2 contract. If the official V2 pages do not answer the question, report the gap instead of filling it with an assumption.

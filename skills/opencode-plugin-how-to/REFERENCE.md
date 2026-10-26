# OpenCode Plugin Routing Reference

## Extension surface

| Request shape                                          | First surface to inspect         | Canonical V2 area                                                                |
| ------------------------------------------------------ | -------------------------------- | -------------------------------------------------------------------------------- |
| Change server behavior or register server capabilities | Server plugin                    | `https://opencode.ai/v2/docs/build/plugins`                                      |
| Add or change terminal UI behavior                     | CLI/TUI plugin                   | `https://opencode.ai/v2/docs/build/plugins/cli`                                  |
| Expose typed methods or events                         | Plugin RPC                       | `https://opencode.ai/v2/docs/build/plugins/rpc`                                  |
| Connect to a running OpenCode server                   | HTTP client                      | `https://opencode.ai/v2/docs/build/client` and `https://opencode.ai/v2/docs/api` |
| Embed OpenCode in an application                       | SDK                              | `https://opencode.ai/v2/docs/build/sdk`                                          |
| Configure plugin loading or options                    | Configuration and plugin loading | `https://opencode.ai/v2/docs/config` and `https://opencode.ai/v2/docs/plugins`   |
| Diagnose loading, service, or runtime behavior         | Troubleshooting                  | `https://opencode.ai/v2/docs/troubleshooting`                                    |

## Server plugin mechanism

| Need                                                                           | Mechanism to investigate      |
| ------------------------------------------------------------------------------ | ----------------------------- |
| Register or modify durable definitions                                         | Transform and `reload()`      |
| Intercept a live operation                                                     | Hook                          |
| Give the model a capability                                                    | Tool transform                |
| Add a slash command                                                            | Command transform             |
| Persist plugin-owned JSON state                                                | Plugin storage                |
| Observe server events                                                          | Event subscription            |
| Provide typed cross-plugin/client methods                                      | RPC                           |
| Add a provider/model/integration/MCP/reference/VCS/worktree/websearch behavior | The matching domain transform |

## Hook selection hints

| Need                                       | Hook family                                  |
| ------------------------------------------ | -------------------------------------------- |
| Rewrite admitted user input                | Session `prompt`                             |
| Change assembled model context             | Session `context`                            |
| Control compaction or auxiliary generation | Session `compaction`, `generate`, or `title` |
| Change provider request settings           | Session `model.request`                      |
| Change native provider HTTP traffic        | Session `http.request` or `http.response`    |
| Change provider WebSocket traffic          | Experimental WebSocket hooks                 |
| Change retry policy                        | Session `retry`                              |
| Review permission decisions                | Permission `evaluate`                        |
| Change shell execution inputs              | Shell `create.before`                        |
| Inspect or change tool execution           | Tool `execute.before` or `execute.after`     |

## Official lookup fallback

Load `opencode-plugin-doc-finder` when the selected focused skill or local project source does not establish the required OpenCode V2 behavior. Keep this table as navigation, not as a copied API reference. Re-read the linked official page for exact signatures, experimental behavior, or version-sensitive details.

## Local project adaptation

After selecting the OpenCode surface, inspect the target repository's own:

- agent instructions and scoped rules;
- package manifest, lockfile, and OpenCode dependency/version;
- plugin entrypoint and exports;
- configuration and loading files;
- existing analogous plugin implementation;
- typecheck, build, format, package, and runtime verification commands.

Project facts belong to the project rules or focused project skill. Do not encode them as universal OpenCode facts here.

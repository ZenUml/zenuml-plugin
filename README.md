# ZenUML for Confluence

Let Claude or ChatGPT draw diagrams for you, and read, create and update the
diagrams on your Confluence Cloud pages. Ask for a sequence diagram of a code
path, a Mermaid flowchart of a runbook, or a fix to a diagram that no longer
matches the system. The assistant writes the diagram source; ZenUML draws it in
the conversation, or saves it to the page.

Supported diagram types: ZenUML sequence diagrams, Mermaid, PlantUML,
diagrams.net (draw.io) graphs and OpenAPI specifications.

## What is in this plugin

| Component | What it does | Needs |
|---|---|---|
| `zenuml-render` MCP server (`https://zenuml.com/mcp`) | One read-only tool, `render_diagram`: draws a diagram from its source in the conversation and reports parse errors with line and column. Nothing is saved. | Nothing: no account, no sign-in |
| `zenuml` MCP server (`https://conf-lite.zenuml.com/agent-link/mcp`) | Confluence tools: `list_sites`, `list_diagrams`, `read_diagram`, `read_page`, `get_status` (read-only), and `create_diagram`, `update_diagram`, `create_page`, `update_page` (write). | A Confluence Cloud site with ZenUML installed, and an Atlassian sign-in |
| `draw-diagrams` skill | How to pick a diagram language, render, and fix parse errors. | — |
| `confluence-diagrams` skill | The read-before-write workflow for Confluence, which diagram type fits which job, and the ZenUML sequence syntax. | — |

The ChatGPT package carries only the `zenuml-render` server, because ChatGPT
plugins hold a single MCP server. The Claude plugin carries both.

The plugin bundles no local code. Every tool call goes to the ZenUML servers
named above, run by ZenUML.

## What you need

- To draw diagrams in the conversation: nothing.
- To work with Confluence:
  - a Confluence Cloud site with a ZenUML app installed: the free
    [ZenUML Diagrams and Open API Lite](https://marketplace.atlassian.com/apps/1219422/zenuml-diagrams-and-open-api-lite)
    or the paid
    [ZenUML Diagrams for Confluence](https://marketplace.atlassian.com/apps/1218380/zenuml-diagrams-for-confluence);
  - an Atlassian account that can view and edit the pages you want to work on.

## Install

In Claude Code:

```
/plugin install zenuml --marketplace ZenUml/zenuml-plugin
```

In Claude and ChatGPT, add it from the plugin directory once it is listed.

## Sign-in and permissions

`render_diagram` needs no sign-in and touches nothing of yours.

The Confluence tools ask you to sign in with Atlassian and approve access the
first time one runs. ZenUML then acts **as you**: it can reach only the sites,
spaces and pages your Atlassian account can already reach, and every change
appears in Confluence under your name. You can revoke access at any time from
your Atlassian account's connected apps. Read-only tools run without asking;
each tool that changes Confluence asks for your confirmation first.

## How changes are saved

- `update_diagram` saves a new version of the diagram. It refuses source that
  does not parse or that looks like accidental truncation. To undo, write the
  previous source back.
- `create_diagram` adds the diagram to the end of a page and publishes one page
  version, which page history can revert. It never overwrites a page that
  someone else changed in the meantime.
- `create_page` and `update_page` publish ordinary page versions. A page can be
  created as an unpublished draft for you to review.

## Data and privacy

- **Render server:** stores no diagram. To limit abuse it counts calls per
  minute against a keyed hash of the caller's network address, never the
  address itself, and deletes the counts shortly after. It records usage
  analytics: the AI client's name, which tool ran, and whether it succeeded,
  with no user identity.
- **Confluence server:** stores your Atlassian authorization (encrypted) so the
  tools keep working between sessions. For each tool call it records usage
  analytics: your Atlassian account id, the name of the AI client, which tool
  ran, on which site, and whether it succeeded. Diagram and page content passes
  through to Confluence and is not stored by ZenUML; Confluence remains the
  only copy.
- **PlantUML previews**, from either server, load their image from the public
  PlantUML server at `www.plantuml.com`, which receives the diagram's encoded
  source.

See the [privacy policy](https://zenuml.com/privacy/) and
[terms of service](https://zenuml.com/terms/).

## Example prompts

- "Draw a sequence diagram of an OAuth authorization code flow with PKCE."
- "Turn this list of deploy steps into a Mermaid flowchart."
- "List the sequence diagrams on the *Auth architecture* page."
- "Our refresh-token hop moved to the gateway. Update the login sequence
  diagram to match."
- "Add a Mermaid flowchart of the retry ladder to the *Payments runbook* page."

## Support

Documentation: <https://zenuml.com/docs/products/zenuml-diagrams-for-confluence/mcp-server/>
Contact: <support@zenuml.com>

## License

MIT. See [LICENSE](LICENSE).

---
name: draw-diagrams
description: Draw a sequence diagram, flowchart, architecture, class, state or API diagram for the user from text, with the ZenUML render tool. Use when the user asks to draw, sketch, visualise or diagram something in the conversation, without saving it anywhere.
---

# Drawing diagrams with ZenUML

The `zenuml-render` connector's `render_diagram` tool draws a diagram from its
source and shows it in the conversation. No account or sign-in is needed, and
nothing is saved: the diagram exists only in this conversation.

## Workflow

1. **Pick the language.**

   | Diagram | `diagramType` | Source |
   |---|---|---|
   | Calls and messages between services or actors | `sequence` | ZenUML DSL |
   | Flowcharts, state, class, ER, Gantt and other Mermaid diagrams | `mermaid` | Mermaid |
   | When the user writes or asks for PlantUML | `plantuml` | PlantUML with `@startuml` / `@enduml` |
   | Freeform drawings the user already has as draw.io XML | `graph` | draw.io / diagrams.net XML |
   | REST APIs | `openapi` | OpenAPI or Swagger, YAML or JSON |

   Prefer `sequence` for interactions and `mermaid` for most other structured diagrams.
   `diagramType` is optional; pass it when the source could be read more than one way.

2. **Write the complete source** and call `render_diagram { source, diagramType, title }`.

3. **Read the result.** It says which type was drawn and whether the source parsed. If it lists
   errors with line and column, fix exactly those and call `render_diagram` again. Do not tell the
   user the diagram is done until the source parses.

4. **Show the user the source too**, briefly, so they can keep or edit it.

For each language's rules, read the connector's `zenuml://dsl-guide`, `mermaid://dsl-guide`,
`plantuml://dsl-guide` or `openapi://dsl-guide` resource.
<!-- claude-only -->
The `confluence-diagrams` skill in this plugin has a short ZenUML syntax summary as well.

To save a diagram to a Confluence page, use the `zenuml` Confluence connector instead (see the
`confluence-diagrams` skill), where it is installed.
<!-- /claude-only -->

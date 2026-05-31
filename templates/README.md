# Claude Templates

Reusable reference files for Power BI, Fabric, and data engineering work.
Read this file before starting any Power BI or Fabric task.

## Structure

| Folder | Contents | Use for |
|--------|----------|---------|
| `pbip/report-examples/` | Full PBIR report with real visual.json files | Pattern reference when building or editing reports |
| `pbip/visuals/default/` | Minimal visual.json per chart type | Starting point — theme-only, no bespoke formatting |
| `pbip/visuals/formatted/` | visual.json with CF, gradients, flash themes | Copy-paste formatting patterns |
| `pbip/tmdl/` | SpaceParts — complete real-world TMDL model | TMDL syntax reference for measures, calc groups, roles |
| `visuals/deneb/` | Vega/Vega-Lite spec templates + PBIR visual.json | Deneb chart starting points |
| `visuals/svg/` | DAX SVG measure templates (.dax files) | Inline sparklines, data bars, bullet charts in tables |
| `fabric/notebooks/` | PySpark and Python notebook examples | Fabric Spark notebook scaffolding |
| `fabric/migration/` | Packt workshop materials — ADR templates, capacity planning, production readiness | Fabric architecture decisions and migration planning |

## How to use

- **Building a report visual**: check `pbip/visuals/default/` for the visual type, then `pbip/visuals/formatted/` for formatting patterns.
- **Writing TMDL**: reference `pbip/tmdl/SpaceParts.SemanticModel/` for syntax examples.
- **Adding an SVG visual**: copy the nearest `.dax` file from `visuals/svg/` and adapt.
- **Fabric architecture decision**: start from the relevant docx in `fabric/migration/`.

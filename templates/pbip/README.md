# pbip Templates

Power BI Project (PBIP) format reference files.

## Subfolders

- **`report-examples/`** — K201-MonthSlicer: a complete PBIR report with 7 visual types (slicer, kpi, lineChart, scatterChart, tableEx, textbox, advancedSlicer), extension measures, 5 bookmarks, conditional formatting, and the SQLBI/Data Goblins theme. Use as a pattern reference when working with any PBIR file.
- **`visuals/default/`** — 20 minimal visual.json files, one per chart type. Theme defaults only — no bespoke formatting. Use as a clean starting point.
- **`visuals/formatted/`** — 32 visual.json files with real formatting: CF, gradients, flash themes, bullet charts, variance patterns, SVG image measures. Use as copy-paste references.
- **`tmdl/`** — SpaceParts semantic model: 40 tables, 152 measures, 8 calculation groups, 8 RLS roles, DAX UDFs, shared M expressions, perspectives, and cultures. The authoritative TMDL syntax reference.

## Key rule

The `.Report/` folder (report-examples) and the `.SemanticModel/` folder (tmdl) are separate concerns. Never mix them. Use `pbir-cli` for report files, `tmdl` skill or Power BI MCP server for semantic model files.

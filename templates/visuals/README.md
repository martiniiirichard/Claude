# Visual Templates

Custom visual templates for Power BI reports.

## Subfolders

- **`deneb/`** — Vega and Vega-Lite specs + complete PBIR visual.json files for Deneb custom visuals. Use for interactive, vector-based charts that native Power BI visuals can't produce.
- **`svg/`** — DAX measure templates (.dax) that return SVG strings for inline graphics in tables, matrices, cards, and image visuals. Use for sparklines, data bars, bullet charts, and status indicators without custom visual registration.

## Decision guide

| Need | Use |
|------|-----|
| Interactive chart (cross-filter, hover, tooltips) | Deneb |
| Inline graphic in a table/matrix cell | SVG measure |
| Statistical chart (distribution, regression) | Python/R visual |
| Standard chart type | Native Power BI visual |

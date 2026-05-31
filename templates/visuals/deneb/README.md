# Deneb Templates

Vega and Vega-Lite templates for Power BI Deneb custom visuals.

## spec/ — Standalone spec files

Ready to inject into a PBIR visual.json after escaping (double quotes → `\"`, wrap in single quotes).

| File | Chart |
|------|-------|
| `vega/bar-chart.json` | Horizontal bar (Vega) |
| `vega/line-chart.json` | Line chart (Vega) |
| `vega-lite/bullet-chart.json` | Bullet chart (Vega-Lite) |
| `vega-lite/kpi-card.json` | KPI card (Vega-Lite) |

## visual/ — Complete PBIR visual.json files

Drop-in visual.json files with spec already injected, field bindings, and interactivity configured.

| File | Description |
|------|-------------|
| `bullet-chart.json` | Faceted bullet chart with conditional indicators and cross-filtering |
| `kpi-card.json` | KPI card with layered text and conditional % change coloring |
| `trend-line.json` | Dual-series line chart with fold transform and color/legend mapping |
| `ytd-comparison.json` | YTD vs target with dashed lines, endpoint labels, rank-based filtering |
| `ytd-line-chart.json` | YTD line with reference period overlay |

## standard-config.json

Standard Deneb config block used across all specs: `autosize: fit`, `view.stroke: transparent`, `font: Segoe UI`.

## Escaping rule

- **In spec/ files**: use `"field name"` with standard JSON double quotes
- **In visual/ files**: field names with spaces use doubled single quotes `''field name''` (they're already injected as single-quoted DAX literals)

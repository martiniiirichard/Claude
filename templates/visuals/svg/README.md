# SVG DAX Measure Templates

DAX measure expressions that return SVG strings for inline graphics. Set `dataCategory = ImageUrl` on the measure to render as an image in tables, matrices, cards, and image visuals.

## Templates

| File | Visual |
|------|--------|
| `sparkline-measure.dax` | Line sparkline (polyline + CONCATENATEX) |
| `progress-bar-measure.dax` | Conditional colour progress bar |
| `dumbbell-chart-measure.dax` | Actual vs target dumbbell |
| `bullet-chart-measure.dax` | Bullet chart with sentiment action dots |
| `overlapping-bars-measure.dax` | Overlapping bars with variance label |
| `overlapping-bars-with-variance-measure.dax` | Overlapping bars + variance bar + arrow icon + % label |
| `lollipop-conditional-measure.dax` | Lollipop with scaled dot and auto-formatted label |
| `waterfall-measure.dax` | Waterfall with cumulative OFFSET positioning + connector lines |
| `boxplot-measure.dax` | Box-and-whisker plot |
| `ibcs-bar-measure.dax` | IBCS-compliant horizontal bar |
| `jitter-plot-measure.dax` | Dot strip chart with jitter |
| `status-pill-measure.dax` | Rounded pill badge with category colour + text label |

## Key rules when adapting

1. All values must be normalised to SVG coordinate space — raw measure values cannot be used as pixel coordinates directly.
2. Use `HASONEVALUE` guard to suppress rendering on subtotal/total rows.
3. Embed `FORMAT(_Actual, "000000000000")` in a `<desc>` tag to make the SVG column sortable.
4. Use hex colours with `#` directly (e.g. `fill='#2196F3'`) — never `%23` or named colours.
5. Store as extension measures in `reportExtensions.json`, not in the semantic model.

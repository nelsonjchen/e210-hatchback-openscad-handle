# Reverse Engineering Notes

Source specimen:
`specimen/corolla+hatchback+trunk+floor+handle.stl`

Measured STL bounds, normalized to a zero origin:

| Axis | Size |
| --- | ---: |
| X / width | 53.57 mm |
| Y / depth | 33.92 mm |
| Z / height | 43.70 mm |

Observed features:

- Main front plate is about 53.6 mm wide, 43.7 mm tall, and 8.1 mm deep.
- Large finger opening begins around X 28.4 mm and runs from about Z 4.0 mm to Z 32.9 mm.
- Opening has a rounded right edge with repeated finger scallops.
- A tall rear return tab sits on the left side, about 4.0 mm wide, extending to the full measured depth.
- A second rear rib sits near X 25.4 mm behind the inner opening edge.

The OpenSCAD model in `../e210_hatchback_trunk_floor_handle.scad` is a
parametric first-pass approximation. Set `show_reference = true;` in that file
to overlay the original STL for tuning.

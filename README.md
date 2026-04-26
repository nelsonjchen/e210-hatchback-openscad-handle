# E210 Corolla Hatchback Trunk-Floor Handle

Parametric OpenSCAD model for a trunk-floor handle used with the Toyota deck
board assembly `58410-12050-C0`.

## Compatibility

Intended for 2019-2025 Toyota Corolla Hatchbacks equipped with a spare tire.

Fitment is unknown for the GR Corolla. It appears to have a similar notch on
the trunk floor, but the relevant floor/slot thickness has not been verified.

Fitment is also unknown for Corolla Hatchbacks with the Enhanced Cargo Space
option. I do not know whether those cars have the same slot or whether this
handle is applicable there.

Related OEM deck board:
[Toyota board assembly deck `58410-12050-C0`](https://autoparts.toyota.com/products/product/board-assy-deck-5841012050c0)

## Requirements

- [OpenSCAD](https://openscad.org/)
- [BOSL2](https://github.com/BelfrySCAD/BOSL2)
- `make`, if you want to use the provided build targets

## Build

```sh
make stl
```

Useful render targets:

```sh
make preview
make png
make clean
```

You can render larger PNGs by overriding `IMG_SIZE`:

```sh
make preview IMG_SIZE=2400,1800
```

Generated STL and preview PNG files are intentionally ignored by git.

## MakerWorld Parametric Model Maker

`e210_hatchback_trunk_floor_handle.scad` is arranged to work as a MakerWorld
Parametric Model Maker script. The top of the file exposes a small set of
Customizer-style controls for output quantity, fit, and texture. Internal
reverse-engineering dimensions are kept under a hidden section so PMM users do
not have to wade through calibration constants.

The quantity control can output either one handle or a pair laid out side by
side for both trunk-floor slots.

The default output is a single-material printable model. Part colors are kept
as a debug visualization toggle for inspecting the building blocks during
tuning, not as the production print mode.

The script uses BOSL2 for the diamond grip texture. MakerWorld PMM bundles
BOSL2, so this include is intentional.

## Source Notes

The main model lives in `e210_hatchback_trunk_floor_handle.scad`.

Reverse-engineering notes are in `agents/reverse_engineering.md`.

## Acknowledgements

A lot of this design was inspired by the MakerWorld model
[Corolla Hatchback Trunk Floor Handle](https://makerworld.com/en/models/1582723-corolla-hatchback-trunk-floor-handle?from=search#profileId-1666001).

## License

Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0
International License. See `LICENSE`.

Toyota and Corolla are trademarks of Toyota Motor Corporation. This project is
unofficial and is not endorsed by or affiliated with Toyota.

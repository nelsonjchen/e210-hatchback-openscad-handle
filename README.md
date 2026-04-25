# E210 Corolla Hatchback Trunk-Floor Handle

Parametric OpenSCAD model for a trunk-floor handle used with the Toyota deck
board assembly `58410-12050-C0`.

This is a reverse-engineered, printable approximation rather than an official
Toyota part. It is intended for fit tuning and replacement-print experiments.

## Compatibility

Intended for 2019-2025 Toyota Corolla Hatchbacks equipped with a spare tire.

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

## Source Notes

The main model lives in `e210_hatchback_trunk_floor_handle.scad`.

Reverse-engineering notes are in `agents/reverse_engineering.md`. The original
specimen STL is not redistributed in this repository; if you have a local
reference specimen, keep it under `specimen/` and use the `show_reference`
toggle in the SCAD file for private alignment/tuning.

## License

Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0
International License. See `LICENSE`.

Toyota and Corolla are trademarks of Toyota Motor Corporation. This project is
unofficial and is not endorsed by or affiliated with Toyota.

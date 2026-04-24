/*
  Parametric approximation of the E210 Corolla hatchback trunk-floor handle
  specimen in specimen/corolla+hatchback+trunk+floor+handle.stl.

  The source STL appears to be in millimeters. This file is intentionally not
  an STL import wrapper: it rebuilds the main features as editable OpenSCAD
  geometry while keeping a reference overlay available for tuning.
*/

$fn = 72;

show_reference = false;
show_model = true;

// Measured specimen bounds after normalizing the STL to min corner at 0,0,0.
overall_width = 53.57;
overall_depth = 33.92;
overall_height = 43.70;

plate_depth = 8.10;
front_bevel_depth = 1.00;
rear_deburr_depth = 0.45;

left_rear_tab_width = 3.99;
center_rib_x = 25.40;
center_rib_width = 3.00;
center_rib_depth = 20.80;
center_rib_z = 10.80;

opening_left = 28.40;
opening_bottom = 3.95;
opening_top = 32.90;
opening_samples = 72;

eps = 0.02;

module xz_extrude(y0, depth) {
    translate([0, y0 + depth, 0])
        rotate([90, 0, 0])
            linear_extrude(height = depth)
                children();
}

module plate_outline_2d() {
    square([overall_width, overall_height]);
}

function gauss(u, c, w) = exp(-pow((u - c) / w, 2));

// Right side of the cutout: a broad pull loop with three/four finger scallops.
function opening_right_x(u) =
    opening_left
    + 7.0
    + 14.4 * pow(max(0, sin(180 * u)), 0.72)
    - 3.8 * gauss(u, 0.30, 0.050)
    - 4.2 * gauss(u, 0.51, 0.055)
    - 3.9 * gauss(u, 0.72, 0.055);

module finger_opening_2d(delta = 0) {
    offset(delta = delta)
        polygon(concat(
            [[opening_left, opening_top]],
            [
                for (i = [0 : opening_samples])
                    let(
                        u = i / opening_samples,
                        z = opening_top - u * (opening_top - opening_bottom)
                    )
                    [opening_right_x(u), z]
            ],
            [[opening_left, opening_bottom]]
        ));
}

module front_plate() {
    difference() {
        xz_extrude(0, plate_depth)
            plate_outline_2d();

        // Through-opening for fingers.
        xz_extrude(-eps, plate_depth + 2 * eps)
            finger_opening_2d(0);

        // Wider shallow cuts approximate the softened lip visible on the STL.
        xz_extrude(-eps, front_bevel_depth + eps)
            finger_opening_2d(0.85);

        xz_extrude(plate_depth - rear_deburr_depth, rear_deburr_depth + eps)
            finger_opening_2d(0.35);
    }
}

module rear_features() {
    // Tall left return wall / mounting tab.
    translate([0, plate_depth, 0])
        cube([
            left_rear_tab_width,
            overall_depth - plate_depth,
            overall_height
        ]);

    // Interior rib behind the handle opening.
    translate([center_rib_x, plate_depth, center_rib_z])
        cube([
            center_rib_width,
            center_rib_depth,
            overall_height - center_rib_z
        ]);

    // Small lower shelf visible inside the grip opening.
    translate([opening_left + 0.20, plate_depth - 0.10, opening_bottom - 0.10])
        cube([overall_width - opening_left - 4.2, 3.2, 1.5]);
}

module handle_model() {
    union() {
        front_plate();
        rear_features();
    }
}

module reference_stl(alpha = 0.30) {
    color([1.0, 0.65, 0.0, alpha])
        translate([24.6116886, -153.6459808, 0])
            import("specimen/corolla+hatchback+trunk+floor+handle.stl",
                   convexity = 10);
}

if (show_reference) {
    reference_stl();
}

if (show_model) {
    color([0.93, 0.78, 0.18])
        handle_model();
}

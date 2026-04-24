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
colorize_parts = true;
show_cutters = false;

plate_color = [0.95, 0.73, 0.16];
center_body_color = [0.78, 0.22, 0.95];
adjacent_body_color = [1.00, 0.86, 0.05];
middle_body_color = [0.05, 0.72, 0.22];
right_body_color = [0.00, 0.75, 0.85];
left_tab_color = [0.10, 0.55, 0.85];
center_rib_color = [0.95, 0.22, 0.18];
opening_cutter_color = [0.95, 0.95, 1.00, 0.28];
bevel_cutter_color = [0.50, 0.20, 0.90, 0.22];
single_material_color = [0.93, 0.78, 0.18];

// Measured specimen bounds after normalizing the STL to min corner at 0,0,0.
overall_width = 53.57;
overall_depth = 33.92;
overall_height = 43.70;

plate_depth = 8.10;
front_bevel_depth = 1.00;
front_bevel_width = 0.45;
rear_deburr_depth = 0.45;
rear_deburr_width = 0.25;

left_rear_tab_width = 3.99;
rib_gap = 21.373;
center_rib_x = left_rear_tab_width + rib_gap;
center_rib_width = 3.00;
center_rib_depth = overall_depth - plate_depth;
left_rear_tab_y = left_rear_tab_width;
center_body_x = center_rib_x;
center_body_width = left_rear_tab_width;
adjacent_body_x = center_body_x + center_body_width;
adjacent_body_width = left_rear_tab_width;
middle_body_x = adjacent_body_x + adjacent_body_width;
middle_body_width = overall_width - middle_body_x;

opening_left = 28.40;
opening_bottom = 3.95;
opening_top = 32.90;

// Front-plane loop extracted from the specimen mesh, then lightly simplified.
// Coordinates are [x, z]. The left vertical edge is the straight grip wall and
// the right side carries the raised shoulder plus finger scallops.
opening_profile_points = [
    [28.36, 5.31],
    [28.36, 32.82],
    [37.24, 38.22],
    [42.06, 37.62],
    [46.11, 36.29],
    [48.81, 34.46],
    [49.88, 32.34],
    [49.03, 29.98],
    [47.61, 28.35],
    [49.03, 26.94],
    [49.50, 24.71],
    [49.01, 23.23],
    [47.61, 21.71],
    [49.05, 20.27],
    [49.58, 18.00],
    [49.07, 16.48],
    [47.61, 15.02],
    [49.09, 13.33],
    [49.88, 11.68],
    [49.58, 10.15],
    [48.43, 8.70],
    [46.50, 7.45],
    [43.86, 6.40],
    [40.75, 5.70],
    [37.30, 5.31],
    [28.36, 5.31]
];

opening_profile = opening_profile_points;

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

module finger_opening_2d(delta = 0) {
    offset(delta = delta)
        polygon(opening_profile);
}

module through_opening_cutter() {
    xz_extrude(-eps, plate_depth + 2 * eps)
        finger_opening_2d(0);
}

module front_bevel_cutter() {
    xz_extrude(-eps, front_bevel_depth + eps)
        finger_opening_2d(front_bevel_width);
}

module rear_deburr_cutter() {
    xz_extrude(plate_depth - rear_deburr_depth, rear_deburr_depth + eps)
        finger_opening_2d(rear_deburr_width);
}

module plate_region_2d(x0, width) {
    intersection() {
        plate_outline_2d();
        translate([x0, -eps])
            square([width, overall_height + 2 * eps]);
    }
}

module front_plate_region(x0, width) {
    difference() {
        xz_extrude(0, plate_depth)
            plate_region_2d(x0, width);

        through_opening_cutter();
        front_bevel_cutter();
        rear_deburr_cutter();
    }
}

module front_plate_window(x0, width, y0, depth) {
    difference() {
        xz_extrude(y0, depth)
            plate_region_2d(x0, width);

        through_opening_cutter();
        front_bevel_cutter();
        rear_deburr_cutter();
    }
}

module front_plate() {
    difference() {
        xz_extrude(0, plate_depth)
            plate_outline_2d();

        // Through-opening for fingers.
        through_opening_cutter();

        // Wider shallow cuts approximate the softened lip visible on the STL.
        front_bevel_cutter();

        rear_deburr_cutter();
    }
}

module main_front_plate() {
    front_plate_window(
        0,
        center_body_x,
        left_rear_tab_width,
        plate_depth - left_rear_tab_width
    );
}

module left_body_connector() {
    front_plate_window(
        0,
        center_body_x,
        0,
        left_rear_tab_width
    );
}

module right_front_plate() {
    front_plate_region(
        middle_body_x,
        middle_body_width
    );
}

module center_body_plate() {
    front_plate_region(center_body_x, center_body_width);
}

module adjacent_body_plate() {
    front_plate_region(adjacent_body_x, adjacent_body_width);
}

module front_body_parts() {
    left_body_connector();
    center_body_plate();
    adjacent_body_plate();
    right_front_plate();
}

module left_rear_tab() {
    translate([0, left_rear_tab_y, 0])
        cube([
            left_rear_tab_width,
            overall_depth - left_rear_tab_y,
            overall_height
        ]);
}

module center_rear_rib() {
    translate([center_rib_x, plate_depth, 0])
        cube([
            center_rib_width,
            center_rib_depth,
            overall_height
        ]);
}

module rear_features() {
    left_rear_tab();
    center_rear_rib();
}

module opening_cutters() {
    color(opening_cutter_color)
        through_opening_cutter();

    color(bevel_cutter_color)
        front_bevel_cutter();

    color(bevel_cutter_color)
        rear_deburr_cutter();
}

module handle_model() {
    if (colorize_parts) {
        color(middle_body_color)
            left_body_connector();
        color(center_body_color)
            center_body_plate();
        color(adjacent_body_color)
            adjacent_body_plate();
        color(right_body_color)
            right_front_plate();
        color(left_tab_color)
            left_rear_tab();
        color(center_rib_color)
            center_rear_rib();
    } else {
        color(single_material_color)
            union() {
                front_body_parts();
                rear_features();
            }
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
    handle_model();
}

if (show_cutters) {
    opening_cutters();
}

/*
  Parametric approximation of the E210 Corolla hatchback trunk-floor handle
  specimen in specimen/corolla+hatchback+trunk+floor+handle.stl.

  The source STL appears to be in millimeters. This file is intentionally not
  an STL import wrapper: it rebuilds the main features as editable OpenSCAD
  geometry while keeping a reference overlay available for tuning.
*/

include <BOSL2/std.scad>

$fn = 72;

show_reference = false;
show_model = true;
colorize_parts = true;
show_cutters = false;

plate_color = [0.95, 0.73, 0.16];
middle_body_color = [0.05, 0.72, 0.22];
right_body_color = [0.00, 0.75, 0.85];
grip_rim_color = [0.78, 0.22, 0.95];
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
left_rear_tab_y = left_rear_tab_width;
rib_gap = 21.373;
center_rib_x = left_rear_tab_width + rib_gap;
center_rib_width = left_rear_tab_width;
center_rib_y = left_rear_tab_y;
center_rib_depth = overall_depth - center_rib_y;

opening_left = 28.40;
opening_bottom = 3.95;
opening_top = 32.90;
opening_wall_x = 28.36;
opening_bottom_z = 5.31;
opening_top_z = overall_height - opening_bottom_z;
opening_mid_z = overall_height / 2;
opening_half_height = (opening_top_z - opening_bottom_z) / 2;
opening_edge_x = 37.30;
opening_outer_x = 49.90;
grip_rim_bottom_width = opening_bottom_z;
grip_rim_top_width = overall_height - opening_top_z;
grip_rim_width = grip_rim_bottom_width;
grip_rim_left_width = 1.85;
grip_rim_depth = 8.146;
grip_rim_mount_right_x = opening_wall_x + grip_rim_width;
grip_rim_overlap = 0.08;
green_body_width = center_rib_x + center_rib_width;
grip_rim_clip_left_x = opening_wall_x;
grip_rim_x_shift = green_body_width - grip_rim_clip_left_x;

diamond_texture = texture("diamonds", n = 2);
diamond_texture_size = 4.00;
diamond_texture_depth = 0.45;
diamond_texture_backing = 0.12;
inner_gusset_radius = 4.00;
inner_gusset_steps = 24;

function bez3(p0, p1, p2, p3, t) = [
    pow(1 - t, 3) * p0[0]
        + 3 * pow(1 - t, 2) * t * p1[0]
        + 3 * (1 - t) * pow(t, 2) * p2[0]
        + pow(t, 3) * p3[0],
    pow(1 - t, 3) * p0[1]
        + 3 * pow(1 - t, 2) * t * p1[1]
        + 3 * (1 - t) * pow(t, 2) * p2[1]
        + pow(t, 3) * p3[1]
];

function bez3_path(p0, p1, p2, p3, n, skip_first = true) = [
    for (i = [(skip_first ? 1 : 0) : n])
        bez3(p0, p1, p2, p3, i / n)
];

// Smooth lobes with preserved sharp finger-valley cusp points.
opening_cusp_top = [47.61, opening_mid_z + 6.65];
opening_cusp_mid = [47.61, opening_mid_z];
opening_cusp_bottom = [47.61, opening_mid_z - 6.65];
opening_lobe_top = [49.88, opening_mid_z + 10.49];
opening_lobe_bottom = [49.88, opening_mid_z - 10.49];

opening_profile_path = concat(
    [[opening_wall_x, opening_bottom_z], [opening_wall_x, opening_top_z]],
    bez3_path(
        [opening_wall_x, opening_top_z],
        [30.25, opening_top_z],
        [33.60, opening_top_z],
        [37.24, opening_top_z],
        12
    ),
    bez3_path(
        [37.24, opening_top_z],
        [43.95, opening_top_z + 0.25],
        [50.70, opening_mid_z + 13.40],
        opening_lobe_top,
        18
    ),
    bez3_path(
        opening_lobe_top,
        [49.60, opening_mid_z + 8.95],
        [48.35, opening_mid_z + 7.20],
        opening_cusp_top,
        8
    ),
    bez3_path(
        opening_cusp_top,
        [51.15, opening_mid_z + 5.50],
        [51.05, opening_mid_z + 1.35],
        opening_cusp_mid,
        18
    ),
    bez3_path(
        opening_cusp_mid,
        [51.05, opening_mid_z - 1.35],
        [51.15, opening_mid_z - 5.50],
        opening_cusp_bottom,
        18
    ),
    bez3_path(
        opening_cusp_bottom,
        [48.35, opening_mid_z - 7.20],
        [49.60, opening_mid_z - 8.95],
        opening_lobe_bottom,
        8
    ),
    bez3_path(
        opening_lobe_bottom,
        [50.70, opening_mid_z - 13.40],
        [43.95, opening_bottom_z],
        [37.24, opening_bottom_z],
        18
    )
);
opening_profile = concat(opening_profile_path, [[opening_wall_x, opening_bottom_z]]);

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
        finger_opening_2d(grip_rim_width - grip_rim_overlap);
}

module front_bevel_cutter() {
    xz_extrude(-eps, front_bevel_depth + eps)
        finger_opening_2d(grip_rim_width + front_bevel_width);
}

module rear_deburr_cutter() {
    xz_extrude(plate_depth - rear_deburr_depth, rear_deburr_depth + eps)
        finger_opening_2d(grip_rim_width + rear_deburr_width);
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
        green_body_width,
        left_rear_tab_width,
        plate_depth - left_rear_tab_width
    );
}

module left_body_connector() {
    xz_extrude(0, left_rear_tab_width)
        plate_region_2d(0, green_body_width);
}

module right_front_plate() {
}

module grip_rim_2d() {
    difference() {
        intersection() {
            offset(delta = grip_rim_width)
                finger_opening_2d(0);

            translate([grip_rim_clip_left_x, -eps])
                square([
                    overall_width,
                    overall_height + 2 * eps
                ]);
        }
        finger_opening_2d(0);
    }
}

module grip_rim_segment_2d(z0, z1) {
    intersection() {
        grip_rim_2d();
        translate([grip_rim_clip_left_x - eps, z0])
            square([
                overall_width,
                z1 - z0
            ]);
    }
}

module grip_rim() {
    translate([grip_rim_x_shift, 0, 0])
        xz_extrude(0, grip_rim_depth)
            grip_rim_2d();
}

module front_body_parts() {
    left_body_connector();
    right_front_plate();
    grip_rim();
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
    translate([center_rib_x, center_rib_y, 0])
        cube([
            center_rib_width,
            center_rib_depth,
            overall_height
        ]);
}

module rib_inner_radius_gussets() {
    linear_extrude(height = overall_height)
        translate([left_rear_tab_width, left_rear_tab_y])
            difference() {
                square([inner_gusset_radius, inner_gusset_radius]);
                translate([inner_gusset_radius, inner_gusset_radius])
                    circle(r = inner_gusset_radius, $fn = inner_gusset_steps);
            }

    linear_extrude(height = overall_height)
        translate([center_rib_x - inner_gusset_radius, center_rib_y])
            difference() {
                square([inner_gusset_radius, inner_gusset_radius]);
                translate([0, inner_gusset_radius])
                    circle(r = inner_gusset_radius, $fn = inner_gusset_steps);
            }
}

module diamond_face_panel(face_x, normal_sign) {
    face_y0 = left_rear_tab_y + inner_gusset_radius;
    face_y_span = overall_depth - face_y0;

    translate([
        face_x,
        face_y0 + face_y_span / 2,
        overall_height / 2
    ])
        rotate([0, normal_sign > 0 ? 90 : -90, 0])
            textured_tile(
                diamond_texture,
                size = [
                    overall_height,
                    face_y_span,
                    diamond_texture_backing
                ],
                tex_size = [
                    diamond_texture_size,
                    diamond_texture_size
                ],
                tex_depth = diamond_texture_depth,
                style = "concave"
            );
}

module blue_plus_x_diamond_face() {
    diamond_face_panel(left_rear_tab_width, 1);
}

module red_minus_x_diamond_face() {
    diamond_face_panel(center_rib_x, -1);
}

module rear_features() {
    left_rear_tab();
    center_rear_rib();
    rib_inner_radius_gussets();
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
        color(right_body_color)
            right_front_plate();
        color(grip_rim_color)
            grip_rim();
        color(left_tab_color)
            left_rear_tab();
        color(left_tab_color)
            blue_plus_x_diamond_face();
        color(center_rib_color)
            center_rear_rib();
        color(center_rib_color)
            red_minus_x_diamond_face();
        color(middle_body_color)
            rib_inner_radius_gussets();
    } else {
        color(single_material_color)
            union() {
                front_body_parts();
                rear_features();
                blue_plus_x_diamond_face();
                red_minus_x_diamond_face();
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

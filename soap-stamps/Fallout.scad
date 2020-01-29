// soap stamp fallout
echo(version=version());

// Font of the two text (top, bottom)
font = "Stencil";

// size of the complete plate
cube_height = 60;
cube_width = 80;
cube_size = min(cube_height, cube_width);

// depth of the logo
symbol_height = 5;

// resolution of the round parts
fn = 100;


module extruded_text(txt, text_size) {
  linear_extrude(height = symbol_height) {
    text(txt, size = text_size, font = font, halign = "center", valign = "center", $fn = fn);
  }
}

module extruded_arc(a1, a2, or, ir) {
  angles = [a1, a2];
  points = [
    for(a = [angles[0]:1:angles[1]]) [or * cos(a), or * sin(a)]
  ];
  inner_points = [
    for(a = [angles[1]:-1:angles[0]]) [ir * cos(a), ir * sin(a)]
  ];
  linear_extrude(height = symbol_height) {
    polygon(concat(inner_points, points));
  }
}

module extruded_circle(r, dh) {
  linear_extrude(height = symbol_height + dh) {
    circle(r, $fn = fn);
   }    
}

module extruded_square(w, h, dh) {
  linear_extrude(height = symbol_height + dh) {
    square(size = [w, h]);
  }    
}

module outer_ring() {
  outer_radius = cube_size / 4.167;
  inner_radius = cube_size / 4.6875;
  difference() {
     extruded_circle(outer_radius, 0);
    extruded_circle(inner_radius, 1);
  }
}

module background_plate() {
  translate([0, 0, -1]) color("black") cube([cube_width, cube_height, 4], center = true);
}

module radioactive() {
  aam = cube_size / 5.357;
  inner_radius = cube_size / 16.67;
  middle_radius = cube_size / 30;
  difference() {
    union() {
      extruded_arc(60, 120, aam, inner_radius);
      extruded_arc(180, 240, aam, inner_radius);
      extruded_arc(300, 360, aam, inner_radius);   
    }
    extruded_circle(inner_radius, 1);
  }
  extruded_circle(middle_radius, 0);
}

mirror([1,0,0]) {
  union() {
    up_shift = cube_size / 2.9;
    down_shift = -cube_size / 3.1;
    translate([0, up_shift, 0]) extruded_text("FALLOUT", cube_size / 9.375);
    outer_ring();
    radioactive();
    translate([0, down_shift, 0]) extruded_text("soapocalypse", cube_size / 18.75);
    background_plate();
  }
}
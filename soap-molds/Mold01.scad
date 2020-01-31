echo(version=version());

fn = 50;

module thing(l, r) {
  rotate([0, 90, 0]) cylinder(l, r, r, true, $fn = fn);
  translate([l/2, 0, 0]) sphere(r, $fn = fn);
  translate([-l/2, 0, 0]) sphere(r, $fn = fn);
}

module soap(l1, w1, h) {
    l = l1 - 2 * h;
    w = w1 - 2 * h;
    translate([0, -w/2, 0]) thing (l, h);
    translate([0, w/2, 0]) thing (l, h);
    rotate([0, 0, 90]) translate([0, -l/2, 0]) thing(w, h);
    rotate([0, 0, 90]) translate([0, l/2, 0]) thing(w, h);
    cube([l, w, h * 2], true);
}

module mold(sl, sw, sh, rl, rw, d) {
    ml = sl + d;
    mw = sw + d;
    mh = sh + (d/2);
    difference() {
      translate([0, 0, mh/2]) cube([ml, mw, mh], true);
      union() {
        soap(sl, sw, sh);
        cube([rl, rw, 3 * mh], true);  
      }
   }
}

mold(40, 30, 5, 16, 12, 3);

use <lib/BOSL/transforms.scad>
$fn=60;

// todo
// extract parameters and use configurator
// compensate for greater width at bottom
// pcb clearance holes
// stabiliser holes
// gap for controller
// mounting for usb
//
//cut into halves (dovetail joint?)
//arrange for printing
//
//
//? add switches and keys?
//
//
//

explode=0;

hole_diameter=3.2;
hole_depth=3;
clearance_hole_diameter=2;
clearance_hole_depth=2;

/* pcb_base() */
  body()
    pcb();
/* top_holes(); */
/* base_holes(); */
module body(){
  render() {
    difference(){
      rotate([5,0,0]) {
        linear_extrude(height=12, convexity=10){
          difference() {
            hull() projection() pcb();
            offset(-8) hull() projection() pcb();
          }
        };
      }
      translate([0,0,-300]) cube(600, center=true);
      base_holes();
      rotate([5,0,0]) translate([0,0,12-hole_depth]) {
        top_holes();
      };
    };
  }
  rotate([5,0,0]) translate([0,0,12+explode]) children();
}

module pcb_base(){
  color("grey") import("pcb_bottom.stl");
  translate([0,0,1.6+explode]) children();
}

module pcb(){
  color("grey") import("pcb.stl");
}


module base_holes(){
  locations=[
    [243.63426,-25.66162,0],
    [28.56992,-26.99258,0],
    [123.825,-26.9875,0],
    [186.53252,-100.0125,0],
    [191.29248,-26.9875,0],
    [105.56748,-100.0125,0],
    [263.525,-100.0125,0],
    [28.575,-100.0125,0],
    [263.525,-26.9875,0],
    [225.8695,-25.61844,0]
  ];
  translate([-19.843750,23.018750,0])
  for(location=locations){
    translate(location) cylinder(h=hole_depth, d=hole_diameter);
  }
}


module top_holes() {

  locations=[
    [126.20752,-29.13126],
    [200.05802,-102.15626],
    [109.57052,-102.15626],
    [277.8125,-28.8925],
    [31.75,-28.8925],
    [32.57804,-102.15626],
    [202.40752,-29.13126],
    [277.05304,-102.15626],
  ];
  translate([-28.575,25.4,0])
  for(location=locations){
    translate(location) cylinder(h=hole_depth, d=hole_diameter);
  }
}

module clearance_holes() {

  locations=[
  ];
  translate([-28.575,25.4,0])
  for(location=locations){
    translate(location) cylinder(h=clearance_hole_depth, d=clearance_hole_diameter);
  }
}

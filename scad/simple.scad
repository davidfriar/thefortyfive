use <lib/BOSL/transforms.scad>
include <lib/BOSL/constants.scad>
use <lib/BOSL/shapes.scad>
$fn=60;

explode=0;

typing_angle=5;
body_height=12;
wall_thickness=8;
hole_diameter=3.2;
hole_depth=4.25;
clearance_hole_diameter=3;
clearance_hole_depth=2;
large_clearance_hole_diameter=6;
large_clearance_hole_depth=2;

body() ;

module ready_to_print(){
  body();
  translate([0,-82,19]) rotate([180,0,0]) body();
  translate([10, -10,0 ]) battery_compartment();
  translate([10, -10,10 ]) battery_compartment();
}


module body(){
  color("grey") render() {
    difference(){
      rotate([typing_angle,0,0]) {
        linear_extrude(height=body_height, convexity=10){
          difference() {
            hull() projection() pcb();
            offset(-wall_thickness) hull() projection() pcb();
          }
        };
      }
      translate([0,0,-300]) cube(600, center=true);
      base_holes();
      translate([226.52,0.1,0]) usb_hole();
      rotate([typing_angle,0,0]){
        translate([0,0,body_height-hole_depth]) top_holes();
        translate([0,0,body_height-clearance_hole_depth]) clearance_holes();
        translate([84, -1, 0]) name();
        translate([185, 1,3.5]) switch_icon();
        translate([190,-9,4]) switch_hole();
        translate([111,-9,-1]) cube([55, 10, 14]);
        translate([166,-15,-1]) rotate([0,0,45])cube([8,8,14]);
        translate([111,-15,-1]) rotate([0,0,45])cube([8.5,8.5,14]);
        translate([163,-12,5]) cuboid([20, 6, 5.5], edges=EDGE_TOP_BK+EDGE_BOT_BK+EDGE_BK_RT+EDGE_TOP_RT+EDGE_BOT_RT, center=false, fillet=2);

      }
    };
  }
  rotate([typing_angle,0,0]) translate([0,0,body_height+explode]) children();
}

module pcb_base(){
  color("darkgrey") import("pcb_bottom.stl");
  translate([226.42,0,1.6]) rotate([0,0,180]) usb();
  translate([190.1, -5, 5.6]) rotate([5,0,0]) switch();
  translate([0,0,1.6+explode]) children();
}

module pcb(){
  color("darkgrey") import("pcb.stl");
  translate([111.725,-22.75,-8.3]) feather();
}
module name_orig(){
   color("black") rotate([-90,180,0]) scale([0.8, 0.8, 1]) translate([-105,-283,-1]) render()  linear_extrude(height=2, convexity=10) import("../art/nameandpaw.svg");
}
module name(){
   color("red") rotate([-90,180,0]) scale([0.8, 0.8, 1]) render() translate([0,-283,0]) linear_extrude(height=2, convexity=10) import("../art/nameandpaw.svg");
}

module switch_icon(){
  rotate([90,0,0]) linear_extrude(height=2, convexity=10) import("../art/zap.svg");
}

module feather(){
  board(50.64, 22.75, 1.6);
}

module usb(){
  difference() {
    board(20.5, 14.1, 1.5);
    translate([2.63,2.63,-1])cylinder(h=3.5, d=2.3);
    translate([17.87,2.63,-1])cylinder(h=3.5, d=2.3);
  }
  translate([5.7, 0, 1.5])
    cuboid([9.1, 8, 3.3], center=false, fillet=1, edges=EDGE_TOP_LF+EDGE_TOP_RT+EDGE_BOT_LF+EDGE_BOT_RT );
}

module board(x,y,z) {
  cuboid([x,y,z], center=false, fillet=2.63, edges=EDGE_BK_RT+EDGE_BK_LF+EDGE_FR_LF+EDGE_FR_RT);
}
module base_holes(){
  locations=[
    /* [243.63426,-25.66162,0], */
    [28.56992,-26.99258,0],
    [123.825,-26.9875,0],
    [186.53252,-100.0125,0],
    [191.29248,-26.9875,0],
    [105.56748,-100.0125,0],
    [263.525,-100.0125,0],
    [28.575,-100.0125,0],
    [263.525,-26.9875,0],
    /* [225.8695,-25.61844,0] */
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

  top_locations=[
    [100.205,-32.188],
    [119.255,-32.188],
    [176.405,-32.188],
    [233.555,-32.188],
    [138.305,-32.188],
    [81.155,-32.188],
    [43.055,-32.188],
    [195.455,-32.188],
    [214.505,-32.188],
    [252.605,-32.188],
    [271.655,-32.188],
    [62.105,-32.188],
    [157.355,-32.188],
  ];


  right_locations=[
    [274.195,-37.268],
  ];

  translate([-28.575,25.4,0]) {
    for(location=top_locations){
      hull(){
        translate(location) cylinder(h=clearance_hole_depth, d=clearance_hole_diameter);
        translate([0,-3,0]) translate(location) cylinder(h=clearance_hole_depth, d=clearance_hole_diameter);
      }
    }
    for(location=right_locations){
      hull(){
        translate(location) cylinder(h=clearance_hole_depth, d=clearance_hole_diameter);
        translate([-3,0,0]) translate(location) cylinder(h=clearance_hole_depth, d=clearance_hole_diameter);
      }
    }
  }
  translate([8,-12]) cylinder(d=8, clearance_hole_depth);

  translate([246, -46.5, 0])  cylinder(d=6, clearance_hole_depth);

  large_clearance_holes();
}


module large_clearance_holes() {

  locations=[
  // large stabiliser holes
[164.34,-102.673],
[188.152,-102.673],
[116.715,-102.673],
[140.527,-102.673],
[97.665,-102.673],
[211.965,-102.673],
  ];
  translate([-28.575,25.4,0])
  for(location=locations){
    translate(location) cylinder(h=large_clearance_hole_depth, d=large_clearance_hole_diameter);
  }
}

module switch(){
  color("purple") union(){
    cube([12, 5, 4]);
    translate([4,5,1]) cube([2,2,2]);
  }
}

module switch_hole(){
  cube([12.2, 10, 4.2]);
}

module usb_hole(){
  rotate([0,0,180]){
    cube([20.7, 14.1, 1.5]);
    translate([5.7, 0, 1.4]){
      cuboid([9.3, 9, 3.5], center=false, fillet=1, edges=EDGE_TOP_LF+EDGE_TOP_RT);
    }
    translate([2.63,2.63,1.4])cylinder(h=4.25, d=3.8);
    translate([17.87,2.63,1.4])cylinder(h=4.25, d=3.8);
    translate([14.7,5,1.4])cube([6, 5, 2]);
  }
}

module battery_compartment(){
  translate([0,-38,0]) {
    difference(){
      cube([63, 38, 6.5]);
      translate([-1,1, -1]) cube([63, 36, 6.5]);
    }
  }
}

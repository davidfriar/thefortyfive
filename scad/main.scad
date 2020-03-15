include <lib/KeyV2/includes.scad>
use <lib/BOSL/transforms.scad>
use <lib/switch_mx.scad>

my_layout = [
  [1,   1,1,1,1,1,1,1,1,1,1,1,1],
  [1.25,1,1,1,1,1,1,1,1,1,1,1.75],
  [1.75,1,1,1,1,1,1,1,1,1,1,1.25],
  [-0.75,1,1.25,1,2.25,2.75,1,1.25,1,-0.75]
];

my_legends = [
  ["tab", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "'", "bsp"],
  ["esc", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";",  "enter"],
  ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "shift"],
  ["", "ctl", "alt", "", "", "", "", "alt", "ctl"],
];



$fn=25;
$font_size=4;
unit=19.05;
rows = 4;
cols =13;
border= 4.7625;
wall_depth = 6;
base_thickness = 3;
base_color = "goldenrod";
plate_thickness = 1.5;
plate_color = "goldenrod";
wall_thickness = 3;
wall_color = [0.827, 0.9, 0.88, 0.25];
pcb_thickness = 1.6;
pcb_color = "darkmagenta";
pcb_clearance = 1;
bolt_hole_size=2;
corner_hole_offset=4;
explode = 0.01;
show_base = true;
show_walls = true;
show_plate = true;
show_keycaps=true;
show_pcb = true;

layout_height = unit * rows;
layout_width= unit * cols;
height = layout_height + 2 * border;
width = layout_width + 2 * border;
interior_height = height - wall_depth * 2;
interior_width = width - wall_depth * 2;
pcb_width = interior_width - pcb_clearance * 2;
pcb_height = interior_height - pcb_clearance * 2;

echo(layout_height=layout_height);
echo(layout_width=layout_width);
echo(height=height);
echo(width=width);
echo(interior_height=interior_height);
echo(interior_width=interior_width);
echo(pcb_width=pcb_width);
echo(pcb_height=pcb_height);

//right_half(x=width/2, s=width +50)
rotate([7,0,0])
translate([0,height-45, -3]) wall(h=45)
translate([0,-height + 45,0])
base()
  wall()
  wall()
  wall()
    plate_layer()
      switches() {
        keycaps();
        pcb();
      }
 translate([0, -100, 0])  battery();
 translate([100, -100, 0])  controller();

  cherry_mx_switch();

/* difference(){ */
/*   offset(1) hull() projection() keycaps(); */
/*   translate([border-.5, border-.5, 0]) square([unit*.75, unit]); */
/* } */

//#projection() keycaps();

//  color("blue") translate([border, border, 0]) square([unit*.75, unit]);

module keycaps(){
  if(show_keycaps) {
    translate([border,border + layout_height - unit/2, 0]){
      layout(my_layout, "oem", my_legends) {
        color([0.9,0.9,0.9]) render() { cherry() legends(0.7); }
        color([0.2,0.25,0.25]) render() { cherry()  key(); }
      }
    }
  }
}

module base(){
  with_holes(base_thickness)
    layer(base_thickness, color=base_color, visible=show_base) children(0);
}

module plate_layer(){
  with_holes(plate_thickness)
    layer(plate_thickness, color=plate_color, visible=show_plate) plate(my_layout); children(0);
}

module switches(){
  translate([0,0,6.6]) children(0);
  translate([0,0,-5]) children(1);
}

module pcb(){
  color(pcb_color)
    translate([wall_depth + pcb_clearance, wall_depth + pcb_clearance,0])
      resize([pcb_width, pcb_height, pcb_thickness])
        layer(pcb_thickness, color=pcb_color, visible=show_pcb) children();
}

module battery() {
  color("red") cube([37,30.5, 5.3]);
}

module controller(){

  color("magenta") cube([51,23,8]);
}

module wall(w=width, h=height){
    with_holes(wall_thickness)
      layer(wall_thickness, color=wall_color, wall=wall_depth, w=w, h=h, visible=show_walls) children();
}

module hole(thickness){
    // to do - holes will be too small https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
    translate([0,0,-1]) cylinder(h=thickness+2, r=bolt_hole_size/2);

}

module with_holes(thickness){
  corner_offset = 4;
  hole_locations=[
    [corner_offset, corner_offset],
    [width - corner_offset, corner_offset],
    [corner_offset, height - corner_offset],
    [width - corner_offset, height - corner_offset],
    [width / 2 , wall_depth / 2],
    [width/2, height - wall_depth/2]
  ];

    difference(){
      children();
      for(location = hole_locations){
        translate([location[0], location[1], 0]) hole(thickness);
      }
    }

}

module layer(thickness, color, wall=0, b=border,w=width, h=height, visible=true ){
  if (visible) {
    color(color) translate([border,border,0]) {
      difference(){
        linear_extrude(height=thickness){
          minkowski() {
            square([w - 2 * b, h - 2 * b]);
              circle(b);
          }
        }

        if(wall>0){
          translate([0,0,-1]) {
            linear_extrude(height=thickness+2){
              offset(-wall){
                minkowski() {
                  square([w - 2 * b, h - 2 * b]);
                  circle(b);
                }
              }
            }
          }
        }
      }
    }
  }
  translate([0,0,thickness+explode]){ children();}
}

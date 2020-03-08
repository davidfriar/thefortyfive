include <lib/KeyV2/includes.scad>

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
height = unit * rows;
width= unit * cols;
border=unit / 4;
base_thickness = 3;
base_color = [209/255,163/255,56/255];
plate_thickness = 1.5;
plate_color = [209/255,163/255,56/255];
wall_thickness = 3;
wall_color = [211/255, 230/255, 225/255, 0.25];
wall_depth = 6;
pcb_thickness = 1.6;
pcb_color = [92/255, 28/255, 120/255];
pcb_clearance = 1;
pcb_width = width + border * 2 - wall_depth * 2 - pcb_clearance * 2;
pcb_height = height + border * 2 - wall_depth * 2 - pcb_clearance * 2;
bolt_hole_size=2;
corner_hole_offset=4;
explode = 0.01;

base()
  wall()
  wall()
  wall()
    plate()
      switches() {
        keycaps();
        pcb();
      }



/* wall(); */


module keycaps(){
  translate([border,border + height - unit/2, 0]){
    layout(my_layout, "oem", my_legends) {
      color([0.9,0.9,0.9]) render() { cherry() legends(0.7); }
      color([0.2,0.25,0.25]) render() { cherry()  key(); }
    }
  }
}

module base(){
  with_holes(base_thickness)
    layer(base_thickness, color=base_color) children(0);
}

module plate(){
  with_holes(plate_thickness)
    layer(plate_thickness, color=plate_color) children(0);
}

module switches(){
  translate([0,0,6.6]) children(0);
  translate([0,0,-5]) children(1);
}

module pcb(){
  color(pcb_color)
    translate([wall_depth + pcb_clearance, wall_depth + pcb_clearance,0])
      resize([pcb_width, pcb_height, pcb_thickness])
        layer(pcb_thickness, color=pcb_color) children();
}

module wall(){
    with_holes(wall_thickness)
      layer(wall_thickness, color=wall_color, wall=wall_depth) children();
}

module hole(thickness){
    // to do - holes will be too small https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
    translate([0,0,-1]) cylinder(h=thickness+2, r=bolt_hole_size/2);

}

module with_holes(thickness){
  corner_offset = 4;
  hole_locations=[
    [corner_offset, corner_offset],
    [width + border * 2 - corner_offset, corner_offset],
    [corner_offset, height + border*2 - corner_offset],
    [width + border * 2 - corner_offset, height + border*2 - corner_offset],
    [width/2 + border, wall_depth / 2],
    [width/2 + border, height + border * 2 - wall_depth/2]
  ];

    difference(){
      children();
      for(location = hole_locations){
        translate([location[0], location[1], 0]) hole(thickness);
      }
    }

}

module layer(thickness, color, wall=0){

  color(color) translate([border,border,0]) {
    linear_extrude(height=thickness){
      difference(){
        minkowski() {
          square([width,height]);
          circle(border);
        }
        if(wall>0){
          offset(-wall){
            minkowski() {
              square([width,height]);
              circle(border);
            }
          }
        }
      }
    }
  }
  translate([0,0,thickness+explode]){ children();}
}

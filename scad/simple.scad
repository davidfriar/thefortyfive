translate ([0,0,50])
linear_extrude(12){
  difference() {
    hull() projection() pcb();
    offset(-8) hull() projection() pcb();
  }
}
/* pcb(); */
pcb_bottom();

module pcb_bottom(){
  import("pcb_bottom.stl");
}

module pcb(){
  import("pcb.stl");
}

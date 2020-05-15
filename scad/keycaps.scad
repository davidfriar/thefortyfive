include <lib/KeyV2/includes.scad>
include <cherry_profile.scad>

$support_type="disable";
$stem_support_type="disable";
$font="Gorton Digital";

legends=[
  [
    [["Esc", [0,0], 3]],
    [["Q", [0,0], 6]],
    [["W", [0,0], 6]],
    [["E", [0,0], 6]],
    [["R", [0,0], 6]],
    [["T", [0,0], 6]],
    [["Y", [0,0], 6]],
    [["U", [0,0], 6]],
    [["I", [0,0], 6]],
    [["O", [0,0], 6]],
    [["P", [0,0], 6]],
    [["\"", [0,-1], 3],["'", [0,1], 3]],
    [["Bsp", [0,0], 3]]
  ],
  [
    [["Tab", [0,0], 3]],
    [["A", [0,0], 6]],
    [["S", [0,0], 6]],
    [["D", [0,0], 6]],
    [["F", [0,0], 6]],
    [["G", [0,0], 6]],
    [["H", [0,0], 6]],
    [["J", [0,0], 6]],
    [["K", [0,0], 6]],
    [["L", [0,0], 6]],
    [[":", [0,-1], 3],[";", [0,1], 3]],
    [["Enter", [0,0], 3]]
  ],
  [
    [["Shift", [0,0], 3]],
    [["Z", [0,0], 6]],
    [["X", [0,0], 6]],
    [["C", [0,0], 6]],
    [["V", [0,0], 6]],
    [["B", [0,0], 6]],
    [["N", [0,0], 6]],
    [["M", [0,0], 6]],
    [["<", [0,-1], 3],[",", [0,1], 3]],
    [[">", [0,-1], 3],[".", [0,1], 3]],
    [["?", [0,-1], 3],["/", [0,1], 3]],
    [["Shift", [0,0], 3]]
  ],
  [
    [["Ctrl", [0,0], 3]],
    [["Alt", [0,0], 3]],
    [["", [0,0], 6]],
    [["", [0,0], 6]],
    [["", [0,0], 6]],
    [["", [0,0], 6]],
    [["Alt", [0,0], 3]],
    [["Ctrl", [0,0], 3]]
  ]
];

sizes=[
  [1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1.25,1,1,1,1,1,1,1,1,1,1,1.75],
  [1.75,1,1,1,1,1,1,1,1,1,1,1.25],
  [1,1.25,1,2.25,2.75,1,1.25,1]
];

profile_rows=[2,3,4,4];

/* echo(tail([1])); */

/* layout(); */

/* packed(key_list()); */

/* echo(key_list()); */

module layout() {
  for(row=[0:len(legends)-1]){
    for(column=[0:len(legends[row])-1]) {
      size=sizes[row][column];
      row_offset = row==3 ? 0.75 : 0;
      x=sum([for(i=[0:column]) sizes[row][i] ])-size/2 + row_offset;
      y=-row;
      translate_u(x,y) the_key(size,legends[row][column],row);
    }
  }
}

module packed(keylist, x=0, y=0, z=0){
  max_x=11;
  max_y=3;
  if(len(keylist)>0) {
    size=keylist[0][0];
    legend=keylist[0][1];
    row=keylist[0][2];
    if(x+size > max_x){
      packed(keylist, 0, y+1, z);
    }
    else if(y+1>max_y){
      packed(keylist, 0, 0, z + 1);
    }
    else {
      translate([0,0,z*10]) translate_u(x+size/2,y) the_key(size, legend, row);
      packed(tail(keylist), x+size, y, z);
    }
  }
}

function key_list() =
  [
    for(row=[0:len(legends)-1])
      for(column=[0:len(legends[row])-1])
        [sizes[row][column],legends[row][column],row ]
  ];

function tail(list) =
  len(list)>1 ? [for(i=[1:len(list)-1])list[i]] : [];

module the_key(size, legend, row){
  $stabilizers = size<2.25 ? [] : [ [12,  0], [-12, 0] ];
  $legends=legend;
  cherry_row(profile_rows[row]) u(size)  key(inset=true);
}



function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;

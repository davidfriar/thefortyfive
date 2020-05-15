module cherry_row(row=3, column=0) {
  $bottom_key_width = 18.16;
  $bottom_key_height = 18.16;
  $width_difference = 6;
  $height_difference = 4;
  $dish_type = "cylindrical";
  $dish_depth = 0.5;
  $dish_skew_x = 0;
  $dish_skew_y = 0;
  $top_skew = 1.75;

  $top_tilt_y = side_tilt(column);
  extra_height = $double_sculpted ? extra_side_tilt_height(column) : 0;


  // 5/0 is a hack so you can do these in a for loop
  if (row == 5 || row == 0) {
    /* $total_depth = 11.5 + extra_height; */
    /* $top_tilt = -6; */

    children();
  } else if (row == 1) {
    $total_depth = 9.75 + extra_height;
    $top_tilt = 0;

    children();
  } else if (row == 2) {
    $total_depth = 7.6 + extra_height;
    $top_tilt = 3;
    children();
  } else if (row == 3) {
    $total_depth = 6.7 + extra_height;
    $top_tilt = 3;
    children();
  } else if (row == 4) {
    $total_depth = 7.53 + extra_height;
    $top_tilt = 10;
    children();
  } else {
    children();
  }
}

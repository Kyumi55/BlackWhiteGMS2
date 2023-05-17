/// @description Insert description here
draw_self();
var view_x = camera_get_view_x(view_camera[0]);
var view_y = camera_get_view_y(view_camera[0]);

draw_set_color(c_red);
draw_rectangle(x - view_x - 2, y + nearGroundDistance - view_y - 2, x - view_x + 3, y + nearGroundDistance - view_y + 3, false);
draw_set_color(c_white);
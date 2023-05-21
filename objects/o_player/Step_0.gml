key_left = keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));

key_jump = keyboard_check(vk_space) || keyboard_check(ord("J"));
key_jump_held = keyboard_check(vk_space) || keyboard_check(ord("J"));

key_up = keyboard_check(ord("W"));
key_down = keyboard_check(ord("S"));
key_dash = keyboard_check_pressed(vk_alt) || keyboard_check_pressed(ord("K"));

state();
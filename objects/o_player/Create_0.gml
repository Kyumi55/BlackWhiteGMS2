/// @description Insert description here
// You can write your code in this editor
hspd = 0;
vspd = 0;
baseGrav = 0.3;
walkSpd = 4;
canjump = 0; //bool
vspdJump = -8;
canDash = false;
dashDistance = 150;
dashTime = 8;


StateFree = function()
{
	var move = key_right-key_left;

	hspd = move * walkSpd;

	vspd = vspd + baseGrav;
	
	if(canDash) && (key_dash)
	{
		canDash = false;
		canjump = 0;
		dashDirection = point_direction(0,0,key_right-key_left,key_down-key_up);
		dashSp = dashDistance/dashTime;
		dashEnergy = dashDistance;
		state = StateDash;
	}

	//horizonal colision
	if (place_meeting(x+hspd,y,o_wall))
	{
		while(abs((hspd) > 0.1))
		{
			hspd*= 0.5;
			if(!place_meeting(x + hspd,y,o_wall)) x +=hspd;
		}
		hspd = 0;
	}
	x = x + hspd; 

	//vertical collision
	if (place_meeting(x,y+vspd,o_wall))
	{
		if(vspd > 0 ) 
		{
			canjump = 5;
			canDash = true;
		}
		while(abs((vspd) > 0.1))
		{
			vspd*= 0.5;
			if(!place_meeting(x,y + vspd,o_wall)) y +=vspd;
		}
		vspd = 0;
	}
	y = y + vspd; 

	//jump
	if(canjump-- > 0) && (key_jump)
	{
		vspd = vspdJump;
		canjump= 0;
	}
	
	
	
}

StateDash = function()
{
	//move via the dash
	hspd = lengthdir_x(dashSp,dashDirection);
	vspd = lengthdir_y(dashSp,dashDirection);
	
	//Trail Effect
	with(instance_create_depth(x,y,depth+1,o_trail))
	{
		sprite_index = other.sprite_index;
		image_blend = c_ltgray; //select the color
		image_alpha = 0.7;
	}
	
	
	//horizonal colision
	if (place_meeting(x+hspd,y,o_wall)) 
	{
	    var signH = (hspd > 0) - (hspd < 0);  // get the direction of movement
	    while(!place_meeting(x + signH, y, o_wall)) 
		{
	        x += signH;
		}
		hspd = 0;
	}
	x = x + hspd; 

	//vertical collision
	if (place_meeting(x, y + vspd, o_wall)) {
    while(!place_meeting(x, y + sign(vspd), o_wall)) {
        y += sign(vspd);
    }
    vspd = 0;
}
	y = y + vspd; 
	
	//Ending dash
	dashEnergy -= dashSp;
	if(dashEnergy <= 0)
	{
		vspd = 0;
		hspd = 0;
		state = StateFree;
	}
}

state = StateFree;
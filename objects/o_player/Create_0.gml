/// @description Insert description here
// You can write your code in this editor
hspd = 0;
vspd = 0;
baseGrav = 0.3;
baseGravMulti = 2.0;
//walkSpd = 4;
canjump = 0; //bool
vspdJump = -10;
canDash = false;
dashDistance = 90;
dashTime = 8;
dashGroundDistance = 400;
jumpCounter = 0;
numJumps = 1;
numDashes = 0;

global.timerHoldMins = 0;
global.timerHoldSecs = 0;
timerTemp = 0;

dashChecker = 0;
dashAirCounter = 0;
UpChecker = false;
fastFalling = false;
inAir = false;
onGround = false;

StateFree = function()
{
	var move = key_right - key_left;
	
	var _inputs = key_right || key_left || key_up || key_down;
    
    var maxWalkSpd = 4; // Maximum walking speed
    var acceleration = 0.8; // Acceleration rate
	
	timerTemp  += delta_time;
    
    // Apply acceleration to horizontal speed
    if (move != 0)
    {
        hspd += move * acceleration;
        
        // Limit the horizontal speed to the maximum walking speed
        hspd = clamp(hspd, -maxWalkSpd, maxWalkSpd);
    }
    else
    {
        // Apply deceleration when not moving
        var deceleration = 5; // Deceleration rate
        
        if (hspd != 0)
        {
            var directionS = sign(hspd);
            
            hspd -= directionS * deceleration;
            
            // Change direction if speed becomes too small
            if (directionS != sign(hspd))
                hspd = 0;
        }
    }

	vspd = vspd + baseGrav * baseGravMulti;
	
	//if(canDash && !place_meeting(x, y+1, o_wall) && key_dash) //Alt if you don't want to dash on ground
	if(canDash && key_dash  && _inputs)
    {
		if(key_jump && key_up && !key_left && !key_right && move == 0) 
		{
			numDashes++;
			UpChecker = true; //check up they are dashing upward
			onGround = false
		}
		if(key_up && !key_left && !key_right && move == 0) 
		{
			numDashes++;
			UpChecker = true; //check up they are dashing upward
			onGround = false
		}
		else
		{
			numDashes++;
		}
		
		//numDashes++;
		dashChecker++;
		if(numDashes >= 1) 
		{
			canDash = false;
		}
		//canjump = 0;
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
			onGround = true;
			numDashes = 0;
			dashChecker = 0;
			canjump = 5;
			canDash = true;
			acceleration = 0.3;
		}
	for (var i = 0; i< abs(vspd); i++)
	{
		if(!place_meeting(x,y + sign(vspd),o_wall))
		{
			y += sign(vspd);
		}
		else
		{
			vspd = 0;
			break;
		}
	}
		dashAirCounter = 0;
		numJumps = 1;
	}
	else onGround = false; // Update onGround variable to false
	y = y + vspd; 
	
	

	//jump
	if(canjump > 0) && (key_jump) && (jumpCounter <= 0 && numJumps > 0)
	{
		//inAir = true;
		jumpCounter++; //makes it so that you can't keep jumping when the button is held
		vspd = vspdJump;
		//canDash = true;
		acceleration = 4;
		canjump = 0;
		numJumps--;
	}
	
	if(numDashes <= 0 && (key_jump) && onGround == false && jumpCounter <= 0) 
	{
		numDashes++
		jumpCounter++; //makes it so that you can't keep jumping when the button is held
		vspd = vspdJump;
		acceleration = 4;
		canjump = 0;
	}
	
	if(key_jump_release) jumpCounter = 0; //if jump button is released, you can jump buffer again
	
	if((vspd < 0) && (!key_jump_held) && (dashChecker <= 0)) 
	{
		vspd += (baseGrav*2);
	}
	
	// fast fall
    if (key_dash && key_down && !key_up && dashAirCounter >= 1 && numDashes >=2)
    {
		dashGroundDistance = 400;
		 //Trail Effect
	    with(instance_create_depth(x,y,depth+1,o_trail))
	    {
	        sprite_index = other.sprite_index;
	        image_blend = c_white; //select the color
	        image_alpha = 0.7;
	    }
		fastFalling = true;
        canjump= 0;
        //canDash = true;
		dashSp = dashGroundDistance/dashTime;
		dashEnergy = dashGroundDistance;
		dashDirection = point_direction(0,0,0,key_down);
		vspd = lengthdir_y(dashSp,dashDirection);
        //state = StateFree; // Switch back to free state for jumping
    }
	else
	{
		dashGroundDistance = 0;
	}
	
	// fast fall off of leaving the ground without jumping
    if (key_dash && key_down && !key_up && numDashes == 1 && onGround == false)
    {
		numDashes++;
		canDash = false;
    }
	if (key_dash && key_right && !key_up && numDashes == 1 && onGround == false)
    {
		numDashes++;
		canDash = false;
    }
	if (key_dash && key_left && !key_up && numDashes == 1 && onGround == false)
    {
		numDashes++;
		canDash = false;
    }
	if (key_dash && key_up && numDashes == 1 && onGround == false)
    {
		numDashes++;
		canDash = false;
    }
	
	
	
	var dashAirBool = false;
	if(onGround == true) inAir = false;
	else 
	{
		if(canjump <=0)	dashAirBool = true;
		inAir = true;
	}
	
	show_debug_message(jumpCounter);
}

StateDash = function()
{
    //move via the dash
    hspd = lengthdir_x(dashSp,dashDirection);
    vspd = lengthdir_y(dashSp,dashDirection);
	
	if(UpChecker == true)
	{
		onGround = false
	}
    
    //Trail Effect
    with(instance_create_depth(x,y,depth+1,o_trail))
    {
        sprite_index = other.sprite_index;
        image_blend = c_ltgray; //select the color
        image_alpha = 0.7;
    }
	
	var move = key_right - key_left;
	var _inputs = key_right || key_left || key_up || key_down;
	//if(canDash && !place_meeting(x, y+1, o_wall) && key_dash) //Alt if you don't want to dash on ground
	if(canDash && key_dash && numDashes <= 1  && _inputs)
    {
		if(key_jump && key_up && !key_left && !key_right && move == 0) 
		{
			numDashes++;
			UpChecker = true; //check up they are dashing upward
			onGround = false
		}
		if(key_up && !key_left && !key_right && move == 0) 
		{
			numDashes++;
			UpChecker = true; //check up they are dashing upward
			onGround = false
		}
		else
		{
			numDashes++;
		}
		
		//numDashes++;
		dashChecker++;
		canDash = false;
		//canjump = 0;
		dashDirection = point_direction(0,0,key_right-key_left,key_down-key_up);
		dashSp = dashDistance/dashTime;
		dashEnergy = dashDistance;
		state = StateDash;
	}
	
	
	// fast fall(strict timing)
    if (key_dash && key_down && !key_left && !key_right && !key_up && numDashes >=1)
    {
		dashGroundDistance = 400;
		with(instance_create_depth(x,y,depth+1,o_trail))
	    {
	        sprite_index = other.sprite_index;
	        image_blend = c_blue; //select the color
	        image_alpha = 0.7;
	    }
		//fastFalling = true;
		vspd = lengthdir_y(dashSp,dashDirection);
        canjump= 0;
        //canDash = true;
		dashDirection = point_direction(0,0,0,key_down);
		dashSp = dashGroundDistance/dashTime;
		dashEnergy = dashGroundDistance;
        //state = StateFree; // Switch back to free state for jumping
    }
	else
	{
		dashGroundDistance = 0;
	}
	
    
    //horizontal collision
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
    if (place_meeting(x, y + vspd, o_wall)) 
    {
        var signV = (vspd > 0) - (vspd < 0); // get the direction of movement
        if(vspd < 0) //check if the character is dashing upwards into the ceiling
        {
            while(!place_meeting(x, y + signV, o_wall)) 
            {
                y += signV;
            }
            vspd = 0;
            canjump = 5;
            canDash = false;  // the player can't dash until they touch the ground again.
            state = StateFree; // change state to StateFree
        }
        else // check if the character is dashing downwards into the floor
        {
            while(!place_meeting(x, y + signV, o_wall)) 
            {
                y += signV;
            }
			
            vspd = 0;
            canjump = 5;
            canDash = true; // The player can dash again as they are on the floor
        }
		UpChecker = false;
    }
    else
    {
        y = y + vspd; 
    }
	
	if(key_jump_release) jumpCounter = 0;
    
    //Ending dash
    dashEnergy -= dashSp;
    if(dashEnergy <= 0)
    {
		if(UpChecker == true) 
		{
			vspd = vspd + 8;
			if(vspd > 0) vspd = 0;
	        //hspd = hspd * 1.2;
	        state = StateFree;
		}
		else
		{
	        vspd = vspd + 4;
			if(vspd > 0 && fastFalling == false) vspd = 0;
	        //hspd = hspd * 1.2;
			fastFalling = false;
	        state = StateFree;
		}
		UpChecker = false;
		dashAirCounter++;
    }
}


state = StateFree;
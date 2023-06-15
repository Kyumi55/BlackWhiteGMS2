global.midTransition = false;
global.roomTarget = -1;

//places the sequences n the room
function TransitionPlaceSequence(_type)
{
	if(layer_exists("Transition")) layer_destroy_instances("Transition");
	var _lay = layer_create(-9999, "Transition");
	layer_sequence_create(_lay,0,0,_type);
}

//called whenever you want to go from one room to another, using any combination of in/out sequences
function TransitionStart(_roomTarget, _typeOut, _typeIn)
{
	if(!global.midTransition)
	{
		global.midTransition = true;
		global.roomTarget = _roomTarget;
		TransitionPlaceSequence(_typeOut);
		layer_set_target_room(_roomTarget);
		TransitionPlaceSequence(_typeIn);
		layer_reset_target_room();
		return true;
	}
	else return false;
}

//called as a moment at the end of an "Out" transition sequence
function TransitionChangeRoom()
{
	room_goto(global.roomTarget);
}

//called as a moment at the end of an "In" transition sequence
function TransitionFinished()
{
	layer_sequence_destroy(self.elementID);
	global.midTransition = false;
}
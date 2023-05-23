/// Player Collision with Goal Object
//ScoreKeeper.timeCheck = timerHold;

// C// Calculate minutes and seconds from timerValue
global.timerHoldMins = floor(timerTemp / 60);
global.timerHoldSecs = floor(timerTemp % 60);

// Format minutes and seconds as a string
secondsString = string(global.timerHoldSecs);
if (global.timerHoldSecs < 10)
{
    secondsString = "0" + secondsString;
}

global.timeString = string(global.timerHoldMins) + ":" + secondsString;

//global.timerHold = timerTemp;

//timerTemp = 0;

//timerHold = 0;

room_goto(GoalScreen); // Move player to the next room

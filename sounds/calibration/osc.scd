// WHITENOISE TEST OSC

~ctrl = NetAddr("127.0.0.1", 15300);


// STARTUP funciton
~osc_sound = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Sound (argument " ++ msg[1] ++ ")" );

	if( msg[1]==1, {

		// set all output stage volume to 1
		~array_outputStages.do {
			| synth |
			synth.set(\level, 1);
		};
	},
	{
		// set all output stage volume to 0
		~array_outputStages.do {
			| synth |
			synth.set(\level, 0);
		};
	});
}, "/method/sound", recvPort:15300);

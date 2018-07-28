// STEREOTIPI OSC

~ctrl = NetAddr("127.0.0.1", 15300);

// CLICKED function
~osc_clicked = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Clicked (index" + msg[1] + ").");
	if( msg[1]>=0 && msg[1]<~nspeaker,
		{
			//"true condition".postln;
			// fade out the soundscape volume for the 'i' speaker
			//~array_outputStages[ 0 ].set(\level, 0.05);
			~array_outputStages[ msg[1] ].set(\level, 0.05);

			// play the 'clicked' sound
			~array_pbinds_drop[ msg[1] ].reset;
			~array_pbinds_drop[ msg[1] ].play(quant:0);

		},
		{
			//"false condition".postln;
			"Invalid index".postln;
		}
	);
}, "/method/clicked", recvPort:15300);



// RELEASED function
~osc_released = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Relesaed (index" + msg[1] + ").");
	if( msg[1]>=0 && msg[1]<~nspeaker,
		{
			//"true condition".postln;
			// fade in the soundscape volume for the 'i' speaker
			~array_outputStages[ msg[1] ].set(\level, 1);
		},
		{
			//"false condition".postln;
			"Invalid index".postln;
		}
	);
}, "/method/released", recvPort:15300);



// STARTUP funciton
~osc_sound = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Sound (argument " ++ msg[1] ++ ")" );

	if( msg[1]==1, {

		// start all noises
		~array_noises.do {
			| synth |
			synth.set(\gate, 1);
		};

		// start violins
		~score_violin.play;

		// start fmcalls
		~score_fm.play;

		// start distant bird pbind
		// set all output stage volume to 1
		~array_outputStages.do {
			| synth |
			synth.set(\level, 1);
		};
	},
	{
		// set all output stage volume to 1
		~array_outputStages.do {
			| synth |
			synth.set(\level, 0);
		};

		// stop all noises
		~array_noises.do {
			| synth |
			synth.set(\gate, 0);
		};

		// stop violins
		~score_violin.stop;

		// stop fmcalls
		~score_fm.stop;

		// stop distant bird pbind
		// TODO
	});
}, "/method/sound", recvPort:15300);



/*
// tests //////////////////////////////////

// call something like this in order to trigger the GUI sound
// correspoinding to speaker 'i'
(
~array_pbinds_drop[0].reset;
~array_pbinds_drop[0].play(quant:0);
)



// free all the noises if needed
(
~array_noises.do {
	| synth |
	synth.free;
};
)

// start the noises
~array_noises.do {
	| synth |
	synth.set(\gate, 1);
};
)

(
// stop the noises
~array_noises.do {
	| synth |
	synth.set(\gate, 0);
};
)

(
~array_outputStages.do {
	| synth |
	synth.set(\level, 1);
};
)



// raise or lower the volume of the noises;
(
~array_outputStages[1].set(\level, 1);
)

(
~array_outputStages.do {
	| item |
	item.set(\level, 1);
};
)


// test all GUI sounds simultaneously
(
~array_pbinds_drop.size.do {
	|index|
	//index.postln;
	~array_pbinds_drop[index].reset;
	~array_pbinds_drop[index].play(quant:0);
};
)


(
Synth(\fmcalls,
	[
		\out, ~array_bus_out[0],
], target:~grp_syn
);
)
*/
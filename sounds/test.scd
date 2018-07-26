// STEREOTIPI test


(
s.waitForBoot({

	s.meter;
	s.plotTree;

	// increase the memory used for audio
	s.options.memSize = s.options.memSize * 128;
	s.options.memSize;
	s.options.numOutputBusChannels_(8);

	// Set here the total number of indipendent speakers
	~nspeaker = 2;

	// create groups
	~grp_dropverb = Group.new();
	~grp_drops = Group.new(~grp_dropverb, \addBefore);
	~grp_out = Group.new();
	~grp_syn = Group.new(~grp_out, \addBefore);

	// 1. carica i synth
	// 1bis. crea array e busses e output stagers e riverberi
	// 2. carica lo score
	// 3. carica OSC

	/*
	"MariasoleSynths.scd".loadRelative;
	s.sync;
	"mariasole synths loaded".postln;

	"MariasoleScore.scd".loadRelative;
	s.sync;
	"mariasole score loaded".postln;

	"MariasoleOsc.scd".loadRelative;
	s.sync;
    "mariasole osc loaded".postln;
	*/
});
)

// Drops auxilaries and fxs
(
~array_aux_dropverb = Array.fill(~nspeaker, {
	arg i;
	Bus.audio(s,1);
});

~array_dropverb = Array.fill(~nspeaker, {
	arg i;
	Synth(\dropverb,
		[
			\in, ~array_aux_dropverb[i],
			\out, i
		],
		target:~grp_dropverb
	);
});

// Create a Pbind for each individual output speaker/monitor
~array_pbinds_drop = Array.fill(~nspeaker, {
	arg i;
	// This is the GUI/drop score
	Pbind(
		\instrument, \drop,
		\group, ~grp_drops,
		\out, ~array_aux_dropverb[i],
		\amp, 0.3,
		\drywet, Pgeom(1, 0.8, inf),
		\degree, Prand(Scale.majorPentatonic.degrees, inf),
		\octave, Pseq([ 4, Pwrand([5, 6, 7],[1,4,6].normalizeSum, inf)],inf),
		\dur, Pwrand([0.25, 0.33, 0.125], [6,3, 8].normalizeSum, 3 )
	).asEventStreamPlayer;
});
)


// call something like this in order to trigger the GUI sound
// correspoinding to speaker 'i'
(
~array_pbinds_drop[0].reset;
~array_pbinds_drop[0].play(quant:0);
)



// GRP: create SYN & OUTPUT STAGE groups
(
~array_bus_out = Array.fill(~nspeaker, {
	arg i;
	Bus.audio(s,1);
});

~array_outputStages = Array.fill(~nspeaker, {
	arg i;
	Synth(\outputStage,
		[
			\in, ~array_bus_out[i],
			\out, i
		],
		target:~grp_out
	);
});
)


/* NOISES ************************/

(
// populate the array of noise synths,
// create and place them in their group.
~array_noises = Array.fill( 4, {
	arg i;
	"new noise created".postln;
	Synth(\fnoise, [\out, ~array_bus_out[0], \gate,1], target:~grp_syn);
});
)


// free all the noises if needed
(
~array_noises.do {
	| synth |
	synth.free;
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


// TEST ///////////////////////////////////////

// test all GUI sounds simultaneously
(
~array_pbinds_drop.size.do {
	|index|
	//index.postln;
	~array_pbinds_drop[index].reset;
	~array_pbinds_drop[index].play(quant:0);
};
)
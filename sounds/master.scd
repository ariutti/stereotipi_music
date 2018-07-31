// STEREOTIPI Master!

(
s = Server.local;
//s.options.device = "ASIO : US-16x08 ASIO";

// Set here the total number of indipendent speakers
// solve the fact that a number greater than 4 can cause the error:
// JackDriver: exception in real time: alloc failed, increase server's memory allocation (e.g. via ServerOptions)
~nspeaker = 8;

// increase the memory used for audio
//s.options.memSize = s.options.memSize * 100;
s.options.numOutputBusChannels_(~nspeaker);
s.options.numInputBusChannels_(2);

s.waitForBoot({

	// create groups
	~grp_dropverb = Group.new();
	~grp_drops = Group.new(~grp_dropverb, \addBefore);
	~grp_out = Group.new();
	~grp_syn = Group.new(~grp_out, \addBefore);

	s.sync;

	"synths.scd".loadRelative;
	s.sync;
	"synths loaded".postln;


	// create routing, fx and groups so basically:

	// 1. create auxilaries for drop's fx

	~array_aux_dropverb = Array.fill(~nspeaker, {
		arg i;
		Bus.audio(s,1);
	});

	// 2. create and array of verbs

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

	// 3. create a Pbind for each individual output speaker/monitor

	~array_pbinds_drop = Array.fill(~nspeaker, {
		arg i;
		// This is the GUI/drop score
		Pbind(
			\instrument, \drop,
			\group, ~grp_drops,
			\out, ~array_aux_dropverb[i],
			\amp, 0.3,
			\drywet, Pgeom(1, 0.8, inf),
			\degree, Prand(Scale.majorPentatonic.degrees, inf).trace,
			\octave, Pseq([ 4, Pwrand([5, 6, 7],[1,4,6].normalizeSum, inf)],inf),
			\dur, Pwrand([0.25, 0.33, 0.125], [6,3, 8].normalizeSum, 3 )
		).asEventStreamPlayer;
	});

	// create SYN & OUTPUT STAGE groups

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

	// now that auxilaries, busses, groups and fx synth have been created
	// we are ready to create the actual synths


	// populate the array of 4 noise synths, create and place them in their group.
	~array_noises = Array.fill( 4, {
		arg i;
		"new noise created".postln;
		Synth(\fnoise, [\out, ~array_bus_out[0], \gate,0], target:~grp_syn);
	});

	s.sync;


	"score.scd".loadRelative;
	s.sync;
	"score loaded".postln;

	"osc.scd".loadRelative;
	s.sync;
	"osc loaded".postln;

});
)



/*
// TEST ///////////////////////////////////////

*/
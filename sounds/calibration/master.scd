// STEREOTIPI Master!

/*
We are using these samples:
* cello samples by Philarmonia Orchestra (http://www.philharmonia.co.uk/explore/sound_samples);
* piano samples by neatonk (MISStereoPiano pack on freesound https://freesound.org/people/neatonk/packs/9133/);
*/

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
	~grp_out = Group.new();
	~grp_syn = Group.new(~grp_out, \addBefore);

	s.sync;

	"synths.scd".loadRelative;
	s.sync;
	"synths loaded".postln;

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

	~white = Synth(\whitetest, [\out, ~array_bus_out[0] ]);

	"osc.scd".loadRelative;
	s.sync;
	"osc loaded".postln;

});
)

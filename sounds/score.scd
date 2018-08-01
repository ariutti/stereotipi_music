// STEREOTIPI Score

// SCORE: Cello (w/ major Pentatonic)
// these variables are used to scale down volume of higher violin notes
var y1 = 1;
var y2 = 0.5;

// load samples from disk.
~cello_samples = Array.new;
~piano_samples = Array.new;
Platform.case(
    \osx,       {
		"OSX".postln;

	},
    \linux,     {
		"Linux".postln;
		~cello_folder = PathName.new("/home/nicola/Musica/philarmonic_orchestra/cello/renamed/wav/");
		~piano_folder = PathName.new("/home/nicola/Musica/neatonk_misstereopiano/med/");
	},
    \windows,   {
		"Windows".postln;
		~cello_folder = PathName.new("C:/Users/nicola/Music/philarmonic_orchestra/cello/renamed/wav/");
		~piano_folder = PathName.new("C:/Users/nicola/Music/TODO");
	}
);

~cello_folder.entries.do({
	arg path;
	//path.postln
	~cello_samples = ~cello_samples.add(Buffer.read(s, path.fullPath));
});
//~cello_samples.size;

~bass = Pbind(
	\instrument, \grain_cello,
	\group, ~grp_syn,
	\out, ~array_bus_out[0],
	\octave, Pwrand([3,4],[7,3].normalizeSum, inf)*12,
	\midinote, Pkey(\octave) + 0,
	\sndbuf, Pindex(~cello_samples, Pkey(\midinote)-36),
	\dur, Pwhite(15, 20),
	\rt, 1.01, // the first sample is a bit out of tune
	\atk, 5,
	\rls, 5,
	\amp, 0.60,
	\type, Pwrand([\note, \Rest], [7,1].normalizeSum, inf)
);

~violin = Pbind(
	\instrument, \grain_cello,
	\group, ~grp_syn,
	\out, ~array_bus_out[0],
	\octave, Pxrand([4,5,6],inf),
	\midinote, Pkey(\octave)*12 + 0 + Pxrand( Scale.majorPentatonic.degrees, inf) ,
	\sndbuf, Pindex(~cello_samples, Pkey(\midinote)-36),
	\dur, Pwhite(10, 15),
	\atk, 5,
	\rls, 5,
	\legato, Pwhite(0.25, 0.75),
	\amp, (((Pkey(\midinote)-56 )/ 24) * (y2-y1) + y1),
);


//~score_violin = Ppar([~bass,~violin,~violin,~violin]).asEventStreamPlayer;
// let's try with more violins (12 of them)
~score_violin = Ppar([
	~bass,
	~violin,~violin,~violin,~violin,
	~violin,~violin,~violin,~violin,
	~violin,~violin,~violin,~violin
]
).asEventStreamPlayer;

// FM score (w/ major Pentatonic)
~score_fm = Pbind(
	\instrument, \fmcalls,
	\group, ~grp_syn,
	// select one of the ~nspeaker possible outputs
	\out, Pindex(~array_bus_out, Prand((0..~nspeaker-1), inf)),
	\octave, 4, // +53
	\degree, Prand(Scale.majorPentatonic.degrees, inf),
	\dlytime, 3.reciprocal, //Prand([3, 4, 8], inf).reciprocal,
	\dynamic, Pexprand(0.01, 0.9, inf),
	\timbre, Pkey(\dynamic).reciprocal,
	\atk, Pkey(\dynamic) * 0.1,
	\rls, Pkey(\dynamic) * 0.5,
	\amp, 0.2, //Pwhite(0.15, 0.2, inf),
	//\pos, Prand((0..~nspeaker-1), inf).trace, //(-0.8, 0.8),
	\intervallo, Prand([10,7,9],inf),
	\dur, (Pkey(\dynamic).reciprocal).min(Pkey(\intervallo)),
).asEventStreamPlayer;




// Piano
/*
Platform.case(
    \osx,       {
		"OSX".postln;

	},
    \linux,     {
		"Linux".postln;
		~piano_folder = PathName.new("/home/nicola/Musica/neatonk_misstereopiano/med/");
	},
    \windows,   {
		"Windows".postln;
		~piano_folder = PathName.new("C:/Users/nicola/Music/TODO");
	}
);
*/

~piano_folder.entries.do({
	| path |
	//path.postln;
	~piano_samples = ~piano_samples.add(Buffer.read(s, path.fullPath));
});
~piano_samples.size;

~score_piano_part = Pbind(
	\instrument, \piano,
	\group, ~grp_syn,
	\out, Pindex(~array_bus_out, Prand((0..~nspeaker-1), inf)),
	\degree, Pxrand(Scale.majorPentatonic.degrees, inf),
	\root, 0,
	\octave, Prand([5, 6, 7],inf),
	\midinote, Pkey(\octave)*12 + Pkey(\root) + Pkey(\degree),
	//\midinote, 60,
	\sndbuf, Pindex( ~piano_samples, Pkey(\midinote)-23, inf),
	\vel, Pwhite(64, 100, inf),
	\amp, 0.9,
	\dur, Prand([2, 1, 1/2, 1/4, 1/8], inf),
	\legato, 2,
	\type, Pwrand( [\note, \Rest], [4,6].normalizeSum, inf),
);

~score_piano = Ppar([ ~score_piano_part, ~score_piano_part ]).asEventStreamPlayer;




/*
// TODO: SCORE: distant birds
~distant_bird = Synth(\distant_bird, [
	\f, rrand(3000, 10000),
	\dcy, rrand(1, 3),
	\amp, rrand(0.2, 0.6),
	\pos, rrand(-0.8, 0.8);
]);
*/

/*
// UNUSED STUFF ////////////////////////////////////

//~gui_verb = Synth(\gui_fx, [\in, ~aux_gui_verb]);

~score_gui = Pbind(
	\instrument, \drop,
	\out, ~aux_gui_verb,
	\amp, 0.3,
	\drywet, Pgeom(1, 0.8, inf),
	\degree, Prand(Scale.majorPentatonic.degrees, inf),
	\octave, Pseq([ 4, Pwrand([5, 6, 7],[1,4,6].normalizeSum, inf)],inf),
	\dur, Pwrand([0.25, 0.33, 0.125], [6,3, 8].normalizeSum, 3 )
).asEventStreamPlayer;


//(
//~aux_cello_verb = Bus.audio(s, 1);
//~rev_cello = Synth(\rev, [\in, ~aux_cello_verb]);
//)


// F, A-flat, and from the next octave C, D-flat, E-flat, F, and A-flat.
// see also http://teropa.info/blog/2016/07/28/javascript-systems-music.html#the-notes-and-intervals-in-music-for-airports
~eno_scale = [3, 7, 8, 10, 12, 15];
*/
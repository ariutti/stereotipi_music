// STEREOTIPI Score

// SCORE: Cello (w/ major Pentatonic)
// these variables are used to scale down volume of higher violin notes
var y1 = 1;
var y2 = 0.5;

// load sound from disk.
~samples = Array.new;
//~folder = PathName.new("C:/Users/nicola/Music/philarmonic_orchestra/cello/renamed/wav/");
~folder = PathName.new("/home/nicola/Musica/philarmonic_orchestra/cello/renamed/wav/");
~folder.entries.do({
	arg path;
	//path.postln
	~samples = ~samples.add(Buffer.read(s, path.fullPath));
});
//~samples.size;

~bass = Pbind(
	\instrument, \grain_cello,
	\group, ~grp_syn,
	\out, ~array_bus_out,
	\octave, Pwrand([3,4],[7,3].normalizeSum, inf)*12,
	\midinote, Pkey(\octave) + 0,
	\sndbuf, Pindex(~samples, Pkey(\midinote)-36),
	\dur, Pwhite(15, 20),
	\rt, 1.01, // the first sample is a bit out of tune
	\atk, 5,
	\rls, 5,
	\amp, 0.40,
	\type, Pwrand([\note, \Rest], [7,1].normalizeSum, inf)
);

~violin = Pbind(
	\instrument, \grain_cello,
	\group, ~grp_syn,
	\out, ~array_bus_out,
	\octave, Pxrand([4,5,6],inf),
	\midinote, Pkey(\octave)*12 + 0 + Pxrand( Scale.majorPentatonic.degrees, inf) ,
	\sndbuf, Pindex(~samples, Pkey(\midinote)-36),
	\dur, Pwhite(10, 15),
	\atk, 5,
	\rls, 5,
	\legato, Pwhite(0.25, 0.75),
	\amp, (((Pkey(\midinote)-56 )/ 24) * (y2-y1) + y1),
);

~score_violin = Ppar([~bass, ~violin,~violin,~violin]).asEventStreamPlayer;


// FM score (w/ major Pentatonic)
~score_fm = Pbind(
	\instrument, \fmcalls,
	\group, ~grp_syn,
	\out, Pindex(~array_bus_out, Prand((0..~nspeaker-1), inf)),
	\octave, 4, // +53
	\degree, Prand(Scale.majorPentatonic.degrees, inf),
	\dlytime, Prand([3, 4, 8], inf).reciprocal,
	\dynamic, Pexprand(0.01, 0.9, inf),
	\timbre, Pkey(\dynamic).reciprocal,
	\atk, Pkey(\dynamic) * 0.1,
	\rls, Pkey(\dynamic) * 0.5,
	\amp, Pwhite(0.15, 0.3, inf),
	//\pos, Prand((0..~nspeaker-1), inf).trace, //(-0.8, 0.8),
	\intervallo, Prand([10,7,9],inf),
	\dur, (Pkey(\dynamic).reciprocal).min(Pkey(\intervallo)),
).asEventStreamPlayer;


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
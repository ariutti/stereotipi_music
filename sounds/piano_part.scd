// load sound from disk.
(
~piano_samples = Array.new;
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

~piano_folder.entries.do({
	| path |
	//path.postln;
	~piano_samples = ~piano_samples.add(Buffer.read(s, path.fullPath));
});
~piano_samples.size;
)


(
SynthDef(\piano, {
	|
	sndbuf, vel=64, gate=1, rate=1,
	amp=1.0, out=0
	|
	var sig, env, level;
	env = EnvGen.kr(Env.asr(), gate, doneAction:2);
	sig = PlayBuf.ar(2, sndbuf, rate*BufRateScale.ir( sndbuf ));
	level = LinExp.kr(vel, 1, 127, 0.01, 1);
	sig = sig * env * level * amp;
	sig = FreeVerb.ar(sig, 0.7, 0.6, 0.7);
	Out.ar(out, sig);
}).add;


~score_piano_part = Pbind(
	\instrument, \piano,
	\out, 0,
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
	\type, Pwrand( [\note, \Rest], [6,4].normalizeSum, inf),
);

~score_piano = Ppar([ ~score_piano_part, ~score_piano_part ]).asEventStreamPlayer;
)

~score_piano.play;
~score_piano.stop;


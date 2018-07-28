// GUI sounds: drop & dropverb
// these are the sound you hear when you make a "click"
SynthDef(\drop, {
	|
	out=0, drywet=0, freq=440, cutoff=880,
	bwr=0.01, sus=0.5, tatk=0.001, tdecay=0.04,
	tsus=0.5, trel=0.5, amp=0.25
	|
	var sig, env;
	//env = EnvGen.kr(Env([0, 1, sus, sus*0.8, 0], [tatk, tdecay, tsus, trel]), doneAction:2 );
	env = EnvGen.kr(Env.perc(), doneAction:2 );
	sig = SinOsc.ar(freq) * env * amp;
	//sig = BLowPass.ar(sig, XLine.kr(freq, freq*3, tdecay), 100);
	//Out.ar(dryOut, sig * drywet);
	//Out.ar(wetOut, sig * (1.0-drywet) );
	Out.ar(out, sig );
}).add;

SynthDef(\dropverb, {
	|in=0, out=0|
	var sig = In.ar(in, 1);
	//sig = sig + CombN.ar(sig, 1.5, 0.25, 1.4);
	//sig = FreeVerb.ar(sig, 0.7, 0.5, 0.7);
	Out.ar(out, sig);
}).add;



b = Bus.audio(s,1);
y = Synth(\dropverb, [\in, b, \out, 0] );


z = Pbind(
	\instrument, \drop,
	//\group, ~grp_drops,
	\out, b,
	\amp, 0.3,
	//\drywet, Pgeom(1, 0.8, inf),
	\degree, Prand(Scale.majorPentatonic.degrees, inf).trace,
	\octave, 4, //Pseq([ 4, Pwrand([5, 6, 7],[1,4,6].normalizeSum, inf)],inf),
	\dur, Pseq([1],1) //Pwrand([0.25, 0.33, 0.125], [6,3, 8].normalizeSum, 3 )
).asEventStreamPlayer;

(
z.play(doReset:true, quant:0);
z.reset;
)
z.stop;

~array_pbinds_drop[ 0 ].reset;
~array_pbinds_drop[ 0 ].play;
~array_pbinds_drop = [];



(
z = Pbind(
	\dur, Pseq([0.1], 1)
).play(quant:0);
)
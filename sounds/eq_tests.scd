BPeakEQ
MidEQ
BLowShelf
BLowPass

s.freqscope;


// MIDFREQ test
(
SynthDef(\noise, {
	|freq=1000, q=1, db=0|
	var sig;
	sig = WhiteNoise.ar();
	db = MouseY.kr(-50, 24);
	freq = MouseX.kr(60, 5000);
	sig = MidEQ.ar(sig, freq, q.reciprocal, db);
	Out.ar(0, sig!2);
}).add;
)

x = Synth(\noise);
x.set(\q, 1);
x.free;



// LOW PASS test
(
SynthDef(\noise, {
	|freq=1000, rs=1, db=1|
	var sig;
	sig = WhiteNoise.ar();
	freq = MouseX.kr(60, 5000);
	sig = BLowPass.ar(sig, freq, rs, db);
	Out.ar(0, sig!2);
}).add;
)

y = Synth(\noise);
y.set(\rs, 1);
y.free;

// LOW SHELF test
(
SynthDef(\noise, {
	|freq=1000, rs=1, db=1|
	var sig;
	sig = WhiteNoise.ar();
	db = MouseY.kr(-50, 24);
	freq = MouseX.kr(60, 5000);
	sig = BLowShelf.ar(sig, freq, rs, db);
	Out.ar(0, sig!2);
}).add;
)

y = Synth(\noise);
y.set(\rs, 1);
y.free;


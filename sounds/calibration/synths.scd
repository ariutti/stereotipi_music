// STEREOTIPI Synth Defs

// create the synth definitions

// OUTPUT STAGE: is a volume controlled synth
SynthDef(\outputStage, {
	|in=0, out=0, amp=1.0,
	level=0, lagTime=5
	// MidEq arguments
	//freq = 1500, q=1, db=(-3)
	mid_freq1 = 1500, mid_q1=1, mid_db1 =0,
	mid_freq2 = 3000, mid_q2=1, mid_db2 =0,
	mid_freq3 = 6000, mid_q3=1, mid_db3 =0,
	// filters arguments
	lpf_freq = 15000,
	hpf_freq = 60
	|
	var sig;
	sig = In.ar( in );
	sig = MidEQ.ar(sig, mid_freq1, mid_q1.reciprocal, mid_db1);
	sig = MidEQ.ar(sig, mid_freq2, mid_q2.reciprocal, mid_db2);
	sig = MidEQ.ar(sig, mid_freq3, mid_q3.reciprocal, mid_db3);
	sig = LPF.ar(sig, lpf_freq);
	sig = HPF.ar(sig, hpf_freq);
	sig = sig * VarLag.kr( level, lagTime ) * amp;
	Out.ar(out, sig);
}).add;


// white noise synth for testing purposes
SynthDef(\whitetest, {
	|out=0|
	var sig = WhiteNoise.ar();
	Out.ar(out, sig!8);
}).add;

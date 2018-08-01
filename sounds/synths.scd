// STEREOTIPI Synth Defs

// create the synth definitions

// OUTPUT STAGE: is a volume controlled synth
SynthDef(\outputStage, {
	|in=0, out=0, amp=1.0,
	level=0, lagTime=5
	freq = 1500, rq=1, db=(-3)|
	var sig;
	sig = In.ar( in );
	sig = MidEQ.ar(sig, freq, rq, db);
	sig = sig * VarLag.kr( level, lagTime ) * amp;
	Out.ar(out, sig);
}).add;


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


// SOUNDSCAPE: cellos
SynthDef(\grain_cello, {
	|out=0, gate=1, amp=0.9, sndbuf, atk=5, rls=5, rt=1|
    var sig, pan=0, env;

	//var density = LFNoise0.kr(25).range(10, 15);
	var density = LFNoise0.kr(25).range(1, 5);
	var trigger = Impulse.kr( density );
	var pos = 0.5 + TRand.kr(trigger, -0.125, 0.125);
	var rate = rt;// + TRand.kr(trigger, -0.005, 0.005);
	var length = 1 + TRand.kr(trigger, 0.25, 0.35);

	env = EnvGen.kr(Env.asr(atk, 1, rls, -4), gate, doneAction:2);

    sig = GrainBuf.ar(1,
		trigger,
		length,
		sndbuf,
		rate,
		pos,
		2,
		pan: pan);

	sig = sig * amp * env;
	//sig = BRF.ar(sig, 1500, 1);

	// mono output on all speakers
	//Out.ar(out, sig!~nspeaker);
	// spacialized output
	Out.ar(out, PanAz.ar( ~nspeaker, sig, LFNoise2.kr(0.1).range(-1,1)) );
}).add;



// SOUNDSCAPE: fm calls
SynthDef(\fmcalls, {
	|
	amp=0.25, pos=0, midinote=67,
	maxdlytime=3.1, dlytime=0.25, dcytime=1.4,
	timbre=1, atk=0.001, rls=0.01, out=0
	|
	var sig, env, freq;
	env = EnvGen.ar(Env.perc(atk, rls));
	//sig = SinOsc.ar( midinote.midicps )*env;
	freq = midinote.midicps;
	sig = PMOsc.ar(freq, freq*10, timbre) * env;
	sig = sig + AllpassN.ar(sig, maxdlytime, dlytime, dcytime);
	sig = LPF.ar(sig, 5000);
	sig = sig * amp;
	DetectSilence.ar(sig, 0.0001, 0.4, doneAction:2);
	//Out.ar(out, PanAz.ar(sig, pos));
	//[timbre, freq.cpsmidi, dlytime, amp].poll(label: [\timbre, \midi, \dlytime, \amp]);
	Out.ar(out, sig);
}).add;



// SOUNDSCAPE: filter noise

SynthDef(\fnoise, {
	|out=0, amp = 0.125, gate=0, nchannels=2|
	var sig,freq, env;
	env = EnvGen.kr(Env.asr(5,1,5),gate,doneAction:0);
	sig = WhiteNoise.ar();
	sig = sig * env;
	freq = LFNoise2.kr(0.1).range(3500, 6000);
	sig = BPF.ar(sig, freq, 0.001);
	sig = sig * amp;
	Out.ar(out, sig!~nspeaker );
	//Out.ar(out, sig!2 );
}).add;



// SOUNDSCAPE: distant bird
SynthDef(\distant_bird, {
	| amp=0.75, f=8000 ,dcy=2, pos=0|
	var sig,freq,env;
	env = EnvGen.ar(Env.perc(0.1, dcy), doneAction:2);
	sig = WhiteNoise.ar() * env;
	freq = SinOsc.kr(Line.ar(0,1, dcy).exprange(1,7)).range(f, f*2) ;
	sig = BPF.ar(sig, freq, 0.001);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;

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
	//Out.ar(out, sig);
	// Need to mix down the stereo instrument to a mono output
	Out.ar(out, Mix.ar(sig) );
}).add;

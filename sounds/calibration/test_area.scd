// White TEST AREA
(
s.meter;
s.plotTree;
s.freqscope;
)

~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);

(
// change levels of output stages
~array_outputStages.do {
	|out_stage|
	//"hello".postln;
	out_stage.set(
		\amp, 0.7
	);
}
)

(
// change some eq configuration
~array_outputStages.do {
	|out_stage|
	//"hello".postln;
	out_stage.set(
		// mid eq 1
		\mid_freq1, 1300,
		\mid_q1, 25,
		\mid_db1, (-10),
		// mid eq 2
		\mid_freq2, 6300,
		\mid_q2, 50,
		\mid_db2, (-6),
		// mid eq 3
		\mid_freq3, 250,
		\mid_q3, 0.25,
		\mid_db3, 6,
		// filters
		\lpf_freq, 15000,
		\hpf_freq, 30,
	);
}
)

(
// change some eq configuration
~array_outputStages.do {
	|out_stage|
	//"hello".postln;
	out_stage.set(
		// mid eq 1
		\mid_freq1, 1300,
		\mid_q1, 1,
		\mid_db1, 0,
		// mid eq 2
		\mid_freq2, 6300,
		\mid_q2, 1,
		\mid_db2, 0,
		// mid eq 3
		\mid_freq3, 300,
		\mid_q3, 1,
		\mid_db3, 0,
		// filters
		\lpf_freq, 15000,
		\hpf_freq, 30,
	);
}
)

~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);
~ctrl.sendMsg("/method/clicked", 1);
~ctrl.sendMsg("/method/released", 1);

(
s.meter;
s.plotTree;
s.freqscope;
)

(
8.do {
	|item|
	~ctrl.sendMsg("/method/released", item);
}
)

s.latency;

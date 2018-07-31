~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);
~ctrl.sendMsg("/method/clicked", 0);
~ctrl.sendMsg("/method/released", 0);

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

Decay2
PlayN
OffsetOut
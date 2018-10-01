// TEST AREA
(
s.meter;
s.plotTree;
s.freqscope;
)


~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);
~ctrl.sendMsg("/method/clicked", 2);
~ctrl.sendMsg("/method/released", 2);


(
// click all
~nspeaker.do {
	|item|
	~ctrl.sendMsg("/method/clicked", item);
}
)

(
// release all
~nspeaker.do {
	|item|
	~ctrl.sendMsg("/method/released", item);
}
)
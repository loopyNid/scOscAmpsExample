(
~bus1 = Bus.control(s);
~bus2 = Bus.control(s);
~bus3 = Bus.control(s);
~godotAddress = NetAddr("127.0.0.1", 14000);// address to send amplitudes
SynthDef(\player, {|amp = 0.2|
	var src, low, mid, hi, sendLow, sendMid, sendHi;
	src = In.ar(0);// audio in
	low = BLowPass.ar(src, 600); 
	mid = BHiPass.ar(src);
	hi = BHiPass.ar(src, 2400, 1);
	sendLow = Amplitude.kr(src).ampdb.linlin(-60.0, 0.0, 0.0, 1.0);
	sendMid = Amplitude.kr(mid).ampdb.linlin(-60.0, 0.0, 0.0, 1.0);
	sendHi = Amplitude.kr(hi).ampdb.linlin(-60.0, 0.0, 0.0, 1.0);
	Out.kr(~bus1, sendLow);
	Out.kr(~bus2, sendMid);
	Out.kr(~bus3, sendHi);
}).play;
OSCdef(\getamp, {
	~godotAddress.sendMsg("/amp", ~bus1.getSynchronous.asFloat, ~bus2.getSynchronous.asFloat, ~bus3.getSynchronous.asFloat);
}, "/getamp");
)

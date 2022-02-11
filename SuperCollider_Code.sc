s.boot;
s.reboot;
s.scope;
s.meter;
FreqScope.new;

~n1 = NetAddr.new("127.0.0.1", 12000);
~n1.port;

///////////////////////// End of Arduino Region/////////////////////////////


          ////////////<< summary of add SynthDefs >> /////////////

(
SynthDef.new(\synthP, {
	arg atk = 2 , sus = 0, rel = 5, c1 = 1, c2 = (-1),
	freq = 500, cfmin = 125, cfmax=220, rqmin = 0.1, rqmax = 0.2, amp =1, detune=0.2,pan=0, out=0;
	var sig, env, pm;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel],[c1,0,c2]),doneAction:2);
	sig = Pulse.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}, 0.3, 1, 1);
	sig = BPF.ar(sig,{LFNoise1.kr(0.2).exprange(cfmin,cfmax)},
		             {LFNoise1.kr(0.1).exprange(rqmin,rqmax)});
	//pm = PMOsc.kr(freq * 2, 4, 10) * 0.2!2; // Phase modulator Oscillator FM SYnthesis //
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

SynthDef.new(\blip, {
	arg atk = 2 , sus = 0, rel = 5, c1 = 1, c2 = (-1),
	freq = 80, cfmin = 500, cfmax=2000, rqmin = 0.1, rqmax = 0.2, amp =1, detune=0.2,pan=0, out=0;
	var sig, env, micIn;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel],[c1,0,c2]),doneAction:2);
	sig = Pulse.ar(freq* {LFNoise1.kr(0.5,detune).midiratio});
	//micIn = SoundIn.ar(0);
	sig = BPF.ar(sig,{LFNoise1.kr(220).exprange(cfmin,cfmax)},
		             {LFNoise1.kr(80).exprange(rqmin,rqmax)});
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;


///////////////////////////////////// Reverb Taken by Elli FueldSteel //////////////////////////////////////

SynthDef.new(\reverb,{
	arg in, predelay = 0.1, revtime = 3, lpf = 4500, mix = 1, amp = 1, out = 0;
	var dry, wet, temp, sig;
	dry = In.ar(in,2);
	temp = In.ar(in,2);
	wet = 0;
	temp = DelayN.ar(temp, 0, 2, predelay);
	16.do{
		temp = AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2, revtime);
		temp = LPF.ar(temp, lpf);
		wet = wet + temp;
	};
	sig = XFade2.ar(dry,wet,mix*2-1,amp);
	Out.ar(out,sig);
}).add;

///////////////////////////////////// Evaluate The Reverb//////////////////////////////////////////////////

~reverbBus = Bus.audio(s,2);
~reverbSynth = Synth(\reverb,[\in,~reverbBus]);

///////////////////////////////////// Evaluate The Instruments/////////////////////////////////////////////
)



(
~stem = Pbind (
	\instrument, \synthP,
	\dur,Prand([0,1,2],inf),
	\freq, Prand([80, 40, 60, 90, 120, 100, 150, 200, 250], inf),

	//\myOtherParameter, Prand([0.1, 0.7]),
	\detune,Pwhite(0.5,0.7,inf),
	\rqmin,0.005,
	\rqmax,0.008,
	\cfmin,Prand((Scale.minor.degrees+64).midicps,inf)*Prand([0.5,1,2,4],inf),
	\cfmax,Pkey(\cfmin)*Pwhite(1.008,1.025,inf),
	\atk, 3,
	\sus,1,
	\rel,5,
	\amp,7,
	\pan, Pwhite(-0.8, 0.8, inf),
	\osc, Pfunc {|e| ~n1.sendMsg('/moveValuesY',(e[\freq] / 2).postln, e[\freq].postln, (e[\freq] / 4).postln, e[\dur].postln)},
	\out, ~reverbBus,
).play;

// ~n1.sendMsg('\moveValuesY',e[\detune], e[\freq])
)


~stem.free;
~stem.stop;


(
~stem2 =  Pbind(
	\instrument, \synthP,
	\dur,Pseq([0.2,0.3,0.6,0.7],inf),
	\freq, rrand(100,900),
	// \osc, Pfunc {|e| ~n1.sendMsg('/moveValuesY',e[\dur].postln, e[\freq].postln)},
	\ctranspose, -12 ,
	\detune, Pwhite(0.1,0.3,inf),
	\rqmin,0.05,
	\rqmax,0.08,
	\cfmin,Prand((Scale.minor.degrees+12).midicps,inf)*Prand([0.5,1,2,3],inf),
	\cfmax,Pkey(\cfmin)*Pwhite(1.008,1.025,inf),
	\atk, 0.4,
	\sus,0.9,
	\rel,0.8,
	\amp, 3,
	\pan, Pwhite(-1, 1, inf),
	\out, ~reverbBus
).play;
)


~stem2.free;
~stem2.stop;


(
~inst2 = Pbind(
	\instrument, \synthP,
	\dur,Prand([0.4,8],inf),
	\freq, Pseq([0.2,0.3,0.6,0.7],inf),
	\ctranspose, 12,
	\detune,Pwhite(-0.15,1.75,inf),
	\rqmin,0.05,
	\rqmax,0.08,
    \cfmin,Prand((Scale.minor.degrees+32).midicps,inf)*Prand([0.5,1,2,4],inf),
	\cfmax,Pkey(\cfmin)*Pwhite(1.8,1.25,inf),
	\atk,0.8,
	\sus,1,
	\rel,2,
	\amp, 2,
	\pan, Pwhite(0.4,-0.4, inf),
	\out, ~reverbBus
).play;
)



~inst2.free;
~inst2.stop;

s.freeAll;

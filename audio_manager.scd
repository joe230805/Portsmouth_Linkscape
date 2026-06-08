(
~oscPort = 57121;
~flag = nil;

~sensorStates = [0,0,0,0,0];
~isPlaying = [0,0,0,0,0];

s.waitForBoot{
    ~files = [
        thisProcess.nowExecutingPath.dirname +/+ "beach audio/Seagulls.wav",
        thisProcess.nowExecutingPath.dirname +/+ "beach audio/steps-beach.wav",
        thisProcess.nowExecutingPath.dirname +/+ "beach audio/waves-beach.wav",
        thisProcess.nowExecutingPath.dirname +/+ "castle audio/fountains-Castle.wav",
        thisProcess.nowExecutingPath.dirname +/+ "castle audio/leaves-Castle.wav",
        thisProcess.nowExecutingPath.dirname +/+ "castle audio/Seagulls.wav",
        thisProcess.nowExecutingPath.dirname +/+ "guildhall/crossing beep.wav",
        thisProcess.nowExecutingPath.dirname +/+ "guildhall/trains.wav",
        thisProcess.nowExecutingPath.dirname +/+ "guildhall/walking.wav",
        thisProcess.nowExecutingPath.dirname +/+ "fratton/walking.wav",
        thisProcess.nowExecutingPath.dirname +/+ "fratton/trains.wav",
        thisProcess.nowExecutingPath.dirname +/+ "fratton/cheering.wav",
        thisProcess.nowExecutingPath.dirname +/+ "spinnaker/clanging.wav",
        thisProcess.nowExecutingPath.dirname +/+ "spinnaker/waves-beach.wav",
        thisProcess.nowExecutingPath.dirname +/+ "spinnaker/wind.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Hotwalls.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Southsea castle.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Guildhall.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Fratton Park.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Spinnaker.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Southsea castle and the Hotwalls.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Hotwalls and guildhall.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/fratton park and guildhall.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Guildhall and spinnaker tower.wav",
        thisProcess.nowExecutingPath.dirname +/+ "voiceovers/Fratton park and spinnaker.wav"
    ];

    ~sensorStates = [0,0,0,0,0];
    ~numSlots = 3;
    ~buffers = Array.newClear(~numSlots + 1);  //sample rate * file run time
    ~synths = Array.newClear(~numSlots + 1);
    //numSlots + 1 to add space for the voiceovers
};

~magnet1Detected = {
    "Magnet 1 Triggered".postln;
    if(~isPlaying[0] != 1,{
        if(~isPlaying[1] == 1,{~loadBeachSounds.(20);},{
            if(~isPlaying[2] == 1,{~loadBeachSounds.(21);},{
                ~loadBeachSounds.(15);
            });
        });
    });
    "Loading Beach".postln;
    ~isPlaying[0] = 1;
};

~magnet2Detected = {
    "Magnet 2 Triggered".postln;
    if(~isPlaying[1] != 1,{
        if(~isPlaying[0] == 1,{~loadCastleSounds.(20);},{
            ~loadCastleSounds.(16);
        });
    });
    "Loading Castle".postln;
    ~isPlaying[1] = 1;
};

~magnet3Detected = {
    "Magnet 3 Triggered".postln;
    if(~isPlaying[2] != 1,{
        if(~isPlaying[0] == 1,{~loadGuildhallSounds.(21);},{
            if(~isPlaying[3] == 1,{~loadGuildhallSounds.(22);},{
                if(~isPlaying[4] == 1,{~loadGuildhallSounds.(23);},{~loadGuildhallSounds.(17);});
            });
        });
    });
    "Loading Guildhall".postln;
    ~isPlaying[2] = 1;
};

~magnet4Detected = {
    "Magnet 4 Triggered".postln;
    if(~isPlaying[3] != 1,{
        if(~isPlaying[2] == 1,{~loadStadiumSounds.(22);},{
            if(~isPlaying[4] == 1,{~loadStadiumSounds.(24);},{
                ~loadStadiumSounds.(18);
            });
        });
    });
    "Loading Stadium".postln;
    ~isPlaying[3] = 1;
};

~magnet5Detected = {
    "Magnet 5 Triggered".postln;
    if(~isPlaying[4] != 1,{
        if(~isPlaying[3] == 1,{~loadSpinnakerSounds.(24);},{
            ~loadSpinnakerSounds.(19);
        });
    });
    "Loading Spinnaker".postln;
    ~isPlaying[4] = 1;
};

~magnetReleased = {
    var freeState = 1;
    "Magnet Released".postln;

    ~sensorStates.do{|i|
        if(i > 0, {freeState = 0;});
    };
    if(freeState == 1,{
        (~numSlots + 1).do{|i|
            if(~synths[i].notNil,{
                ~synths[i].free;
                ~synths[i] = nil;
            });
        };
    });
};

OSCdef(
    'magnetSensor1',
    {|msg|
        var state = msg[1];

        if(state == 1,
        {
            ~magnet1Detected.value;
            ~sensorStates[0] = 1;
        },
        {
            ~sensorStates[0] = 0;
            ~magnetReleased.value;
            ~isPlaying[0] = 0;
        }
        );
    },
    '/magnet1',
    recvPort: ~oscPort
);

OSCdef(
    'magnetSensor2',
    {|msg|
        var state = msg[1];

        if(state == 1,
        {
            ~magnet2Detected.value;
            ~sensorStates[1] = 1;
        },
        {
            ~sensorStates[1] = 0;
            ~magnetReleased.value;
            ~isPlaying[1] = 0;
        }
        );
    },
    '/magnet2',
    recvPort: ~oscPort
);

OSCdef(
    'magnetSensor3',
    {|msg|
        var state = msg[1];

        if(state == 1,
        {
            ~magnet3Detected.value;
            ~sensorStates[2] = 1;
        },
        {
            ~sensorStates[2] = 0;
            ~magnetReleased.value;
            ~isPlaying[2] = 0;
        }
        );
    },
    '/magnet3',
    recvPort: ~oscPort
);

OSCdef(
    'magnetSensor4',
    {|msg|
        var state = msg[1];

        if(state == 1,
        {
            ~magnet4Detected.value;
            ~sensorStates[3] = 1;
        },
        {
            ~sensorStates[3] = 0;
            ~magnetReleased.value;
            ~isPlaying[3] = 0;
        }
        );
    },
    '/magnet4',
    recvPort: ~oscPort
);

OSCdef(
    'magnetSensor5',
    {|msg|
        var state = msg[1];

        if(state == 1,
        {
            ~magnet5Detected.value;
            ~sensorStates[4] = 1;
        },
        {
            ~sensorStates[4] = 0;
            ~magnetReleased.value;
            ~isPlaying[4] = 0;
        }
        );
    },
    '/magnet5',
    recvPort: ~oscPort
);

OSCdef('analogSensors', {|msg|
    var values = msg[1..];
    var index = 0;
    values.postln;

    ~numSlots.do{|i|
        if(~synths[i].notNil,{
            ~synths[i].set('amp', values[index].linlin(0,740,0,2));
            ~synths[i].set('modVal', values[index + 1]);

            index = index + 2;
        });
    };
});

SynthDef('player', {|out = 0, bufnum = 0, amp = 0, modVal = 0|
    var sig, baseRate, lfo, playbackRate;

    baseRate = modVal.linexp(0,740,0.75,1.25);
    lfo = SinOsc.kr(0.05).range(0.9,1);
    playbackRate = baseRate * lfo;

    sig = PlayBuf.ar(
        numChannels: 2,
        bufnum: bufnum,
        rate: BufRateScale.kr(bufnum) * playbackRate,
        loop: 1,
        doneAction: 0
    );
    // sig = sig*amp;
    Out.ar(out, sig*amp);
}).add;

SynthDef('voicePlayer', {|out = 0, bufnum = 0, amp = 0, modVal = 0|
    var sig;

    sig = PlayBuf.ar(
        numChannels: 2,
        bufnum: bufnum,
        rate: BufRateScale.kr(bufnum),
        loop: 0,
        doneAction: 0
    );
    sig = sig*amp;
    Out.ar(out, sig ! 2);
}).add;

~loadSlot = {|slot, fileIndex|
    var buf = ~buffers[slot];
    buf.free;
    ~buffers[slot] = Buffer.read(s, ~files[fileIndex]);
};

~loadBeachSounds = {|voIndex|
    var index = 0;
    ~numSlots.do{|i|
        if(~synths[i].notNil, {
            ~synths[i].free;
        });

        ~loadSlot.(i, index);
        index = index + 1;
        ~buffers[i].postln;

        ~synths[i] = Synth('player', ['bufnum', ~buffers[i].bufnum, 'amp', 0.5]);
    };
    if(~synths[3].notNil,{
        ~synths[3].free;
    });
    ~loadSlot.(3, voIndex);
    ~buffers[3].postln;
    ~synths[3] = Synth('voicePlayer', ['bufnum', ~buffers[3].bufnum, 'amp', 3]);
    ~synths.postln;
};

~loadCastleSounds = {|voIndex|
    var index = 3;
    ~numSlots.do{|i|
        if(~synths[i].notNil, {
            ~synths[i].free;
        });

        ~loadSlot.(i, index);
        index = index + 1;
        ~buffers[i].postln;

        ~synths[i] = Synth('player', ['bufnum', ~buffers[i].bufnum, 'amp', 0.5]);
    };
    if(~synths[3].notNil,{
        ~synths[3].free;
    });
    ~loadSlot.(3, voIndex);
    ~buffers[3].postln;
    ~synths[3] = Synth('voicePlayer', ['bufnum', ~buffers[3].bufnum, 'amp', 3]);
    ~synths.postln;
};

~loadGuildhallSounds = {|voIndex|
    var index = 6;
    ~numSlots.do{|i|
        if(~synths[i].notNil, {
            ~synths[i].free;
        });

        ~loadSlot.(i, index);
        index = index + 1;
        ~buffers[i].postln;

        ~synths[i] = Synth('player', ['bufnum', ~buffers[i].bufnum, 'amp', 0.5]);
    };
    if(~synths[3].notNil,{
        ~synths[3].free;
    });
    ~loadSlot.(3, voIndex);
    ~buffers[3].postln;
    ~synths[3] = Synth('voicePlayer', ['bufnum', ~buffers[3].bufnum, 'amp', 3]);
    ~synths.postln;
};

~loadStadiumSounds = {|voIndex|
    var index = 9;
    ~numSlots.do{|i|
        if(~synths[i].notNil, {
            ~synths[i].free;
        });

        ~loadSlot.(i, index);
        index = index + 1;
        ~buffers[i].postln;

        ~synths[i] = Synth('player', ['bufnum', ~buffers[i].bufnum, 'amp', 0.5]);
    };
    if(~synths[3].notNil,{
        ~synths[3].free;
    });
    ~loadSlot.(3, voIndex);
    ~buffers[3].postln;
    ~synths[3] = Synth('voicePlayer', ['bufnum', ~buffers[3].bufnum, 'amp', 3]);
    ~synths.postln;
};

~loadSpinnakerSounds = {|voIndex|
    var index = 12;
    ~numSlots.do{|i|
        if(~synths[i].notNil, {
            ~synths[i].free;
        });

        ~loadSlot.(i, index);
        index = index + 1;
        ~buffers[i].postln;

        ~synths[i] = Synth('player', ['bufnum', ~buffers[i].bufnum, 'amp', 0.5]);
    };
    if(~synths[3].notNil,{
        ~synths[3].free;
    });
    ~loadSlot.(3, voIndex);
    ~buffers[3].postln;
    ~synths[3] = Synth('voicePlayer', ['bufnum', ~buffers[3].bufnum, 'amp', 3]);
    ~synths.postln;
};

)

~magnet1Detected.();
~magnet2Detected.();
~magnet3Detected.();
~magnet4Detected.();
~loadGuildhallSounds.(17);
~magnetReleased.();
~isPlaying[1] = 1;
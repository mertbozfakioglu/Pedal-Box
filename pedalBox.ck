
//KEYS
//1-2:GAIN, 3-4:PAN, 5-6:LPF, 7-8:HPF
//Q-W:REVERB, E-R:DELAY_GAIN, T-Y:DELAY_LENGTH
//A-S:CHORUS_GAIN, D-F:CHORUS_LEGTH, G-H:CHORUS_DEPTH
//Z-X:ECHO_GAIN, C-V:ECHO_LENGTH

//keyboard input
Hid hi;
HidMsg msg;

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;


//Sound Connections
adc => Gain g => NRev rev => Chorus cho => Echo ech => HPF hpf => LPF lpf => Pan2 pan => dac;
1 => float gainV;
gainV => g.gain;

//hpf
4000 => float hpfV;
hpfV => hpf.freq;

//lpf
3000 => float lpfV;
lpfV => lpf.freq;

//pan
0 => float panV;
panV => pan.pan;

//delay
0.0 => float delayGainV;
0.6 => float delayLengthV;
g => Delay d1=> dac;
d1 => d1;

delayGainV => d1.gain;

delayLengthV :: second => d1.max => d1.delay;

//echo
1.0 => float echoLengthV;
0.0 => float echMixV;
echoLengthV::second => dur delay;
echoLengthV::second => dur max;
delay => ech.delay;
max => ech.max;
echMixV => ech.mix;

//reverb
0.0 => float revMixV;
revMixV => rev.mix;

//chorus
0.3 => float choModFreqV;
0.9 => float choModDepthV;
0.9 => float choMixV;
choModFreqV => cho.modFreq;
choModDepthV => cho.modDepth;
choMixV => cho.mix;

while (true) {
    // wait on event
    hi => now;
    
    // get one or more messages
    while( hi.recv( msg ) )
    {
        // check for action type
        if( msg.isButtonDown() )
        {
            //GAIN 1 up, 2 down
            if (msg.key == 30 && gainV < 1.0){
                gainV + 0.1 => gainV;
                gainV => g.gain;
            }
            else if (msg.key == 31 && gainV > 0.0){
                gainV - 0.1 => gainV;
                gainV => g.gain;
            }
            
            //PAN 3 right, 4 left
            else if (msg.key == 32 && panV < 1.0){
                panV + 0.1 => panV;
                panV => pan.pan;
                <<<panV>>>;
            }
            else if (msg.key == 33 && panV > -1.0){
                panV - 0.1 => panV;
                panV => pan.pan;
                <<<panV>>>;
            }
            
            //LPF 5 up, 6 down
            else if (msg.key == 34 && lpfV < 20000){
                lpfV + 500 => lpfV;
                lpfV => lpf.freq;
                <<<lpfV>>>;
            }
            else if (msg.key == 35 && lpfV > 0){
                lpfV - 500 => lpfV;
                lpfV => lpf.freq;
                <<<lpfV>>>;
            }
            
            //HPF 7 up, 8 down
            else if (msg.key == 36 && hpfV < 20000){
                hpfV + 500 => hpfV;
                hpfV => hpf.freq;
                <<<hpfV>>>;
            }
            else if (msg.key == 37 && hpfV > 0){
                hpfV - 500 => hpfV;
                hpfV => hpf.freq;
                <<<hpfV>>>;
            }
            
            //REVERB Q up, W down
            else if (msg.key == 20 && revMixV < 0.9){
                revMixV + 0.1 => revMixV;
                revMixV => rev.mix;
                <<<revMixV>>>;
            }
            else if (msg.key == 26 && revMixV > 0.1){
                revMixV - 0.1 => revMixV;
                revMixV => rev.mix;
                <<<revMixV>>>;
            }
            
            //DELAY GAIN E up, R down
            else if (msg.key == 8 && delayGainV < 0.9){
                delayGainV + 0.1 => delayGainV;
                delayGainV => d1.gain;
                <<<delayGainV>>>;
            }
            else if (msg.key == 21 && delayGainV > 0.1){
                delayGainV - 0.1 => delayGainV;
                delayGainV => d1.gain;
                <<<delayGainV>>>;
            }
            
            //DELAY LENGTH T up, Y down
            else if (msg.key == 23 && delayLengthV < 0.9){
                delayLengthV + 0.1 => delayLengthV;
                delayLengthV :: second => d1.max => d1.delay;
                <<<delayLengthV>>>;
            }
            else if (msg.key == 28 && delayLengthV > 0.1){
                delayLengthV - 0.1 => delayLengthV;
                delayLengthV :: second => d1.max => d1.delay;
                <<<delayGainV>>>;
            }
            
            //CHORUS MIX A up, S down
            else if (msg.key == 4 && choMixV < 0.95){
                choMixV + 0.1 => choMixV;
                choMixV => cho.mix;
                <<<choMixV>>>;
            }
            else if (msg.key == 22 && choMixV > 0.1){
                choMixV - 0.1 => choMixV;
                choMixV => cho.mix;
                <<<choMixV>>>;
            }
            
            //CHORUS FREQ D up, F down
            else if (msg.key == 7 && choModFreqV < 0.9){
                choModFreqV + 0.1 => choModFreqV;
                choModFreqV => cho.modFreq;;
                <<<choModFreqV>>>;
            }
            else if (msg.key == 9 && choModFreqV > 0.1){
                choModFreqV - 0.1 => choModFreqV;
                choModFreqV => cho.modFreq;
                <<<choModFreqV>>>;
            }
            
            //CHORUS DEPTH G up, H down
            else if (msg.key == 10 && choModDepthV < 0.95){
                choModDepthV + 0.1 => choModDepthV;
                choModDepthV => cho.modDepth;
                <<<choModDepthV>>>;
            }
            else if (msg.key == 11 && choModDepthV > 0.1){
                choModDepthV - 0.1 => choModDepthV;
                choModDepthV => cho.modDepth;
                <<<choModDepthV>>>;
            }
           
            //ECHO MIX Z up, X down
            else if (msg.key == 29 && echMixV < 0.95){
                echMixV + 0.1 => echMixV;
                echMixV => ech.mix;
                <<<echMixV>>>;
            }
            else if (msg.key == 27 && echMixV > 0.1){
                echMixV - 0.1 => echMixV;
                echMixV => ech.mix;
                <<<echMixV>>>;
            }
            
            //ECHO Length C up, V down
            else if (msg.key == 6 && echoLengthV < 5.0){
                echoLengthV + 0.1 => echoLengthV;
                echoLengthV::second => dur delay;
                echoLengthV::second => dur max;
                delay => ech.delay;
                max => ech.max;
                <<<echoLengthV>>>;
            }
            else if (msg.key == 25 && echoLengthV > 0.05){
                echoLengthV - 0.2 => echoLengthV;
                echoLengthV::second => dur delay;
                echoLengthV::second => dur max;
                delay => ech.delay;
                max => ech.max;
                <<<echoLengthV>>>;
            }            
        }
    }
    100 :: ms => now;
}

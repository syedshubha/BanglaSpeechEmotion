function f=features(Sig, fs)

%Speech rate
sr=speechRate(Sig, fs);

%energy
nSig = Sig / max(abs(Sig)); 
eng = sum(nSig.^2);

%pitch
mfps=pitchs(Sig, fs);
meanp=mean(mfps);
varp=var(mfps);
maxp=max(mfps);
minp=min(mfps);

%mfcc
frameDuration = 20;
frameShift = 10;
preemphasis = 0.97;
nFilterbankChannels = 20;
nCepstralCoefficients = 12;
cepstralSineLifter = 22;
lowerFrequency = 300;
upperFrequency = 3700;

cc = mfcc(Sig, fs, frameDuration, frameShift, preemphasis, @hamming,...
        [lowerFrequency upperFrequency], nFilterbankChannels, nCepstralCoefficients + 1, cepstralSineLifter);
mediancc = median(cc, 2)';

f=[sr eng meanp varp maxp minp mediancc];

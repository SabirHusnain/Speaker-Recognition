%% SPEAKER RECOGNITION
%
clear; clc; close all;

fs=44100;
t=0:1/fs:5-1/fs;

%% TRAIN -- Run this section to record your voice
%
name=input('Enter Speaker''s Name Please (Speaker ID): ');
train(name, fs);
record=true;

if ls("database/"+string(name)+".wav")
    disp('Thank You! Database Updated');
else
    disp('Error! Data isn''t Saved');
end
%% TEST
%
[data_Test, dis, name]=test();

clc; disp('Distance Vector: -');
disp(dis);

fprintf('Minimum Eucledean Distance is %f\n',min(dis));
fprintf('This is Speaker %s!\n',upper(name));

%% SIGNAL, FOURIER, & PRE-FILTER
%
[data_Train,fs]=audioread("database/"+string(name)+".wav");
lengthSignal=length(data_Train);

df=fs/lengthSignal;
freqLis=-fs/2:df:fs/2-df;

trainSignal_Filt=bandpass(data_Train,[80 8000],fs);
trainSignal_FFT=fftshift(fft(trainSignal_Filt));

testSignal_Filt=bandpass(data_Test.audio,[80 8000],data_Test.fs);
testSignal_FFT=fftshift(fft(testSignal_Filt));

figure(1);
subplot(211);
plot(t,data_Train);
title('Audio Signal (Time-Domain) -- Database Signal');
xlabel('time (sec)'); ylabel('magnitude');
grid on; grid minor;
subplot(212);
plot(t,data_Test.audio);
title('Audio Signal (Time-Domain) -- Sample Signal');
xlabel('time (sec)'); ylabel('magnitude');
grid on; grid minor;

figure(2);
subplot(211);
plot(freqLis,abs(trainSignal_FFT));
title('Audio Signal (Freq-Domain) -- Database Signal');
xlabel('frequency (Hz)'); ylabel('magnitude');
grid on; grid minor;
subplot(212);
plot(freqLis,abs(testSignal_FFT));
title('Audio Signal (Freq-Domain) -- Test Signal');
xlabel('frequency (Hz)'); ylabel('magnitude');
grid on; grid minor;

tempTrain=abs(fft(trainSignal_FFT,lengthSignal*2)/length(fft(trainSignal_FFT,lengthSignal*2)));
tempTest=abs(fft(testSignal_FFT,lengthSignal*2)/length(fft(testSignal_FFT,lengthSignal*2)));
freq=0:df/2:fs/2-df/2;

figure(3);
subplot(211);
plot(t,freq'.*tempTrain(1:lengthSignal),'.b');
title('Time-Pitch Plot -- Database Signal');
xlabel('time (sec)'); ylabel('pitch (Hz)');
grid on; grid minor;
subplot(212);
plot(t,freq'.*tempTest(1:lengthSignal),'.b');
title('Time-Pitch Plot -- Test Signal');
xlabel('time (sec)'); ylabel('pitch (Hz)');
grid on; grid minor;
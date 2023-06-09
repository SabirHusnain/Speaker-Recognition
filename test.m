function [testData, dis, name] = test(varargin)
%
% test - Perform Test for the Speaker Recognition
%
% Syntax: [data, dis, name] = test(fs)
%
% Inputs:
%   fs         Sampling Frequency (Hz)
%
% Outputs:
%   data       Audio, Sampling Frequency (Hz) -- Structure
%   dis        Euclidian Distances
%   name       Name of Speaker
%
%
% Author: Sabir Husnain
%

if nargin==0
    fs=44100;
end
%% RECORD TEST Signal
%
fprintf('\nPlease Record Your Voice Sample for 5s\n');
disp('----> Start Speaking <----');
sig = audiorecorder(fs,16,1);
recordblocking(sig,5);
disp('----> Stop Speaking <----');
user=bandpass(getaudiodata(sig),[80 8000],fs);

%% INPUT PARAMETERS
%
% refer to mfcc.m file and understand the terms below and assign values as per your requirement
TW=25; TS=10; ALPHA=0.97; R = [300 3700]; M = 20; C = 13; L = 22;
HAMMING = @(N)(0.54-0.46*cos(2*pi*(0:N-1).'/(N-1)));

%% FILE SYSTEM (DATABASE)
%
files=string(ls('database/*.wav'));
spkName=string(split(files,'.'));
spkName=spkName(:,1);
clear files;

nUser=length(spkName);

%% FEATURE EXTRACTION & CLASSIFICATION
%
dis=zeros(1,nUser);
[ tMFCCs, ~, ~ ] = mfcc(user, fs, TW, TS, ALPHA, HAMMING, R, M, C, L);

% After finding MFCC of test sample, we will find MFCC of each speaker model in Train folder and
% also Euclidian distance between the speaker model and test sample

for i=1:nUser
    [speaker,Fs]=audioread("database/"+spkName(i)+".wav");
    speaker=bandpass(speaker,[80 8000],fs);
    [MFCCs,~,~] = mfcc(speaker, Fs, TW, TS, ALPHA, HAMMING, R, M, C, L );
    dis(i) = dtw(tMFCCs,MFCCs);
end

[~, idx]=min(dis);

testData.audio=user;
testData.fs=fs;
name=spkName(idx);
end
function [] = train(varargin)
%
% test - Train the Speaker Recognition Model
%
% Syntax: test(name, fs)
%
% Inputs:
%   name       Speaker Name (ID)
%   fs         Sampling Frequency (Hz)
%
%
% Author: Sabir Husnain
%

if nargin==1
    name=varargin{1};
    fs=44100;
    disp('Default value of sampling frequency is 44100Hz!');
    fprintf('\nPlease Record Your Voice Sample for 5s\n');
    sig = audiorecorder(fs,16,1);
    disp('----> Start Speaking <----');
    pause(0.5);
    recordblocking(sig,5);
    pause(0.5);
    disp('----> Stop Speaking <----');
    user = getaudiodata(sig);
    audiowrite("database/"+string(name)+".wav",user,fs);
elseif nargin==2
    name=varargin{1};
    fs=varargin{2};
    fprintf('\nPlease Record Your Voice Sample for 5s\n');
    sig = audiorecorder(fs,16,1);
    disp('----> Start Speaking <----');
    pause(0.5);
    recordblocking(sig,5);
    pause(0.5);
    disp('----> Stop Speaking <----');
    user = getaudiodata(sig);
    audiowrite("database/"+string(name)+".wav",user,fs);
end
end
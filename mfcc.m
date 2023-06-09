function [ MFCC, FBE, frames ] = mfcc(speech, fs, tw, ts, alpha, window, r, m, n, l)
%
% MFCC - MFCC Mel frequency cepstral coefficient feature extraction
%
% Syntax: [MFCC, FBE, frames] = mfcc(speech, fs, tw, ts, alpha, window, r, m, n, l)
%
% Inputs:
%   speech     Speech Signal
%   fs         Sampling Frequency (Hz)
%   tw         Analysis Frame Duration (ms)
%   ts         Analysis Frame Shift (ms)
%   alpha      Preemphasis Coefficient
%   window     Analysis Window Function Handle
%   r          Frequency Range (Hz) for Filterbank Analysis
%   m          Number of Filterbank Channels
%   n          Number of Cepstral Coefficients (Including 0th)
%   l          Liftering Parameter
%
% Outputs:
%   MFCC       Matrix of MFCC
%   FBE        Matrix of Filterbank Energies (feature vectors as columns)
%   frames     Matrix of Windowed Frames
%
%
% Author: Sabir Husnain
%

% Ensure correct number of inputs
if( nargin~= 10 ), help mfcc; return; end;

% Explode samples to the range of 16 bit shorts
if( max(abs(speech))<=1 ), speech = speech * 2^15; end;

Nw = round( 1E-3*tw*fs );    % frame duration (samples)
Ns = round( 1E-3*ts*fs );    % frame shift (samples)

nfft = 2^nextpow2( Nw );     % length of FFT analysis
K = nfft/2+1;                % length of the unique part of the FFT


%% HANDY INLINE FUNCTION HANDLES
%
hz2mel = @( hz )( 1127*log(1+hz/700) );     % Hertz to mel warping function
mel2hz = @( mel )( 700*exp(mel/1127)-700 ); % mel to Hertz warping function

% Type III DCT matrix routine (DCT - Discrete Cosine Transform)
dctm = @( N, M )( sqrt(2.0/M) * cos( repmat((0:N-1).',1,M) ...
    .* repmat(pi*((1:M)-0.5)/M,N,1) ) );

% Cepstral lifter routine
ceplifter = @( N, L )( 1+0.5*L*sin(pi*(0:N-1)/L) );

%% FEATURE EXTRACTION
%
speech = filter( [1 -alpha], 1, speech ); % fvtool( [1 -alpha], 1 ); First order FIR Filter

% Framing and windowing (frames as columns)
frames = vec2frames( speech, Nw, Ns, 'cols', window, false );

% Magnitude spectrum computation (as column vectors)
MAG = abs( fft(frames,nfft,1) );

% Triangular filterbank with uniformly spaced filters on mel scale
H = trifbank( m, K, r, fs, hz2mel, mel2hz ); % size of H is M x K

% Filterbank application to unique part of the magnitude spectrum
FBE = H * MAG(1:K,:); % FBE( FBE<1.0 ) = 1.0; % apply mel floor

% DCT matrix computation
DCT = dctm( n, m );

% Conversion of logFBEs to cepstral coefficients through DCT
MFCC =  DCT * log( FBE );

% Cepstral lifter computation
lifter = ceplifter( n, l );

% Cepstral liftering gives liftered cepstral coefficients
MFCC = diag( lifter ) * MFCC; % ~ HTK's MFCCs

end
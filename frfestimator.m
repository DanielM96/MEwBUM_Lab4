function [ H, coh, f ] = frfestimator(exc, res, fs, estimator, nfft, window)
%FRFESTIMATOR estimates the Frequency Response Function (FRF) for random
%excitation and response time domain data.
%   [ H, COH, F, AMPLITUDEPLOT, PHASEPLOT ] = FRFESTIMATOR( EXC, RES, Fs,
%   ESTIMATOR), returns outputs using time domain random excitation (EXC)
%   and response (RES) data vectors. EXC and RES should be same in length.
% 
%   Fs is the sampling frequency, and it is twice the Nyquist frequency or
%   bandwidth frequency value. 
% 
%   ESTIMATOR is the FRF estimator type: which is either H1, H2 or Hv.
% 
%   H is the frequency response function, COH is the coherence, F is the
%   frequency (in hertz), AMPLITUDEPLOT is the frf magnitude - frequency
%   plot, PHASEPLOT is the frf phase - frequency plot.
% 
%   [ ... ] = FRFESTIMATOR( EXC, RES, Fs, ESTIMATOR, NFFT), specifies the
%   number of FFT points used in the calculations. If NFFT is omitted or
%   specified as empty , NFFT is set to either 512 or value of power of two
%   which is the closest greater value to the the length of EXC (among two
%   values the larger value is opted).
% 
%   [ ... ] = FRFESTIMATOR( ..., NFFT, WINDOW), if WINDOW is an integer
%   then EXC and RES are devided in to sections equal to the given integer
%   value, and a Hamming window of the same length is used in each section.
%   If length of EXC and RES such that they can not be devided excatly in
%   to specified integer number of sections with 50% overlap, then EXC and
%   RES are truncated. If WINDOW is a vector, then EXC and RES vectors are
%   devided in to overlapping sections of length of WINDOW, and then uses
%   the vector to WINDOW each section. IF WINDOW is omitted or specified as
%   empty then a Hamming window is used.
% 
%   Inputs
%       exc           : random excitation data vector (time domain)
%       res           : response data vector (time domain)
%       fs            : sampling frequency 
%       estimator     : frf estimator type (H1, H2 or Hv)
%       nfft          : number of FFT points
%       window        : windowing scheme
% 
%   Outputs
%       H             : frequency response function
%       coh           : coherence
%       f             : frequency (in hertz)
%       AmplitudePlot : frf magnitude - frequency plot 
%       PhasePlot     : frf phase - frequency plot (phase value in radians)
% 
%   References
%       [1] Ewins D. J., 2000. Modal testing: Theory, practice, and
%       application /  D.J. Ewins, 2nd ed., Research Studies Press,
%       Baldock. 
%       [2] Rocklin G. T., Crowley J., and Vold H., 1985,“A comparison of 
%       H1, H2, and Hv frequency response functions,” Proceedings of the 
%       3rd international Modal Analysis Conference, pp. 272–278.
% 
% -------------------------------------------------------------------------
% coded by S.R. Buddhi Wimarshana <buddhiwisr@live.com>, at Faculty of
% Engineering, University of Manitoba, Canada. 
% 16-July-2016, MatLab 2015a.
% -------------------------------------------------------------------------

% Inputs setter.
% --------------
if nargin == 4
    setLength = length(exc);
    power = 9; % 2^9 is 512
    while 2^power <= setLength
        power = power + 1;
    end
    nfft = max(512, 2^power);
    window = [];
elseif nargin == 5
    window = [];
end


% Spectral density calculations.
% ------------------------------
[Sxx,f] = pwelch(res,window,[],nfft,fs); % single-sided PSD
[Sff,~] = pwelch(exc,window,[],nfft,fs); % single-sided PSD
[Sxf,~] = cpsd(res,exc,window,[],nfft,fs); % single-sided CSD
[Sfx,~] = cpsd(exc,res,window,[],nfft,fs); % single-sided CSD


% FRF estimator calculation.
% --------------------------
switch estimator
    case 'H1'
        H = (Sxf./Sff).'; % H1 estimate ((-) needed??)
    case 'H2'
        H = (Sxx./Sfx).'; % H2 estimate
    case 'Hv'
        H = ((Sxf./abs(Sxf)).*(sqrt(Sxx./Sff)))';
    otherwise
        error('Unsupported estimator option - in FRFestimate')
end


% Other outputs calculations.
% --------------------------
coh = ((abs(Sfx).^2)./(Sxx.*Sff)).'; % coherence

% -------------------------------------------------------------------------
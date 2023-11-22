function [ H, f, c ] = trifbank( M, K, R, fs, h2w, w2h )

% TRIFBANK Triangular filterbank.
%
%   Inputs
%           M is the number of filters, i.e., number of rows of H
%
%           K is the length of frequency response of each filter 
%             i.e., number of columns of H
%
%           R is a two element vector that specifies frequency limits (Hz), 
%             i.e., R = [ low_frequency high_frequency ];
%
%           FS is the sampling frequency (Hz)
%
%           H2W is a Hertz scale to warped scale function handle
%
%           W2H is a wared scale to Hertz scale function handle
%
%   Outputs
%           H is a M by K triangular filterbank matrix (one filter per row)
%
%           F is a frequency vector (Hz) of 1xK dimension
%
%           C is a vector of filter cutoff frequencies (Hz), 
%             note that C(2:end) also represents filter center frequencies,
%             and the dimension of C is 1x(M+2)
%

    if( nargin~= 6 ), help trifbank; return; end % very lite input validation

    f_min = 0;          % filter coefficients start at this frequency (Hz)
    f_low = R(1);       % lower cutoff frequency (Hz) for the filterbank 
    f_high = R(2);      % upper cutoff frequency (Hz) for the filterbank 
    f_max = 0.5*fs;     % filter coefficients end at this frequency (Hz)
    f = linspace( f_min, f_max, K ); % frequency range (Hz), size 1xK
    fw = h2w( f );

    % filter cutoff frequencies (Hz) for all filters, size 1x(M+2)
    c = w2h( h2w(f_low)+[0:M+1]*((h2w(f_high)-h2w(f_low))/(M+1)) );
    cw = h2w( c );

    H = zeros( M, K );                  % zero otherwise
    for m = 1:M 

        k = f>=c(m)&f<=c(m+1); % up-slope
        H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
        k = f>=c(m+1)&f<=c(m+2); % down-slope
        H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));
       
    end

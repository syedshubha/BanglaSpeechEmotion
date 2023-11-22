function [ CC, FBE, frames ] = mfcc( speech, fs, Tw, Ts, alpha, window, R, M, N, L )

    % Ensure correct number of inputs
    if( nargin~= 10 ), help mfcc; return; end 

    % Explode samples to the range of 16 bit shorts
    if( max(abs(speech))<=1 ), speech = speech * 2^15; end

    Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
    Ns = round( 1E-3*Ts*fs );    % frame shift (samples)

    nfft = 2^nextpow2( Nw );     % length of FFT analysis 
    K = nfft/2+1;                % length of the unique part of the FFT 

    
    hz2mel = @( hz )( 1125*log(1+hz/700) );     % Hertz to mel warping function
    mel2hz = @( mel )( 700*exp(mel/1125)-700 ); % mel to Hertz warping function

    dctm = @( N, M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
                                       .* repmat(pi*([1:M]-0.5)/M,N,1) ) );

    % Cepstral lifter routine
    ceplifter = @( N, L )( 1+0.5*L*sin(pi*[0:N-1]/L) );

    % Preemphasis filtering
    speech = filter( [1 -alpha], 1, speech );

    % Framing and windowing 
    frames = vec2frames( speech, Nw, Ns, 'cols', window, false );

    % Magnitude spectrum computation
    MAG = abs( fft(frames,nfft,1) ); 

    % Triangular filterbank with uniformly spaced filters on mel scale
    H = trifbank( M, K, R, fs, hz2mel, mel2hz ); % size of H is M x K 

    % Filterbank application to unique part of the magnitude spectrum
    FBE = H * MAG(1:K,:);

    % DCT matrix computation
    DCT = dctm( N, M );

    % Conversion of logFBEs to cepstral coefficients through DCT
    CC =  DCT * log( FBE );

    % Cepstral lifter computation
    lifter = ceplifter( N, L );

    % Cepstral liftering gives liftered cepstral coefficients
    CC = diag( lifter ) * CC;


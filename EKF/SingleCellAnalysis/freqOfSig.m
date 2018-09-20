Fs = 1000;                    % Sampling frequency
T = 1/30;                     % Sample time
L = 75;                     % Length of signal
t = (0:L-1)*T;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(angor,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
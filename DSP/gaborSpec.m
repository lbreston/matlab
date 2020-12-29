%Gabor Spectrogram
function [Y]=gaborSpec(X,fs)
NFFT    = 800; 
tw      = -NFFT/2+1:NFFT/2;
sigma   = .2;
sigSamp = sigma*fs;
w       = sqrt(sqrt(2)/sigSamp)*exp(-pi*tw.*tw/sigSamp/sigSamp);
overlap = NFFT-1;
[Y]=spectrogram(X,w,overlap,NFFT,fs);
end
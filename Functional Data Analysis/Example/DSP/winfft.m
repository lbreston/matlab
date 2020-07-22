%Hamming windowed FFT
function Y=winfft(X,dim)
L = size(X,dim);        
w = hamming(L);
X = X.*w.';
Y = fft(X,L,dim)/L;
end
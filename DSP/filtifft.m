%Filtered Signal
function Y=filtifft(X,freqfilt,fs,dim)
L=size(X,dim);
f = fs*linspace(0,1,L); 
ff=freqfilt(f);
Xf=X.*ff;
Y=real(ifft(Xf,L,2))*L*2;
Y=Y./hamming(L).';
end






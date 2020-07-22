%% Building Pipes

% Fourier Analysis Pipeline
Fourier.Frequency_Band= @(obj)pipe.initval('Requires Input');
Fourier.Signal = @(obj)pipe.initval('Requires Input');
Fourier.Fourier_Transform = @(obj)treefun(@(x)winfft(x,2),obj.Signal);
Fourier.Gabor_Spectrogram = @(obj)treefun(@(x)dimfun(@(y)gaborSpec(y,1000),{x},2),obj.Signal);
Fourier.Filtered_Signal= @(obj)treefun(@(x)filtifft(x,@(f)(f>=obj.Frequency_Band(1)&f<=obj.Frequency_Band(2)),1000,2),obj.Fourier_Transform);

Fourier=pipe(Fourier);
save('Fourier','Fourier');

%%
%Phase Amplitude Coupling Pipeline

PAC.Signal = @(obj)pipe.initval('Requires Input');
PAC.window=@(obj)pipe.initval('Requires Input');
PAC.overlap=@(obj)pipe.initval('Requires Input');
PAC.Phase_band=@(obj)pipe.initval('Requires Input');
PAC.Abs_band=@(obj)pipe.initval('Requires Input');
%Pipes can contain other pipes
%Phase_FT and Abs_FT are Fourier pipes
PAC.Phase_FT=@(obj){'Frequency_Band',obj.Phase_band,'Signal',obj.Signal,'Filtered_Signal',[]}|Fourier;
PAC.Abs_FT=@(obj){'Frequency_Band',obj.Abs_band,'Signal',obj.Signal,'Filtered_Signal',[]}|Fourier;
PAC.Phase_Signal=@(obj)obj.Phase_FT.Filtered_Signal;
PAC.Abs_Signal=@(obj)obj.Abs_FT.Filtered_Signal;
PAC.Phase= @(obj)treefun(@(x)angle(hilbert(x.').'),obj.Phase_Signal);
PAC.Abs= @(obj)treefun(@(x)abs(hilbert(x.').'),obj.Abs_Signal);
PAC.PAC=@(obj)catleaves(treefun(@(x,y)tuplefun(@(w,z)modulationIndex(w,z),{x,y},1),{obj.Phase,obj.Abs}),3);
PAC.movPAC=@(obj)catleaves(treefun(@(x,k,o)movfun(@(x)tuplefun(@(w,z)modulationIndex(w,z),{x,y},2),x,k,o),obj.Phase,obj.Abs,{obj.window,obj.overlap}),4);

PAC=pipe(PAC);
save('PAC','PAC');

%% Running PAC Pipe
clear all 

%LFP.mat is a structure containing multiregion LFP recordings during 3 behavioral conditions. 
%The rows of each array correspond to the recordings from different regions 

load('LFP.mat')

%load PAC pipe 
load('PAC');

%create input struct
I.Signal=BCItrials;
I.Phase_band=[7,10];
I.Abs_band=[80,100];

%Pass Input into Pipe 
I|PAC;

%PAC values 
PAC.PAC;

%Average PAC values 
mPAC=treefun(@(x)mean(x,3),PAC.PAC);

%% clear the pipe if you want to recalculate values 
PAC.clear('all')






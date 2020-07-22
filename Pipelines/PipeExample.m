%% Build Pipes
clear all
% Fourier pipe
Fourier.Frequency_Band= @(obj)pipe.initval('Requires Input');
Fourier.Signal = @(obj)pipe.initval('Requires Input');
Fourier.Fourier_Transform = @(obj)treefun(@(x)winfft(x,2),obj.Signal);
Fourier.Gabor_Spectrogram = @(obj)treefun(@(x)dimfun(@(y)gaborSpec(y,1000),{x},2),obj.Signal);
Fourier.Filtered_Signal= @(obj)treefun(@(x)filtifft(x,@(f)(f>=obj.Frequency_Band(1)&f<=obj.Frequency_Band(2)),1000,2),obj.Fourier_Transform);

Fourier=pipe(Fourier);

%PAC pipe
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
PAC.Abs_Signal=@(obj)obj.Phase_FT.Filtered_Signal;
PAC.Phase= @(obj)treefun(@(x)angle(hilbert(x.').'),obj.Phase_Signal);
PAC.Abs= @(obj)treefun(@(x)abs(hilbert(x.').'),obj.Abs_Signal);
PAC.PAC=@(obj)catleaves(treefun2(@(x,y)tuplefun(@(w,z)modulationIndex(w,z),{x,y},2),obj.Phase,obj.Abs),3);
PAC.movPAC=@(obj)catleaves(treefun2(@(x,k,o)movfun(@(x)tuplefun(@(w,z)modulationIndex(w,z),{x,y},2),x,k,o),obj.Phase,obj.Abs,{obj.window,obj.overlap}),4);

PAC=pipe(PAC);


CCS.Signal =@(obj)pipe.initval('Requires Input');
CCS.tau=@(obj)pipe.initval('Requires Input');
CCS.dim=@(obj)pipe.initval('Requires Input');
CCS.lag=@(obj)pipe.initval('Requires Input');
CCS.window=@(obj)pipe.initval('Requires Input');
CCS.overlap=@(obj)pipe.initval('Requires Input');
CCS.CCS=@(obj)catleaves(partreefun(@(x,l,t,d)pwCCS({x,x},l,t,d),obj.Signal,{obj.lag,obj.tau,obj.dim},false),3);
CCS.movCCS=@(obj)partreefun(@(x,l,t,d,k,o)movpwCCS({x,x},l,t,d,k,o),obj.Signal,{obj.lag,obj.tau,obj.dim,obj.window,obj.overlap},false);

CCSpipe=pipe(CCS);

save('CCSpipe','CCSpipe');
save('Fourier','Fourier');
save('PAC','PAC');

%% Running PAC Pipe
clear all 
load('BCItrials_1sec.mat')

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
PCA.setvals([],'all')

%% Run CCS on filtered LFPs
clear all 
load('BCItrials_1sec.mat')

load('Fourier');
load('CCSpipe');

X.Signal=EG6;
X.Frequency_Band=[7,10];

Y.Signal='Filtered_Signal';
Y.dim=6;
Y.tau=10;
Y.lag=0;

%Daisy Chain Pipes
X|Fourier|Y|CCSpipe;

%CCS values 
CCSpipe.CCS;

%Average CCS values 
mCCS=treefun(@(x)mean(x,3),CCSpipe.CCS);







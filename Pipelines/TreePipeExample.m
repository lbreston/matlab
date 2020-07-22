
%% Build Pipes for tree Objects
clear all

% Fourier pipe
Fourier.Frequency_Band= @(obj)pipe.initval('Requires Input');
Fourier.Signal = @(obj)pipe.initval('Requires Input');
Fourier.Fourier_Transform = @(obj)obj.Signal.(@(x)winfft(x,2));
Fourier.Gabor_Spectrogram = @(obj)obj.Signal.(@(x)dimfun(@(y)gaborSpec(y,1000),{x},2));
Fourier.Filtered_Signal= @(obj)obj.Fourier_Transform.(@(x)filtifft(x,@(f)(f>=obj.Frequency_Band(1)&f<=obj.Frequency_Band(2)),1000,2));

Fourier=pipe(Fourier);
save('FourierTree','Fourier');

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
PAC.Abs_Signal=@(obj)obj.Abs_FT.Filtered_Signal;
PAC.Phase= @(obj)obj.Phase_Signal.(@(x)angle(hilbert(x.').'));
PAC.Abs= @(obj)obj.Abs_Signal.(@(x)abs(hilbert(x.').'));
PAC.PA=@(obj)[obj.Phase,obj.Abs];
PAC.PAC=@(obj)catleaves(obj.PA.(@(x,y)tuplefun(@(w,z)modulationIndex(w,z),{x,y},1)),3);
PAC.movPAC=@(obj)catleaves(obj.PA.(@(x,k,o)movfun(@(x)tuplefun(@(w,z)modulationIndex(w,z),{x,y},2),x,k,o)).({obj.window,obj.overlap}),4);

PAC=pipe(PAC);
save('PACTree','PAC');




%% Running PAC Pipe
% clear all 
load('BCItrials_1sec.mat')

%load PAC pipe 
load('PACTree');


%create input struct
I.Signal=tree(BCItrials);
I.Phase_band=[7,10];
I.Abs_band=[80,100];

%Pass Input into Pipe 
I|PAC;

%PAC values 
PAC.PAC;

%Average PAC values 
mPAC=PAC.PAC.(@(x)mean(x,3));

%% clear the pipe if you want to recalculate values 
PAC.clear('all')




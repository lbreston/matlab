% Set the default font type
set(0,'DefaultAxesFontName','Helvetica');
set(0,'DefaultTextFontName','Helvetica');

% Set the default font size to 14 pt
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultTextFontSize',14);

% Set the size of the marker 8 pt
set(0,'DefaultLineMarkerSize',12);

% Set the default line width to 2 pt
set(0,'DefaultLineLineWidth',2);

% Set grid on as default
set(0,'DefaultAxesXGrid','off');
set(0,'DefaultAxesYGrid','off');

set(0,'DefaultAxesGridLineStyle','--');

set(0,'DefaultAxesLineWidth',1);



% Set LaTeX as the default interpreter
set(0,'DefaultTextInterpreter','tex');
set(0,'DefaultLegendInterpreter','tex');


%
set(groot, 'defaultAxesTickDir', 'in');
set(groot,  'defaultAxesTickDirMode', 'manual');

AC=[.05 .05 .05];
set(groot,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{AC,AC,AC})
set(groot,{'DefaultAxesXMinorTick','DefaultAxesYMinorTick','DefaultAxesZMinorTick'},{'on','on','on'})

set(0,'defaultfigurecolor',[1 1 1])

co= [0    0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.4660    0.6740    0.1880;
    0.9290    0.6940    0.1250;
    0.4940    0.1840    0.5560;
    0.3010    0.7450    0.9330;
    0.6350    0.0780    0.1840];

set(groot,'defaultAxesColorOrder',co)




% Set the default MATLAB colours
DefColour.blue   = [0.0000,0.4470,0.7410];
DefColour.red    = [0.8500,0.3250,0.0980];
DefColour.yellow = [0.9290,0.6940,0.1250];
DefColour.purple = [0.4940,0.1840,0.5560];
DefColour.green  = [0.4660,0.6740,0.1880];
DefColour.cyan   = [0.3010,0.7450,0.9330];
DefColour.brown  = [0.6350,0.0780,0.1840];
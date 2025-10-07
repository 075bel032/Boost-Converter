%----Model for a non-isolated boost converter----
clear all;
clc;
disp('The values of the plant parameters:');

% Parameters
Vg = 15;           % V
D = 0.4;            % Steady state duty ratio
L = 2e-3;          % H
C = 10e-6;        % F
R = 100;          % ohms

% STEADY-STATE (LARGE SIGNAL) MODEL
As = [0 -(1-D)/L; (1-D)/C -1/(R*C)];   % [2 x 2]
Bs = [1/L 0 0; 0 -1/C 0];                       % [2 x 3]
Cs = [0 1; 1 0];                                      % [2 x 2]
Ds = [0 0 0; 0 0 0];                               % [2 x 3]

% Steady-state outputs
Vo = -Cs(1,:)*inv(As)*Bs(:,1)*Vg;
Ig   = -Cs(2,:)*inv(As)*Bs(:,1)*Vg;
IL  = Ig;

% Displaying Large-signal model output parameters
disp(['Steady-state output voltage, Vo = ', num2str(Vo), ' V']);
disp(['Steady-state input current, IL = Ig = ',  num2str(IL), ' A']);

% SMALL-SIGNAL MODEL
a = [0 -(1-D)/L; (1-D)/C -1/(R*C)];  % [2 x 2]
b = [1/L 0 Vo/L; 0 -1/C -IL/C];        % [2 x 3]
c = [0 1];                                        % [1 x 2]
d = [0 0 0];                                     % [1 x 3]

ulabels = ['vg iz d'];
ylabels = ['vo ig'];
xlabels = ['il vc'];

% Displaying Large-signal model matrix
disp(['Steady-state or Large-signal model matrix:']);
printsys(As,Bs,Cs,Ds,ulabels,xlabels,xlabels)

% Displaying Small-signal model matrix
disp(['Small-signal model matrix:']);
printsys(a,b,c,d,ulabels,xlabels,xlabels)

% Displaying small-signal model transfer function
disp(['Transfer Function in s-domain:'])
disp(['Vo/d(s)'])
TFb = zpk(tf(ss(a,b(:,3),c,[0])))

% Optional: Pole-Zero Map
figure;
pzmap(TFb);
grid on;
title('Pole-Zero Map of Transfer Function Vo/d(s)');

% Optional: Step Response
figure;
step(TFb);
grid on;
title('Step Response of Transfer Function Vo/d(s)');

% Optional: Root-Locus
figure;
rlocus(TFb);
grid on;
title('Root-Locus of Transfer Function Vo/d(s)');

% Optional: Frequency Response
figure;
bode(TFb);
grid on;
title('Bode Plot of Transfer Function Vo/d(s)');
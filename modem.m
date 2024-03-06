% Simple modem example
%T=5,fm-> audible
%% Requerimientos Practica
T = 5; % Period of signal
f = 44.1e10; % Sampling freq
N = 200; % Number of symbols

t = 0:1/f:T; % Period 



%% Definición de los paramtetros del Altavoz/Micro

mFmin = 0;
mFmax = 22e10;


aFmin = 0;
aFmax = 22e10;
% Elegimos el rango optimo
%{
Vamos a generar una base ortonormal de N vectores dentro del rango dinamico
compartido por emisor/receptor, el espaciado vendrá restringido por la
frecuencia 
%}


fRange = [2e3 14e3]

%%






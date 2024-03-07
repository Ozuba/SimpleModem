% Simple modem example
%T=5,fm-> audible
%% Requerimientos Practica
T = 5; % Period of signal
fs = 44.1e3; % Sampling freq
N = 200; % Number of symbols

t = 0:1/fs:T; % Period


avFreqs = [8e3 22.050e3 44.1e3];
%% Definición de los paramtetros del Altavoz/Micro

tRange = [] %Transceiver Dynamic Range
rRange = [] %Receiver Dynamic Range
% Elegimos el rango optimo
fRange(1) = 400;
fRange(2) = 8e3;


%{
Vamos a generar una base ortonormal de N vectores dentro del rango dinamico
compartido por emisor/receptor, el espaciado vendrá restringido por la frecuencia fudamental
que elegiremos en función del ancho de banda
%}
%Eleccion de la frecuencia fundamental
ff =


%Generamos la matriz base
base = zeros(N,length(t));


for k = 1:N
  base(k,:) = sin(2*pi*ff*t);
end

%%



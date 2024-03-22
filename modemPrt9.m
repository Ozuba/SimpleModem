% Simple modem example
%T=5,fm-> audible
%% Requerimientos Practica
T = 5; % Period of signal
fs = 44.1e3; % Sampling freq
N = 400; % Number of symbols

t = 0:1/fs:T; % Period
%%-------------------------------------- base Ortonormal --------------------------------------%%

%% Definición de los paramtetros del Altavoz/Micro

tRange = [0,1e20] %Transceiver Dynamic Range
rRange = [400,8e3] %Receiver Dynamic Range
% Elegimos el rango optimo
%fMin = 400;
%fMax = 8e3;
fMin = max(tRange(1),rRange(1))
fMax = min(tRange(2),rRange(2))

%{
Vamos a generar una base ortonormal de N vectores dentro del rango dinamico
compartido por emisor/receptor, el espaciado vendrá limitado por la frecuencia fundamental
que elegiremos en función del ancho de banda
%}
%Eleccion de la frecuencia fundamental (Espaciado)
range = fMax-fMin;
%Las queremos lo más separadas posible en el rango
ff = range/N
%Generamos el vector de frecuencias armonicas
fArm = ff*(0:N-1) + fMin;

%Generamos la matriz base
base = zeros(N,length(t));

%Generacion de la base ortogonal y normalizacion
for i = 1:N
    %Base
    base(i,:) = sin(2*pi*fArm(i)*t);
    %Normalización
    l2norm = sqrt(trapz(1/fs,abs(base(i,:)).^2)); %%Sustituir por valor analítico para optimizar
    base(i,:) = base(i,:)/l2norm; % Normalizamos con su norma l2
end



% for i = 1:N
%   sound(base(i,1:10000),fs)
%   pause(0.1)
% end

%%-------------------------------------- Transmision --------------------------------------%%

% Generacion del Mensaje
text = ' Hello world '

bitstream = str2num(reshape(dec2bin(uint8(text),8).', 1, [])')';
%Empezamos la modulacion
pieces = reshape(bitstream, 2, []); %Separamos en piezas de 2
mod = zeros(1,size(pieces,2)); %Cojemos la dimension 1 del vector
%Modulamos un vector unidimensional de tamaño n/2
mod(all(pieces == [0;0])) = -3;
mod(all(pieces == [0;1])) = -1;
mod(all(pieces == [1;0])) = 1;
mod(all(pieces == [1;1])) = 3;
mod


%signal to be sent
sig = zeros(1,length(t));

for k = 1:length(mod)
  sig = sig + base(k,:)*mod(k);
end

%plot(t,sig)
##spectrogram(sig,fs)
##spectrogram(sig, hamming(length(t)), 0.1, 1024, fs, 'yaxis');

%sound(sig,fs)


%%-------------------------------------- Demodulación --------------------------------------%%

demod = zeros(1,N);

for k = 1:N
  demod(k) = trapz(1/fs,base(k,:).*sig);
end

%%Limpiamos morralla y recortamos al tamaño del envio
%demod(abs(demod) < 1e-12 ) = 0;
demod = int32(demod(1:length(mod)));
% Demodulamos recuperando el vector con columnas y resapeandolo
recPieces = zeros(2,size(pieces,2));
recPieces(:,demod == -3) =  repmat([0; 0], 1, nnz(demod == -3));
recPieces(:,demod == -1) = repmat([0; 1], 1, nnz(demod == -1));
recPieces(:,demod == 1) = repmat([1; 0], 1, nnz(demod == 1));
recPieces(:,demod == 3) = repmat([1; 1], 1, nnz(demod == 3));

recBitstream = recPieces(:); %Return to plain old bitstream


% Volvemos al texto

recText = char(bin2dec(reshape(num2str(recBitstream), 8, []).'))



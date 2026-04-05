% Chargement du signal MF-TDMA (contenant les messages des deux utilisateurs) 
load Signal_MF_TDMA.mat

% Ajout du bruit blanc gaussien AWGN: Additive White Gaussian Noise
SNR = 10; % Rapport Signal sur Bruit en dB 
signal_bruite = awgn(signal, SNR, 'measured'); 

% Le timeslot est de 24 millisecondes
timeslot = 0.024;

% Fréquence d'échantillonnage
Fe = 200000;

% Extraction du Message 1 (alloué au slot n°2)
ech1_d = 1*timeslot*Fe; % 4800
ech1_f = 2*timeslot*Fe; % 9600
signal1 = signal_bruite(ech1_d+1:ech1_f);

% Extraction du Message 2 (alloué au slot n°5)
ech2_d = 4*timeslot*Fe; % 19200
ech2_f = 5*timeslot*Fe; % 24000
signal2 = signal_bruite(ech2_d+1:ech2_f);

% --- Démodulation d'amplitude (Retour en bande de base) --- [cite: 60, 62]

% Retour en bande de base du signal1 
F_porteuse1 = 15000;
%t1 = (1/Fe)*(4800:9600);
t1 = (4800:9599)/Fe;
signal_att1 = signal1 .* cos(2*pi*F_porteuse1*t1);

% Retour en bande de base du signal2 
F_porteuse2 = 45000;
%t2 = (1/Fe)*(19200:24000);
t2 = (19200:23999)/Fe;
signal_att2 = signal2 .* cos(2*pi*F_porteuse2*t2);


% --- Filtrage Passe-Bas pour isoler le message démodulé --- 

M=41;
Te=1/Fe;

% Conception du filtre RIF (Réponse Impulsionnelle Finie)
fc = F_porteuse1; 
h1=(2*fc/Fe)*sinc(2*fc*[-(M-1)/2*Te:Te:(M-1)/2*Te]);

% Application du filtre et compensation du retard (à cause du filtre qui est non causal)
signal_av_dem1 = filter(h1,1,signal_att1);
signal_fin1 = [signal_av_dem1(((M-1)/2)+1:end), zeros(1, ((M-1)/2))];

% Extraction du texte
texte1 = Demod_BdB(signal_fin1, 10);


% Conception du filtre RIF (Réponse Impulsionnelle Finie)
fc = F_porteuse2;
h2=(2*fc/Fe)*sinc(2*fc*[-(M-1)/2*Te:Te:(M-1)/2*Te]);

% Application du filtre et compensation du retard de groupe (à cause du filtre qui est non causal)
signal_av_dem2 = filter(h2,1,signal_att2);
signal_fin2 = [signal_av_dem2(((M-1)/2)+1:end), zeros(1, ((M-1)/2))];

% Extraction du texte
texte2 = Demod_BdB(signal_fin2, 10);

fprintf('Indice 1 : %s\n', texte1);
fprintf('Indice 2 : %s\n', texte2);

%Les initiales de Jean-Yves Tourneret sont JYT.
%Lues à l'envers, elles deviennent TYJ, ce qui phonétiquement évoque la "Tige", le vert support.



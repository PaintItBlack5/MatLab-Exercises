%% *HOMEWORK 2* Capobianco Salvatore 0124000974
%% *PUNTO 1*
% _Visualizzare la foto del Vesuvio e poi visualizzare la foto con i 40
% punti evidenziati in rosso sul contorno. Per comodit�, le componenti
% dei vettori x e y possono essere scalate, per esempio dividendole
% per 1000._
% 
load 'mieidati';
image(A)
%%
image(A)
hold on;
plot(x,y,'or',x,y,'r','MarkerSize', 8);
hold off;
x=x./1e3;
y=y./1e3;
%% *PUNTO 2*
% _Interpolare i 40 punti sul contorno con una spline cubica e con una
% cubica di Hermite, visualizzando (su una griglia fitta di 500 punti) 
% il Vesuviospline e il VesuviocubHerm. Commentare i risultati._

xx=linspace(x(1),x(end),500);
VesuvioSpline=spline(x,y,xx);
VesuvioCubHerm=pchip(x,y,xx);
plot(x,y,'ro',xx,VesuvioSpline,'g',xx,VesuvioCubHerm,'b')
set(gca, 'ydir' , 'reverse')
legend('Nodi di interpolazione', 'Spline Cubica "not a knot"', 'Cubica di Hermite','Location','southeast')
%%
% Le due funzioni interpolanti sono quasi identiche (i loro grafici si sovrappongono
% quasi per tutta la griglia); tuttavia ci sono delle differenze sostanziali
% che � possibile apprezzare in specifici sottointervalli, in particolare
% quelli in cui i *nodi cambiano valori pi� rapidamente* o, in altri termini,
% laddove ci sono dei *bruschi cambiamenti della pendenza*,
% ovvero delle *derivate*, delle funzioni interpolanti. Queste differenze
% sono dovute proprio alla natura delle Spline Cubiche e delle Cubiche di
% Hermite: le prime con derivate prima e seconda continue e derivata terza
% eventualmente discontinua, ma solo nei nodi, le seconde con derivata
% prima continua e derivata seconda eventualmente discontinua solo nei
% nodi. Quindi le Spline Cubiche, in generale, interpolano con maggiore
% accuratezza delle Cubiche di Hermite, poich� hanno un andamento "pi� liscio", seppure
% entrambe abbiano delle criticit� intorno ai "picchi".
% Tuttavia le cubiche di Hermite trovano la loro ragione di esistere e l'impiego nella grafica
% computazionale, poich� interpolano _"a conservazione di forma"_ *(shape
% preserving)*, cio� vengono costruite in modo tale (pendenze nei nodi determinate automaticamente)
% che non oscillino intorno ai nodi, evitando, cosi, l'overshooting, o, in altri termini, *conservano la
% monotonicit� locale dei dati*.

VesuvioDiff=abs(VesuvioCubHerm - VesuvioSpline);
plot(x,zeros(size(x)),'ro',xx,VesuvioDiff,'k')
title('Differenza di ricostruzione')

%% *PUNTO 3* 
% _Utilizzando la cubica di Hermite del punto 2, generare le ordinate di punti
% sul contorno del VesuviocubHerm in corrispondenza di 15 nodi di Chebychev 
% e visualizzare in verde tali punti._

for k=1:15
    xk(k)=-cos((k-1)*pi/14);
end
a=x(1);
b=x(end);
xchebab=(a+b)/2+xk.*((b-a)/2);
ychebab=pchip(x,y,xchebab);
plot(xx,VesuvioCubHerm,xchebab,ychebab,'sg')
set(gca, 'ydir' , 'reverse')
legend('VesuvioCubHerm','Nodi di Chebychev','Location','southeast')

%% *PUNTO 4*
% _Interpolare i 15 punti ottenuti in 3 con un polinomio e visualizzare
% (su una griglia fitta di 500 punti) il suo grafico. Commentare il risultato._

P14=polyfit(xchebab, ychebab, 14);
y14=polyval(P14,xx);
plot(xchebab,ychebab,'sg',xx,y14);
set(gca, 'ydir' , 'reverse');
legend('Nodi di Chebychev','Polinomio grado 14 interpolante','Location','southeast')

%%
% Poich� su n punti, interpola (se esiste, cio� se la matrice dei coefficienti � non singolare)
% un unico polinomio di grado n-1, il polinomio di grado 14 interpolante
% sui 15 nodi di Chebychev *esiste ed � unico*. Si noti, come ci si
% attendeva, che i nodi di Chebychev sono pi� fitti, pi� densi in
% prossimit� degli estremi dell'intervallo, al fine di evitare le
% *oscillazioni spurie* (localizzate agli estremi dell'intervallo e che non
% ricostruisco informazioni dei dati) che caratterizzano proprio
% l'interpolazione con polinomi su un numero relativamente elevato di nodi
% *equispaziati*, poich� per questo insieme di funzioni, al crescere del numero 
% di nodi cresce anche il grado del polinomio.

%% *PUNTO 5*
% _Costruire esplicitamente la matrice B che descrive le condizioni di interpolazione
% sui 15 nodi di Chebychev e calcolare il suo indice di condizionamento.
% Commentare il valore di tale indice._

for j=1:15
    B(:,j)=xchebab.^(15-j);
end
B
cond(B)

%%
% Come gi� segnalato dal Matlab, con il corrispondente "warning" nella polyfit del punto 4,
% il problema di interpolazione con il polinomio di grado 14
% sui 15 nodi di Chebychev � *mal condizionato*. Un problema risulta essere ben condizionato quando il suo indice di
% condizionamento � uguale o "vicino" a 1, poich�, in tal caso l'errore
% assoluto � maggiorato e minorato dal residuo: 
%
% |r = y - B*x|
%
% |r/cond(B) <= Ea <= r*cond(B)|
%
% Al crescere dell'indice di condizionamento, la matrice dei coefficienti
% si avvicina all'essere singolare, come nel nostro caso, in cui |cond(B)| �
% molto maggiore di 1, pertanto si allarga la forbice di incertezza sulla
% soluzione.

%% *PUNTO 6*
% _Usando i 15 punti ottenuti in 3, determinare il polinomio di grado 8 e di grado 12 dei minimi quadrati e
% visualizzare (su una griglia fitta di 500 punti) il VesuvioMQ8 e il VesuvioMQ12. Commentare i risultati._

VesuvioMQ8=polyval(polyfit(xchebab,ychebab,8),xx);
VesuvioMQ12=polyval(polyfit(xchebab,ychebab,12),xx);
plot(xchebab,ychebab,'sg',xx,VesuvioMQ8,'b',xx,VesuvioMQ12,'r')
legend('Nodi di Chebychev','VesuvioMQ8','VesuvioMQ12','Location','southeast')
set(gca, 'ydir' , 'reverse');

%%
% Il polinomio dei minimi quadrati di grado 12 � un migliore approssimante
% di quello di grado 8. In controtendenza all'interpolazione mediante
% polinomi in cui al crescere del numero dei nodi, cresce anche il grado
% del polinomio, e peggiora la qualit� della ricostruzione del fenomeno
% continuo, l'approssimazione dei minimi quadrati
% migliora al tendere all'infinito del grado del polinomio, fino a
% diventare essa stessa una funzione interpolante quando il numero dei coefficienti
% raggiunge ed � uguale al numero dei nodi *(l'interpolazione �
% un caso limite di approssimazione)*.
%% *PUNTO 7*
% _Usando opportunamente la cubica di Hermite interpolante per ottenere i valori del contorno di VesuviocubHerm,
% determinare un'approssimazione dell'integrale definito del Vesuvio mediante il metodo
% Monte Carlo (con 1000 punti) e mediante trapezoidale composita con 100 punti. Commentare i risultati._

format long
xr=a+(b-a)*rand(1,1000);
QfMC=mean(pchip(x,y,xr))*b-a

%%

xtrap=linspace(a,b,100);
ytrap=pchip(x,y,xtrap);
h=(b-a)/99;
QfTC=h*(0.5*(ytrap(1)+ytrap(end))+sum(ytrap(2:end-1)))

DQf=abs(QfMC-QfTC)

%%
% Come atteso, la differenza tra le due approssimazioni dell'integrale
% definito � relativamente grande nonostante *una venga
% applicata su 1000 punti mentre l'altra su 100 punti*.
% Questo perch�, per quanto riguarda il metodo Monte Carlo, *per ridurre l'errore di
% un fattore 10*, cio� per guadagnare una cifra significativa in base 10
% corretta, *� necessario moltiplicare il numero dei punti per un
% fattore 100*. Ci� significa che le formule di quadratura Monte Carlo, bench� siano
% sempre convergenti, hanno una bassa velocit� di convergenza; tuttavia
% risultano particolarmente convenienti nel caso di integrali definiti
% multi-dimensionali poich� l'errore di quadratura � indipendente dal
% numero delle dimensioni:
%
% |abs(If-QfMC) = alpha*(b-a)/sqrt(n)| 
%
% dove n � il numero di punti
%
% Mentre, per quanto riguarda la trapezoidale composita, *al raddoppiare
% del numero dei punti, l'errore di quadratura diminuisce di un fattore 4, e si
% annulla se f � lineare* (polinomio di primo grado quindi con derivata
% seconda nulla).
%
% Th sull'errore di quadratura della formula composita trapezoidale su n nodi:
%
% |abs(If-QfTC) <= ((K*(b-a))/12)*h^2 = (K*(b-a)^3)/(12*n^2)|
%
% dove K � un maggiorante della derivata seconda.

%% *PUNTO 8*
% _Considerare i 500 valori di VesuviocubHerm sulla griglia fitta e determinare la media, la mediana, il
% percentile 25, il percentile 90, la deviazione standard e la varianza di tali dati. Visualizzare il box and
% wiskers plot di tali dati (comando boxplot)._
%%
% La media � un indice di posizione della distribuzione dei dati,
% � compresa tra il pi� grande e il pi� piccolo dei dati del campione.
media=mean([xx,VesuvioCubHerm])

%%
% La mediana � un numero che � maggiore o uguale del 50% dei dati del campione 
% e minore o uguale del restante 50%. Infatti � il parametro
% ordinale centrale se n � dispari, la media dei due parametri ordinali
% centrali se n � pari, dove n � il numero dei campioni.
mediana=median([xx,VesuvioCubHerm])

%%
% Il quantile-p con p in [0,1], � un numero che � maggiore o uguale del (100*p)%
% dei dati del campione e minore o uguale del restante (100*(1-p))%.
% Quindi *la mediana � il quantile-0.50*; 
% Il quantile-p � anche detto (100*p) percentile.
% Il quantile-0.25 � detto *primo quartile* del campione:
perc25=prctile([xx,VesuvioCubHerm],25)
%%
perc90=prctile([xx,VesuvioCubHerm],90)
%calcola il quantile-0.90 (90-percentile), cio� relativo al 90% del campione.
%%
% La deviazione standard � un indice delle distanze dei dati dalla media,
% che valuta la distanza nella stessa unit� di misura dei dati; essa �
% uguale alla radice quadrata dello scarto quadratico medio (root mean
% square).

devstd=std([xx,VesuvioCubHerm])
%%
% La varianza � un indice delle distanze dei dati dalla media, che valuta
% la distanza come il quadrato dello scarto. E' interpretabile come una media
% delle distanze tra tutte le possibili coppie di dati. La varianza � il
% quadrato della deviazione standard.
varianza=var([xx,VesuvioCubHerm])
ctrlvarianza=devstd^2
%%
boxplot([media,mediana,perc25,perc90,devstd,varianza])
title('Box & Whiskers plot')
%%
% Si noti che:
%
% * Non ci sono outliers (dati anomali, perch� distanti dalle altre
% osservazioni, ragionevolmente ritenuti errati);
% * La mediana � molto vicina al terzo quartile;
% * L'area del sottobox Q25_mediana � molto pi� grande del sottobox mediana_Q75,
% ci� significa che la distribuzione dei dati � molto pi� concentrata tra
% il primo quartile e la mediana.
%
%
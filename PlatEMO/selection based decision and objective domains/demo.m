
function demo

% Parameters
n = 30;     % Number of variables of the problem
m = 2;      % Number of objective functions
N = 100;    % Population size
h = 0.5;    % Selection percentage
tour = 2;   % Binary-Tournament Selection



% Initial population
P  = rand(n,N); % decision variables
jP = rand(m,N); % objective functions evaluation



% Elitist Archive E1,jE1 (based on Pareto Dominance)
[E1,jE1] = ndset(P,jP);

% Crowding distance assignment 
cdist = crowding_distance_assignment(jE1);

% Neighbor distance assignment 
ddist = neighbor_distance_assignment(E1);



Ns1 = round(h*N);
Ns2 = N - Ns1;

% Crowding Distance based selection (t-tournament selection)
[S1,jS1] = distance_based_selection(E1,jE1,Ns1,tour,cdist);

% Neighbor Distance based selection (t-tournament selection)
[S2,jS2] = distance_based_selection(E1,jE1,Ns2,tour,ddist);

% Selected population
S   = [ S1  S2];
jS  = [jS1 jS2];




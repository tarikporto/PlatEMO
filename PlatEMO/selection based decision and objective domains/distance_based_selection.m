
function [S,jS] = distance_based_selection(E,jE,Ns,t,distance)

% Distance Based Selection (t-Tournament Selection)

[n,N] = size(E);
m  = size(jE,1);
S  = zeros(n,Ns);
jS = zeros(m,Ns);
t  = min(t,N);
for i = 1:Ns,
    jsel = randperm(N,N);    
    jsel = jsel(1:t);
    [~,best] = max(distance(jsel));
    S(:,i)   = E(:,jsel(best));    
    jS(:,i)  = jE(:,jsel(best));    
end



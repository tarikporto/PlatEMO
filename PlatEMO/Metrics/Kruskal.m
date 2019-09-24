
% Generate a Minimum Spanning Tree (MST)

function D = Kruskal(xy)

% Calculate pairwise distance between the nodes
dvec = (pdist(xy,'euclidean'));

n = size(xy,1); 
y = 1:n;
k = 1;
E = zeros(length(dvec),2);
for i = 1:n-1,
    E(k:k+n-i-1,:) = [i*ones(n-i,1) y(i+1:end)'];
    k = k+n-i;
end
E = [E dvec(:)]; 
[~,jsort] = sort(E(:,3));
E = E(jsort,:); 

index = 1:n;
subtree(n).index = [];
for i = 1:n,
    subtree(i).index = i;
end

k = 1;
T = [];
D = [];
while (size(T,1) < n - 1) && (size(E,1) ~= 0),
    
    u = E(k,1);
    v = E(k,2);
    d = E(k,3);
    k = k + 1;
    
    subtree_u = index(u);
    subtree_v = index(v);
    
    if subtree_u ~= subtree_v,
        subtree(subtree_u).index = [subtree(subtree_u).index subtree(subtree_v).index];
        index(subtree(subtree_v).index) = subtree_u;
        subtree(subtree_v).index = [];
        T = [T; [u v]];
        D = [D; d];
    end
end

D = sum(D);

% figure(1)
% hold on
% % plot pipes
% for k = 1:size(T,1),
%     plot(xy([T(k,1) T(k,2)],1),xy([T(k,1) T(k,2)],2),'-k','LineWidth',2)
% end
% 
% % plot nodes
% plot(xy(:,1),xy(:,2),'ko','MarkerFaceColor','r','MarkerSize',10)
% drawnow
% hold off




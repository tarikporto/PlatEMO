
function Idist = neighbor_distance_assignment(I)

% Return the distance of each solution to their third nearest neighbor,
% considering the decision space

N = size(I,2);
if N == 1,
    Idist = 1;
else
    distanceMatrix = squareform(pdist(I'));
    sdist = sort(distanceMatrix,2);
    Idist = sdist(:,min(N,4))';
end

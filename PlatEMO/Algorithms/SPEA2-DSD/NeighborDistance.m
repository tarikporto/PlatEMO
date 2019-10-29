function NeighborDis = NeighborDistance(PopDec, k)
% Calculate the neighbor distance of each solution front by front

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    N = size(PopDec,1);
    if N == 1,
        NeighborDis = 1;
    else
        distanceMatrix = squareform(pdist(PopDec));
        sdist = sort(distanceMatrix,2);
        NeighborDis = sdist(:,min(N,k))';
    end
end
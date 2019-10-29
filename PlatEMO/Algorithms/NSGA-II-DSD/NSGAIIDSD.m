function NSGAIIDSD(Global)
% <algorithm> <N>
% Nondominated sorting genetic algorithm II - Space Decision Diversity
% nsp --- 0 --- Rate of knee points in the population

%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Parameter setting
    nsp = Global.ParameterSet(0);

    %% Generate random population
    Population = Global.Initialization();
    [~,FrontNo, CrowdDis, NeighDis] = Selection(Population, Global.N);
    
    %% Optimization
    while Global.NotTermination(Population)
        %X = Population.decs;
        %plot(X(:,1),X(:,2),'o');
        MatingPool = TournamentSelectionNSP(2,Global.N,FrontNo,-CrowdDis, -NeighDis, nsp);
        Offspring  = GA(Population(MatingPool));
        [Population,FrontNo,CrowdDis, NeighDis] = Selection([Population,Offspring],Global.N);
    end
end
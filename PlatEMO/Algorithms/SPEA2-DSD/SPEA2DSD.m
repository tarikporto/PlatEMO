function SPEA2DSD(Global)
% <algorithm> <S>
% Strength Pareto evolutionary algorithm 2

%------------------------------- Reference --------------------------------
% E. Zitzler, M. Laumanns, and L. Thiele, SPEA2: Improving the strength
% Pareto evolutionary algorithm, Proceedings of the Fifth Conference on
% Evolutionary Methods for Design, Optimization and Control with
% Applications to Industrial Problems, 2001, 95-100.
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
    [Fitness, DSFitness] = CalFitnessDSD(Population.objs, Population.decs);
    
    %% Optimization
    while Global.NotTermination(Population)
        MatingPool = TournamentSelectionNSP(2,Global.N,Fitness,DSFitness,nsp);
        Offspring  = GA(Population(MatingPool));
        [Population,Fitness,DSFitness] = EnvironmentalSelection([Population,Offspring],Global.N);
    end
end
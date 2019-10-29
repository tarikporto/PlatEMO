function index = TournamentSelectionNSP(K,N,Fitness, DSFitness, nsp)

    Nnd = round(nsp*N);
    bestND = TournamentSelection(K,Nnd, DSFitness);
    
    Ncd = N - Nnd;
    bestCD = TournamentSelection(K,Ncd, Fitness);

    index = [bestND bestCD];
end


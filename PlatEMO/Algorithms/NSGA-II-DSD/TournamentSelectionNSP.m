function index = TournamentSelectionNSP(K,N,FrontNo, oppCrowdDis, oppNeighDis, nsp)

    Nnd = round(nsp*N);
    bestND = TournamentSelection(K,Nnd, FrontNo, oppNeighDis);
    
    Ncd = N - Nnd;
    bestCD = TournamentSelection(K,Ncd, FrontNo, oppCrowdDis);

    index = [bestND bestCD];
end


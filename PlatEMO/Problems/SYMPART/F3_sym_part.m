function F3 = F3_sym_part(X, a, b, c, w, eps, L, U)
%SYM_PART Summary of this function goes here
%   Detailed explanation goes here
    X2 = X(:,2);

    
    F3 = F2_sym_part([distorts_2d(X, eps, L, U) X2], a, b, c, w);
end


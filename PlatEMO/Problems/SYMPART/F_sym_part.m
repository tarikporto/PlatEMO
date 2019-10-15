function F = F_sym_part(X, a)
%SYM_PART Summary of this function goes here
%   Detailed explanation goes here
    X1 = X(:,1);
    X2 = X(:,2);

    
    F = [(X1 + a).^2 + X2.*X2 (X1 - a).^2 + X2.*X2];
end


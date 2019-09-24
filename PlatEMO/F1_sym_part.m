function F1 = F1_sym_part(X, a, b, c)
%SYM_PART Summary of this function goes here
%   Detailed explanation goes here
    X1 = X(:,1);
    X2 = X(:,2);

    t1_hat = sign(X1) * ceil((abs(X1) - (a + c/2))/(2*a + c));
    t2_hat = sign(X2) * ceil((abs(X2) - (b/2))/b);
    
    t1 = sign(t1_hat)*min(abs(t1_hat),1);
    t2 = sign(t2_hat)*min(abs(t2_hat),1);
    
    F1 = [(X1 - t1*(c+2*a)) X2 - t2*b];
end


function distorted_X = distorts_2d(X, eps, L, U)
    
    X1 = X(:,1);
    X2 = X(:,2);
    
    distorted_X = X1 .* ((X2 - L + eps)/(U - L)).^-1;

end


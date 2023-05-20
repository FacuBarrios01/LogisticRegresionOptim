function [J,dJ] = ff_logistic_reg(theta,X,Y)    
    m = length(X); %We could use length of Y also
 
    h = 1 ./ (1 + exp(-theta' * X));
    J = (-1/m) * sum(Y.*log(h) + (1 - Y) .* log(1 - h));
    dJ = (1/m) * ((h - Y) * X');
end
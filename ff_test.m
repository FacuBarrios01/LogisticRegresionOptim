function [y, dy] = ff_test(x)
    syms xe ye
    
    fsym = (xe + 2*ye - 7)^2 + (2*xe + ye - 5)^2;
    grad = gradient(fsym, [xe, ye]);

    y = (x(1) + 2*x(2) - 7).^2 + (2*x(1) + x(2) - 5).^2;
    dy = double( subs(grad, [xe, ye], [x(1), x(2)]));
end
function y = predict(x, theta)
    h = 1 ./ (1 + exp(-theta' * x));

    y = h >= 0.5;
end
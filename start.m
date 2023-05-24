clc, clearvars, close all

disp("Author: Facundo Agustin Rodriguez");
% Test function
x0 = rand(1,2)*20 - 10;
lx = -10:0.5:10;
ly = -10:0.5:10;

options = optimoptions(@fminunc,'Display','off');
[x,fval,exitflag,output] = fminunc(@ff_test, x0, options);
fprintf('Optimun found for test function is [%.4f, %.4f]\n Number of objective calls = %d \n', x, output.funcCount);

[Xg,Yg] = meshgrid(lx, ly);
Z = zeros(length(lx), length(ly));
%Z = arrayfun(@(x, y) ff_test([x, y]), Xg, Yg)

% I am not sure if this implementation is correct, but as it makes use 
% of the element-wise operator it is WAY FASTER(x~40) than using the
% standar function with the symbolics library
for i=1:length(Xg)
    Z(:,i) = ff_test_vectorial([Xg(:,i),Yg(:,i)]);
end

% tic
% Z = zeros(length(lx), length(ly));
% for i=1:size(Z)
%     for j=1:length(Z)
%         Z(i,j) = ff_test([Xg(i,j),Yg(i,j)]);
%     end
% end
%toc
contour(Xg, Yg, Z, 50);
hold on;


plot(x0(1), x0(2), 'ro');
text(x0(1), x0(2), 'Starting Point');

plot(x(1), x(2), 'bo');
text(x(1), x(2), 'Found optimun');

xlabel('x1');
ylabel('x2');
title('Test Function Contour plot');
grid on;
hold off;

% Logistic regression
data = load('data.mat');
X = data.X;
Y = data.Y;
theta0 = zeros(3,1);

options = optimset('Display', 'off', 'Algorithm', 'Quasi-Newton', 'GradObj', 'on');
[theta,J,exitflag,output] = fminunc(@(e) ff_logistic_reg(e, X, Y), theta0, options);
fprintf('Optimun found logistic regression: \n Theta = [%.4f; %.f4 ;%.4f] \n J = %.4f \n Number of objective calls = %d \n', theta, J, output.funcCount);

y = predict(X, theta);
numAsserts = sum(y == Y);
fprintf('Number of correct predictions = %d \n', numAsserts);

figure; 
hold on;

admitted = find(y == 1);
notAdmitted = find(y == 0);

plot(X(2, admitted), X(3, admitted), 'k+', 'MarkerFaceColor', 'blue');
plot(X(2, notAdmitted), X(3, notAdmitted), 'ko', 'MarkerFaceColor', 'red'); 
xlabel('First Grade');
ylabel('Second Grade');
title('Decision boundary');
hold off;

function y = ff_test_vectorial(x)
    y = (x(:,1) + 2*x(:,2) - 7).^2 + (2*x(:,1) + x(:,2) - 5).^2;
end


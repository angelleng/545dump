function [] = main()
clear all; close all;
n = 200;
rng(0); % seed random number generator
x = rand(n,1);
z = zeros(n,1); k = n*0.5; rp = randperm(n); ...
outlier_subset = rp(1:k); z(outlier_subset)=1; % outliers
y = (1-z).*(10*x + 5 + randn(n,1)) + z.*(20 - 20*x + 10*randn(n,1));
% plot data and true line
scatter(x,y,'b')
hold on
t = 0:0.01:1;
plot(t,10*t+5,'k')
% add your code for ordinary least squares below

b_ols = (x'*y - n*mean(x)*mean(y))/(x'*x - n*(mean(x)^2)) ; 
w_ols = mean(y) - b_ols*mean(x); 

plot(t, w_ols*t + b_ols, 'g--');
% add your code for robust regression MM algorithm below




plot(t, w_rob*t + b_rob, 'r:');
% legend(’data’,’true line’,’least squares’,’least absolute error’)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [w,b] = wls(x,y,c);
% a helper function to solve weighted least squares

function [w,b] = wls(X,y,c) 
theta = pinv(X'*c*X)*X'*c*y; 


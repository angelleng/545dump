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

X = [ones(n,1), x]; 
theta = wls(X, y, eye(200)); 
b_ols = theta(1); 
w_ols = theta(2); 

plot(t, w_ols*t + b_ols, 'g--');
% add your code for robust regression MM algorithm below

X = [ones(n,1), x]; 
r = @(theta) (y - X*theta);  
J = @(theta) sum(abs(y - X*theta)); 
theta = zeros(2,1); 
    
for iter = 1:50 
    obj_old = J(theta); 
    c = diag(abs(r(theta).^(-1))); 
    theta_new = wls(X, y, c); 
    obj_new = J(theta_new); 
    if abs((obj_old-obj_new)/obj_new) < 1e-6
        break
    end 
    theta = theta_new; 
end 
b_rob = theta(1);
w_rob = theta(2); 
plot(t, w_rob*t + b_rob, 'r:');
legend('data','true line','least squares','least absolute error')

fprintf('estimates for w and b using orginal least squares are: %3.2f, %3.2f.\n', w_ols, b_ols); 
fprintf('estimates for w and b using least absolute errors are: %3.2f, %3.2f.\n', w_rob, b_rob); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta = wls(X,y,c) 
theta = pinv(X'*c*X)*X'*c*y; 


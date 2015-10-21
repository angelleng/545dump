load mnist_49_3000
[d, n] = size(x);
i = 2;
% imagesc(reshape(x(:, i), [sqrt(d), sqrt(d)])')

y = y*2 -1; 

training = x(:, 1:2000);

test = x(:, 2001:3000);

theta = zeros(d+1, 1); % initialize theta 

xhat = [ones(d, 1), x]; 

lamda = 10; 

% function out = j(in) 
% out = -sum((y(i) - 1/(1+exp(in'xhat(i,:))))*xhat(i, :), i = 1..d) + 2 * lamda * in 
% end 


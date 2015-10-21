clear
close all
load diabetes_scaled

rng(0);
sigma = 2.^(-2:3);
C = 2.^(6:11);
[sig_grid,C_grid]=ndgrid(sigma,C);
para = [sig_grid(:), C_grid(:)];

[n, d] = size(X);

n_tr = 500;
n_ts = n - n_tr; 
X_tr = X(1:n_tr,:);
y_tr= y(1:n_tr, :);
X_ts = X(n_tr+1:end,:);
y_ts = y(n_tr+1:end, :);

fold = 5;
n_ex = n_tr/fold;

riskj = [];

for j = 1:36
    
    riski = [];
    
    for i = 1:fold;
        X_in = X_tr;
        X_in((100*i-99):(100*i),:) = [];
        y_in = y_tr;
        y_in((100*i-99):(100*i)) = [];
        
        X_ex = X_tr((100*i-99):(100*i),:);
        y_ex = y_tr((100*i-99):(100*i));
        
        sig = para(j,1);
        C = para(j, 2);
        
        K = exp(-dist2(X_in, X_in)/(2*sig));
        
        [alpha, bias] = smo(K, y_in', C, 0.01);
        
        Kx = exp(-dist2(X_in, X_ex)/(2*sig));
        y_ex_pred = sign((alpha.*y_in'*Kx)' + bias);
        
        
        riski = [riski, 1/n_ex * sum(y_ex ~= y_ex_pred)];
        
    end
    
    riskj = [riskj, sum(riski)/ fold];
    
end
sig = para(riskj == min(riskj), 1);
C = para(riskj == min(riskj), 2);

K = exp(-dist2(X_tr, X_tr)/(2*sig));

[alpha, bias] = smo(K, y_tr', C, 0.01);

Kx = exp(-dist2(X_tr, X_ts)/(2*sig));
y_pred = sign((alpha.*y_tr'*Kx)' + bias);

error = 1/n_ts * sum(y_ts ~= y_pred);

fprintf('the selected parameters are: sigma = %i, C = %i.\n', sig, C); 
fprintf('the CV error at these parameters is %3.3f. \n', min(riskj)); 
fprintf('the test error is %3.3f. \n', error); 

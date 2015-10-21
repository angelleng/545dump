clear all

%homework2 problem 4: spam filter 
z = dlmread('spambase.data',',');
rand('state',0); % initialize the random number generator
rp = randperm(size(z,1)); % random permutation of indices
z = z(rp,:); % shuffle the rows of z
x = z(:,1:end-1);
y = z(:,end);

spamrate = sum(y)/length(y); %proportion of spam mails in the data base 
med  = median(x, 1); 

[N, d] = size(x); 

% catagorize every entry to 0's and 1's by their relation to the median. 
for i = 1: N 
    for j = 1:d  
    if x(i,j) <= med(j) % can either be < or <=. Here < is used. 
        x(i,j) = 0;
    else x(i,j) = 1; 
    end 
    end 
end 

% allocating training and testing data
x_train = x(1:2000,:); 
x_test = x(2001:end, :);
y_train = y(1:2000); 
y_test = y(2001:end); 

[n,d] = size(x_train); 

%calculating the marginal pml 
sum1 = sum(y_train); %n(y =1 ) 
sum2 = n - sum(y_train);  %n(y = 0) 
ccm = []; 
for i = 1: d
    ccm = [ccm; (( 1- x_train(:,i))'*y_train + 1) / (sum1 + 2) , ((1 - x_train(:, i))'*(1- y_train) + 1) / ( sum2 +2) ];   
end 

l = length(x_test); 

y_prob1 = abs(prod(x_test - repmat(ccm(:, 1)', l ,1), 2)); % calculating g(x)|y=1  
y_prob0 = abs(prod(x_test - repmat(ccm(:, 2)', l ,1), 2)); %calculating g(x)|y=0
y_pred = y_prob1 > y_prob0; 

errorrate1 = sum(y_pred == y_test) / l; 
fprintf('proportion of spams: %d\n', spamrate); 
fprintf('error rate of prediction (allocating medians to 1): %d\n', 1 - errorrate1); 

1 - errorrate1





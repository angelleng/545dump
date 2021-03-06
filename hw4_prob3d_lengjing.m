load nuclear
rng(0);
lamda = 0.001;

[d,n] = size(x);

X = [ones(1,n);x];

P = diag([0, ones(1,d)]);

J = @(theta) 1/n*sum(max(0, 1 - y.*(theta'*X))) + lamda/2*theta'*P*theta;

theta = zeros(3,1);

v_obj = [];


for iter = 1:3
    
    
    order = randperm(n);
    

    for jter = 1:n
        obj = J(theta);
        ind = order(jter);
        cond = 1 - y(ind)*(theta'*X(:,ind)) > 0;
        u = -(cond*y(ind)/n*X(:,ind)) + lamda*P*theta/n;
        theta = theta - (100/iter)*u;
        obj_new = J(theta);
        
        v_obj = [v_obj, obj_new];
        
        
    end
%     if abs(obj_new - obj)/obj < 1e-10
%         stopsign = 1;
%         break
%     end
end

plot(v_obj);


scatter(x(1,:), x(2,:)); 
hold on
plot(x(1,:), (-theta(1) - theta(2)*x(1,:))/(theta(3)), 'k'); 


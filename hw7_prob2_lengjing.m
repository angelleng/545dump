%%%%%%%%%%%%%%%%% 545 HW 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all
load yalefaces % loads the 3-d array yalefaces
% for i=1:100
%     x = double(yalefaces(:,:,i));
%     %     imagesc(x);
%     subplot(10, 10, i);
%     imagesc( x / max(x(:)))
%     
%     colormap(gray)
%     drawnow
%     pause(.1)
% end

X = reshape(yalefaces, [48*42, 2414]);
X = double(X);
X_tilde = X - repmat(mean(X, 2), 1, 2414); 
[U,S,V] = svd(X_tilde);

lam = diag(S).^2;
tot_var = sum(lam);

for i = 1:2414
    if sum(lam(1:i))/tot_var < .95
        pca95 = i+1;
    end 
    if sum(lam(1:i))/tot_var < 0.99 
        pca99 = i+1; 
    else break; 
    end
end

eigenfaces = zeros(2016, 20); 

eigenfaces(:,1) = mean(X,2); 
for i = 1:19
    eigenfaces(:,i+1) = U(:,i); 

end 

figure

plot(lam); 

figure

for i=1:20
    subplot(4, 5, i); 
    x = eigenfaces(:,i);
    x = reshape(x, [48, 42]); 
    imagesc(x); 
    colormap(gray)
end


clear
close all
% load image
y = double(imread('mandrill.tiff'));

imagesc( y / max(y(:)))



%% initialization 
% extract blocks
M = 2; % block side-length
n = numel(y)/(3*M*M); % number of blocks
d = size(y,1); % image length/width
c=0; % counter
x = zeros(n,3*M*M);
k = 100;

for i=1:M:d % loop through blocks
    for j=1:M:d
        c = c+1;
        x(c,:) = reshape(y(i:i+M-1,j:j+M-1,:),[1,M*M*3]);
    end
end


rng(0);
perm = randperm(n);
m = x(perm(1:k),:); % initial cluster centers
%% k-means 
lab_old = zeros(1, n);

w = [];

for j = 1:1000
    
    [mini, lab] = min(dist2(m,x));
    
    if lab_old == lab
        break;
    end
    
    sse = 0; 
    
    for i = 1:k
        m(i,:) = mean(x(lab == i,:));
    end
    lab_old = lab;
    
    
   % calculate sse 
    for i = 1:size(x,1) 
        sse = sse + (x(i,:) - m(lab(i), :))*(x(i,:) - m(lab(i), :))';  
    end 
        
    w = [w, sse];  
    
end

%% label points with centroid 
new = x;
for i = 1:size(x,1)
    new(i,:) = m(lab(i),:);
end

%% reconstruct the compressed image 
c = 0;
y_new = zeros(size(y));
for i=1:M:d % loop through blocks
    for j=1:M:d
        c = c+1;
        x(c,:) = reshape(y(i:i+M-1,j:j+M-1,:),[1,M*M*3]);
        y_new(i:i+M-1,j:j+M-1,:) = reshape(new(c,:), [M,M,3]);
    end
end

figure
imagesc( y_new / max(y_new(:)));

figure 
imagesc( abs(y_new - y) /max(abs(y_new(:)-y(:)))); 

%% plot objective function 
figure 
plot(w); 

% error 
e = 1/numel(y)*sum(abs(y(:)-y_new(:)))/256; 




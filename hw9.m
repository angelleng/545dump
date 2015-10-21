%%%%%%%%% 545 HW 9 Jing Leng %%%%%%%%%
clear all 
image = double(imread('peppers_color.tiff','tiff'));
[imheight imwidth ~] = size(image);
imvec = [reshape(image,imwidth*imheight,3) ...
    repmat((1:imheight)',imwidth,1) ...
    kron((1:imwidth)',ones(imheight,1))];
rng(0);
imvec = imvec(randperm(imheight * imwidth) ,:);

figure
imagesc(uint8(image)); 

n = imheight * imwidth;
loc = imvec(:,4:5); 

%% whitening
immean = repmat(mean(imvec), n, 1); 
imvec = imvec - repmat(mean(imvec), n, 1);
% cov(imvec)
[V, D] = eig(cov(imvec));
sqrtD = diag(1./diag(sqrt(D)));

imvec = imvec * V * sqrtD;
cov(imvec)
%
% imvec = imvec * V;
% cov(imvec)
% imvec = imvec./repmat(sqrt(var(imvec)), imheight * imwidth, 1);
% cov(imvec)

%% gradient ascent
sigma = 0.5;

new = imvec;
tr = imvec(1:1000, :);

for j = 1:n
    for i = 1:20
        wt = mvnpdf(tr, new(j,:), sigma*ones(1, 5));
%         wt = exp((tr - repmat(new(j,:)*()./(2*sigma^2)); 
        
        wt = wt/sum(wt);
        new(j,:) = sum(tr.*repmat(wt,1, 5));
    end
end

% for i = 1:20 
%     wt = exp(dist2(tr, new)./(2*sigma^2)); 
%     wt = wt./repmat(sum(wt),1000, 1);
%     tmp = repmat(tr,1, 1, n); 
%     tmp = permute(tmp, [1,3,2]); 
%     new = sum(tmp.*repmat(wt, 1, 1, 5)); 
% end 
% 
A = sqrt(sum((imvec - new).^2, 2));
hist(A, 100);

%% k-means to determine clusters

[IDX, C] = kmeans(new, 12);  
new(:,:) = C(IDX,:);

% lab_old = zeros(1, n);
% k = 12;
% x = new(:,1:3);
% perm = randperm(n);
% m = x(perm(1:k),:);
% w = []; 
% for j = 1:3
%     
%     [mini, lab] = min(dist2(m,x));
%     
%     if lab_old == lab
%         break;
%     end
%     
%     sse = 0;
%     
%     for i = 1:k
%         m(i,:) = mean(x(lab == i,:));
%     end
%     lab_old = lab;
% 
%     % calculate sse
%     for i = 1:size(x,1)
%         sse = sse + (x(i,:) - m(lab(i), :))*(x(i,:) - m(lab(i), :))';
%     end
%     w = [w, sse];
% end
% 
% for i = 1:n
%     x(i,:) = m(lab(i),:);
% end
% 
% new = [x, new(:,4:5)]; 


%% draw image

new = new * inv(V * sqrtD); 
new = new + immean; 
new = int32(new); 

col_quant_img = zeros(imheight, imwidth, 3); 
for i = 1:n 
        col_quant_img(loc(i,1), loc(i,2),:) = new(i,1:3); 
end 

% col_quant_img = reshape(new, imheight, imwidth, 5); 

figure;
imagesc(uint8(col_quant_img(:,:,1:3)));





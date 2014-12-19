function q1b()

    rng (0);
    
    p=7;
    sigma=20;
    
    
    
    [origX, ~] = imread('../images/barbara256-part.png');
    origX = double(origX);
    X = origX + randn(size(origX))*sigma;
 
    row_lim=size(X,1);
    col_lim=size(X,2);

    row_lim=row_lim-p+1;
    col_lim=col_lim-p+1;

    new_P=zeros(p*p,row_lim*col_lim);

    count=1;
    for i=1:row_lim,
        for j=1:col_lim,
           window = X(i:i+p-1,j:j+p-1);
           temp=window(:);
           temp_X=X(max(i-15,1):min(i+21,size(X,1)),max(j-15,1):min(j+21,size(X,2)));
           new_P(:,count)= patchBased(temp_X,temp);
           count=count+1;
        end
    end
    
    count=1; 
    Y=zeros(size(X,1),size(X,2));
    count_Y=zeros(size(X,1),size(X,2));
    all_ones=ones(p,p);
    for i=1:row_lim,
        for j=1:col_lim,
           Y(i:i+p-1,j:j+p-1)=Y(i:i+p-1,j:j+p-1)+reshape(new_P(:,count),p,p);
           count_Y(i:i+p-1,j:j+p-1)=count_Y(i:i+p-1,j:j+p-1)+all_ones;
           count=count+1;
        end
    end
    
    Y=Y./count_Y;
    
%     imwrite(mat2gray(X),'../images/noisy_image.png');
%     imwrite(mat2gray(Y),'../images/denoised_patchBased_image.png');
    
%     imshow(mat2gray(X));
%     imshow(mat2gray(Y));


    
    save_image2(mat2gray(X),'../images/noisy_image.png',0);
    save_image2(mat2gray(Y),'../images/denoised_image_1b.png',0);
    
    
    'RMSE'
    sqrt(mean(mean((double(Y) - double(origX)).^2,2),1))
    
   
end


function [new_P_curr_patch]=patchBased(X,curr_patch)

    p=7;
    sigma=20;
    
    row_lim=size(X,1);
    col_lim=size(X,2);

    row_lim=row_lim-p+1;
    col_lim=col_lim-p+1;

    P=zeros(p*p,row_lim*col_lim);

    count=1;
    for i=1:row_lim,
        for j=1:col_lim,
           window = X(i:i+p-1,j:j+p-1);
           temp=window(:);
           P(:,count)= temp;
           count=count+1;
        end
    end
    
    temp=(P-curr_patch(:,ones(1,row_lim*col_lim)));
    temp=temp.^2;
    [~, order] = sort(sum(temp,1));
    P=P(:,order);
    P=P(:,1:min(200,size(P,2)));
    
    
    
    cov=P*P';
    [eig_vec,D]=eig(cov);  
    [~, order] = sort(diag(D),'descend');
    eig_vec=eig_vec(:,order);
    eig_vec=normc(eig_vec);

    coeff=eig_vec'*P;
    sq_eig_coeff=coeff.^2;
    
    sq_eig_coeff=sum(sq_eig_coeff,2);
    sq_eig_coeff=sq_eig_coeff/(size(P,2));
   
    sq_eig_coeff=sq_eig_coeff-sigma*sigma;
    sq_eig_coeff=sq_eig_coeff.*(sq_eig_coeff>0);
    sq_eig_coeff=(sigma*sigma)./sq_eig_coeff;
    sq_eig_coeff=sq_eig_coeff+1;
    new_coeff_curr_patch=(eig_vec'*curr_patch)./sq_eig_coeff;
    new_P_curr_patch=eig_vec*new_coeff_curr_patch;


end
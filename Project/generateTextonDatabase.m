function [textonDatabase] = generateTextonDatabase(k,Database,imageSet)

    addpath('./common/export_fig/')
    addpath('./common/')

    rng(0);
%     Database = makeLMfilters;
%     Database=preprocessFilter(Database);
%     
%     F = zeros(size(Database,3),size(Database,1)*size(Database,2));
%     for i=1:size(Database,3)
%         A = Database(:,:,i);
%         F(i,:) = A(:);
%     end
    
    
%     mapArr=['01';'02';'03','04','05','06','07','08','09','10','11','12','13']
%     mapArr(1,1)
    
    for i=1:size(imageSet,3)
        
        kTextons=generateTextons(Database,imageSet(:,:,i),k);
        
        if(i==1)
            textonDatabase=kTextons;
        else
            textonDatabase=[textonDatabase; kTextons];
        end
        
        
    end
    
%     pxTexton = zeros(size(F,2),size(textonDatabase,1));
%     
%     for i=1:size(textonDatabase,1)
%          pxTexton(:,i) = pinv(F)*textonDatabase(i,:)';
%         %pxTexton(:,i) = F\KTextons(i,:)';
% 
%         temp=vec2mat(pxTexton(:,i),49);
%         imshow(mat2gray(temp));
%         pause;
%         %size(F'\KTextons(i,:)')
%     end
end


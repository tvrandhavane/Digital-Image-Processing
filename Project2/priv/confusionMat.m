load('minIndex.mat');
confusion_mat = zeros(size(minIndex, 2), size(minIndex, 2));
for i = 1:size(minIndex, 2)
    confusion_mat(i, minIndex(i)) = 1;
end

percentage = confusion_mat - eye(size(minIndex, 2));
sum(abs(diag(percentage)))*100/112
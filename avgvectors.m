function res = avgvectors(mat,xlocs,compression)
%this function takes in a matrix of all images and pixel locations and compression and
%returns the average value of all starting vectors(to be used for kmeans)

res = zeros(size(xlocs,2),size(mat,3)*size(mat,4));
for i = 1:size(xlocs,2);
   x = xlocs{1,i};
   totalvector = zeros(1,size(mat,3)*size(mat,4));
   for k = 1:size(mat,4);
       for j = 1:size(x,1);
           x1 = x(j,1);
           x2 = x(j,2);
           for m = 1:size(mat,3);
              totalvector(1,size(mat,3)*(k - 1) + m) = totalvector(1,2*(k - 1) + m) + mat(ceil(x1/compression),ceil(x2/compression),m,k);
           end
           %totalvector(1,:) = totalvector(1,:) + mat(ceil(x2/compression)*imgcols + ...
               %ceil(x1/compression),:);
       end
   end
   disp(totalvector./ size(x,1));
   res(i,:) = totalvector(1,:) ./ size(x,1);
end
end

function y = getconfstats(xlocs, m, compression)
%gets the training data classes and the observed classes in y.
cur = 0;
for i = 1:size(xlocs,2);
    cur = cur + size(xlocs(1,i),1);
end
y = zeros(cur,2);
cur = 1;
for i = 1:size(xlocs,2);
   x = xlocs{1,i};
   for j = 1:size(x,1);
       x1 = x(j,1);
       x2 = x(j,2);
       y(cur, 1) = m(ceil(x2/compression),ceil(x1/compression));
       y(cur,2) = i;
       cur = cur + 1;
   end
end
end

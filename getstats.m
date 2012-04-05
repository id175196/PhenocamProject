function getstats(y,t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gets the precentages of where each pixel was placed kind of like in the
%confusion matrix, but I wrote this myself.
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
an = zeros(1,4);
cur = 1;
total = 0;
for i = 1:size(t,1);
    if(cur ~= y(i,1))
        cur = cur + 1;
        for j = 1:4
            disp(an(1,j)/total);
        end
        an = zeros(1,4);
        total = 0;
    end
    an(1,t(i,1)) = an(1,t(i,1)) + 1;
    total = total + 1;
end
for j = 1:4
    disp(an(1,j)/total);
end

end
function kresults = calckmeans(imstack, compression)

[s1,s2,s3,s4] = size(imstack);
kmat = zeros(s1/compression*s2/compression,s3*s4);
kindex = 1;
for a = 1:s4;
    for i = 1:s1/compression;
        for j = 1:s2/compression;
            for m = 0:compression - 1;
                for m2 = 1:compression - 1;
                    kmat((i-1)*(s2/compression) + j,kindex) = kmat((i-1)*(s2/compression) + j,kindex) + (imstack(compression*i - m,compression*j - m2,1,a));
                    kmat((i-1)*(s2/compression) + j,kindex + 1) = kmat((i-1)*(s2/compression) + j,kindex) + (imstack(compression*i - m,compression*j - m2,2,a));
                    kmat((i-1)*(s2/compression) + j,kindex + 2) = kmat((i-1)*(s2/compression) + j,kindex) + (imstack(compression*i - m,compression*j - m2,3,a));
                end
            end
            kmat((i-1)*(s2/compression) + j,kindex) = kmat((i-1)*(s2/compression) + j,kindex)/compression/compression;
            kmat((i-1)*(s2/compression) + j,kindex + 1) = kmat((i-1)*(s2/compression) + j,kindex + 1)/compression/compression;
            kmat((i-1)*(s2/compression) + j,kindex + 2) = kmat((i-1)*(s2/compression) + j,kindex + 2)/compression/compression;
        end
    end
    kindex = kindex + 3;
end
for i = 2:6;
    figure
    kresults = kmeans(kmat, i, 'EmptyAction', 'singleton', 'distance', 'city', 'replicate', 5);
    kresults = reshape(kresults,s2/compression,s1/compression);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    imagesc(kresults); colormap(gray); colormap('hot'); colorbar;
end
function superpixels_order6()

r = randi([1 255],1,1000);
g = randi([1 255],1,1000);
b = randi([1 255],1,1000);

segmentFileMat = load(strcat('order6/8068.mat'));
color_index=1;
superpixels = segmentFileMat.superpixels_o6;

superpixels_o7 = zeros(size(superpixels,1),size(superpixels,2));
segmentedImage = zeros(size(superpixels,1),size(superpixels,2),3);

fid = fopen('order6_clusters/clusters_o6_8068.txt');

while ~feof(fid)   
    tline = fgetl(fid);
    member_nodes= strsplit(tline,',');
    clusters{color_index,1} = member_nodes;
    color_index=color_index+1;
end

for i=1:size(superpixels_o7,1)
        for j=1:size(segmentedImage,2)
            color_index = getClusterColor(superpixels(i,j),clusters);
            if color_index~=0
                color_index_final = color_index;
            end
            superpixels_o7(i,j) = color_index_final;
            segmentedImage(i,j,1) = r(color_index_final);
            segmentedImage(i,j,2) = g(color_index_final);
            segmentedImage(i,j,3) = b(color_index_final);
        end   
end  
disp('calling imshow');
imshow(segmentedImage/256);
matFileName = '../order7_files/order7/8068.mat';
save(matFileName, 'superpixels_o7');

end

function D=getClusterColor(node,clusters)
D=0;
for i=1:size(clusters,1)
    member_nodes = clusters{i,1};
    for j=1:size(member_nodes,2)
        chk_for =str2num(member_nodes{1,j});
        if(node==chk_for)
            D=i;
            break;
        end
    end
end

end

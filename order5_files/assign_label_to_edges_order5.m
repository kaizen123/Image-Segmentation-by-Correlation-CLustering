function assign_label_to_edges_order5()

superpixelfiles = dir('order5/8068.mat');
nfiles = length(superpixelfiles);

for index=1:nfiles
    currentfilename = superpixelfiles(index).name;
    
    token = strtok(currentfilename, '.');
    FeaturesMat = load(strcat('order5_features/',currentfilename));

    labels = zeros(1,size(FeaturesMat.FeatureVector_temp,2));
    
    w = load('../retrained_model_v2/weight.mat');
    b = load('../retrained_model_v2/bias.mat');
    
    [~,~,~, scores] = vl_svmtrain(FeaturesMat.FeatureVector_temp, labels, 0, 'model', w.w, 'bias', b.b, 'solver', 'none') ;
   
    str2 =  strcat(token,'_spg.mat');
    pathTosuperpixelGraph = strcat('order5_graph/',str2);
    superpixelGraphMat = load(pathTosuperpixelGraph);
    [x y z] = find(superpixelGraphMat.Am);

    fid = fopen(strcat('extracted_edge_labels_order5/edge_labels_extracted_o5_',strcat(token,'.txt')),'a');    
    edgeLabels = zeros(1,size(x,1));
    for i = 1:size(x,1)
        
        if scores(1,i)>1.00
            edgeLabels(1,i) = 1;
        else
            edgeLabels(1,i) = -1;
        end   
        
        fprintf(fid, '%d, %d, %d\n', edgeLabels(1,i), x(i), y(i))
    end
    
    fclose(fid);

    str1 =  strcat(token,'.mat');
    matFileName = strcat('order5_edge_labels/',str1);
    save(matFileName, 'edgeLabels');

end

end
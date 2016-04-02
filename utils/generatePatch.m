function train_data = generatePatch(Path, Exp)
% This function genertaes training patches with labels from images in the
% training directory. Input to this function is the training directory with
% images, size of individual patches and number of patches per image.
% Currently only square patches are supported for training. For saving time,
% paches are storedin data directory to remove additional patch generation
% based on similar input data.


if exist(Path.train_patches,'file')
    load(Path.train_patches)
    return
end

train_images_path =  fullfile(Path.dataset, 'Train', 'Images');
train_label_path =  fullfile(Path.dataset, 'Train', ['Labels_'...
                    num2str(Exp.num_classes) 'Class']);
train_gt_path =  fullfile(Path.dataset, 'Train', ['GT_'...
                    num2str(Exp.num_classes) 'Class']);

images_name = dir([train_images_path '\*.png']);
labels_name = dir([train_label_path '\*.png']);
gt_name     = dir([train_gt_path '\*.png']);

patch_count = 0;

for i = 1 : numel(images_name)
    Im  = im2single(imread(fullfile(train_images_path, images_name(i).name)));
    gt = imread(fullfile(train_gt_path, gt_name(i).name));
    lb = imread(fullfile(train_label_path, labels_name(i).name));
    
    % Data Extraction Per Class
    for j = 1 : Exp.num_classes
        % Generate Patch Indices
        clear inds
        [inds(:,2), inds(:,1)] = find(gt(Exp.patch_size+1:end-Exp.patch_size,...
            Exp.patch_size+1:end-Exp.patch_size)==j-1);
        inds(:,1) = inds(:,1) + ceil(Exp.patch_size/2);
        inds(:,2) = inds(:,2) + ceil(Exp.patch_size/2);
        
        per_ind = randperm(size(inds,1));
        
        % Crop Image Patches and Labels
        for k = 1 : (Exp.data_dist(j)*Exp.patch_num)
            patch_count = patch_count + 1;
            rect = inds(per_ind(k),:);
            rect(3:4) = Exp.patch_size*[1,1];
            train_data(patch_count).im_patch = imcrop(Im, rect);
            train_data(patch_count).label_patch = imcrop(lb, rect);
            train_data(patch_count).label = j;
        end
    end
    clc
    disp(['Images ' num2str(i) ' out of ' ...
        num2str(numel(images_name)) ' completed..']);
end

save(Path.train_patches,'train_data');


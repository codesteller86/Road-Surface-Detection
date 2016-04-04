%--------------------------------------------------------------------------
%                CNN based Training for Road detection
% 
%  Ver = 1.0
% 
%  Date 02/04/2016
% 
%  Training Dataset : 200 Images from Kitti Road Dataset
%  Testing  Dataset : 089 Images from Kitti Road Dataset
%--------------------------------------------------------------------------


clc
clear 
close all

%% Setup Matconvnet and paths

run(fullfile(fileparts(mfilename('fullpath')), ...
  '..\', 'matconvnet-1.0-beta18', 'matlab', 'vl_setupnn.m')) ;

addpath 'utils'


%% Experiment Parameters
Exp.num_classes         = 2;
Exp.data_set            = 'Kitti_road';
Exp.patch_num           = 1500;
Exp.patch_size          = 10;
Exp.data_dist           = [0.4, 0.6];    % How much training data per class

%% Specify Diectories and Paths

Path.dataset = ['..\..\computer vision\dataset\' Exp.data_set '\'];
Path.experiment = ['Exp\' Exp.data_set '\Exp_' num2str(Exp.num_classes)...
                    '_' num2str(Exp.patch_size) '_' num2str(Exp.patch_num)];
Path.train_patches = ['Data\' Exp.data_set '\' num2str(Exp.num_classes)...
                    '_' num2str(Exp.patch_size) '_' num2str(Exp.patch_num)...
                    '.mat'];
                
if ~exist(Path.experiment,'dir')
    mkdir(Path.experiment);
end

if ~exist(['Data\' Exp.data_set],'dir')
    mkdir(['Data\' Exp.data_set]);
end

%% Generate Training Data
% Function genertaes training patches with labels
train_data = generatePatch(Path, Exp);

%% Training Parameters

train_param         = trainParamCNN();
train_param.expDir  = Path.experiment;


%% Arrage Training Data
% Actual Data
for i = 1 : length(train_data)
    imdb.images.data(:,:,:,i) = train_data(i).im_patch;
    imdb.images.labels(1,i)    = train_data(i).label;
end
sets = ones(1,length(train_data));
sets(randperm(length(train_data),0.2*length(train_data))) = 2;

imdb.images.set               = sets;

% Metadata
imdb.meta.sets                = {'train','val','test'};
imdb.meta.classes             = {'non-road','road'};


% Clear unused variables
clear sets train_data

%% Train Network
net = trainCNN(imdb,Path,train_param);

%% Before Exiting
% Remove all paths before exiting
rmpath 'utils'


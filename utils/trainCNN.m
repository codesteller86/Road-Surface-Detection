function [net, info] = trainCNN(imdb,Path,train_param)

addpath(Path.experiment)
% Get CNN Network 
net = pm_net();

[net, info] = cnn_train(net, imdb, @getBatch, ...
  'expDir', Path.experiment, ...
  train_param, ...
  'val', find(imdb.images.set == 2)) ;

rmpath(Path.experiment)
end

%   net.meta.trainOpts, ...

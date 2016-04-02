function [net, info] = trainCNN(imdb,Path,Exp,varargin)

addpath(Path.experiment)
% Get CNN Network 
net = pm_net();

[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 3)) ;

rmpath(Path.experiment)
end
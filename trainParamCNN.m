function train_param = trainParamCNN()
% Input all training parameters here

train_param.gpus                    = 1;
train_param.epoch                   = 100;
train_param.whitenData              = true ;
train_param.contrastNormalization   = true ;
opts.continue                       = true ;
opts.batchSize                      = 256 ;
opts.cudnn                          = true ;
opts.errorFunction                  = 'multiclass' ;


end
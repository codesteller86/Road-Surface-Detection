function train_param = trainParamCNN()
% Input all training parameters here

train_param.gpus                    = [];
train_param.numEpochs               = 100;
train_param.continue                = true ;
train_param.batchSize               = 256 ;
train_param.cudnn                   = true ;
train_param.errorFunction           = 'multiclass' ;


% train_param.whitenData              = true ;
% train_param.contrastNormalization   = true ;
end
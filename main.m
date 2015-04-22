function main

    delete('train*.mat');
    delete('test*.mat');

    addpath(genpath('parser'))
    addpath(genpath('animate'))
    addpath('quaternions')
    addpath('/Users/zhangchi8620/Data/Human-Skeleton/dataset_mfile');
    path = '/Users/zhangchi8620/Data/Human-Skeleton/HDM05/dataset/mfile/';    

    global nbStates numFrame selJoint refJoint selBone refBone DR
    nbStates = 10;    
    numFrame = 400;

%% load raw data -> save as video_XX.mat
%     loadData(path, 'train');
%     loadData(path, 'test');

% %% Batch mode
    disp ('Batch mode');  
    % train data
    if (exist('trainCombSubject.mat') ~= 0)
        load('trainCombSubject.mat');
    else
        trainData = assemble_HDM05('train');
        save('trainCombSubject.mat', 'trainData');
    end    
    file = encode(trainData,'train'); 
    addLabel(file, 'train');
    
     %test data
    if (exist('testCombSubject.mat') ~= 0)
        load('testCombSubject.mat');
    else
        testData = assemble_HDM05('test');
        save('testCombSubject.mat', 'testData');
    end    
    file = encode(testData,'test'); 
    addLabel(file, 'test');   
    
% %% Indiv mode
%     disp('Indiv mode');
%     Data = [];
%     % train data    
%     load('video_train.mat');    
%     numVideo = size(video,2);
%     numDim = size(video(1).data, 1);
%     for i = 1 : size(video,2)
%         trainData(i).action = video(i).action;
%         % align by simply resize to numFrame
%         trainData(i).data = resizem(video(i).data, [numDim,numFrame]);
%     end
%     file = encode(trainData,'train'); 
%     addLabel(file, 'train');
%     
%     % test data    
%     load('video_test.mat');    
%     numVideo = size(video,2);
%     numDim = size(video(1).data, 1);
%     for i = 1 : size(video,2)
%         testData(i).action = video(i).action;
%         % align by simply resize to numFrame        
%         testData(i).data = resizem(video(i).data, [numDim,numFrame]);
%     end
%     file = encode(testData,'test'); 
%     addLabel(file, 'test');
end
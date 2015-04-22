%assemble train data
function trainData = assemble_HDM05(mode)
    disp('Assemble ...');
    numAction = 11;
    % load vidoe*.mat
    if strcmp(mode, 'train')
        load('video_train.mat');    
        subject = {'bd', 'bk', 'dg'};        
    else
        load('video_test.mat');
        subject = {'mm', 'tr'};        
    end
    
    action = extractfield(video, 'action');
    n=1;
    for i = 1 : numAction
        [first, last] = getIdx(action, i);
        v_act=video(first:last);
        sub = extractfield(v_act, 'subject');
        for j = 1 : size(subject,2)
            [first, last]=getIdx(sub, subject(j));
            v_sub=v_act(first:last);
            mid = floor(size(v_sub,2)/2);
            v1 = v_sub(1:mid);
            v2 = v_sub(mid+1:end);
            %combine all videos from one subject
%             trainData(n).action = i;            
%             trainData(n).data= align_2D(v_sub);
%             n=n+1;            
            % devide the one-subject videos to two subsets
            trainData(n).action=i;
            trainData(n).data = align_2D(v1);            
            n=n+1;
            trainData(n).action=i;
            trainData(n).data = align_2D(v2);            
            n=n+1;            
        end
    end
end
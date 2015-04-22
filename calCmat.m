function calCmat()
    cmat = zeros(11, 11);
    numVideo = 8;
    
    x = textread('/Users/zhangchi8620/Codes/libsvm-3.18/tools/data_paper/hdm05/indiv/output.txt');
    predData = reshape(x, [99, numVideo]);
    y = textread('/Users/zhangchi8620/Codes/libsvm-3.18/tools/data_paper/hdm05/indiv/groundTrue.txt');
    
    trueData = repmat(y, [1 numVideo])

        
    for i = 1 : numVideo
        cmat = cmat + eachVideo(predData(:,i), trueData);
    end
    cmat = cmat / numVideo;
    save('cmat.mat', 'cmat');
        drawTestConfMat();

end

function cmat = eachVideo(predData, trueData)
    numAct = max(trueData);
    count = 1;
    for i = 1 : size(trueData,1)-1 
        if trueData(i) ~= trueData(i+1)
            endIdx(count) = i;
            count = count+1;
        end
        
    end
    
    startIdx = endIdx + 1;
    startIdx = [1, startIdx];
    endIdx = [endIdx, size(trueData,1)];
    startIdx, endIdx

    for i = 1 : numAct
        x = predData(startIdx(i):endIdx(i));
        label = trueData(startIdx(i));
        for act = 1 : numAct
            cmat(label,act) = length(find(x==act)) / length(x);
        end
    end
end


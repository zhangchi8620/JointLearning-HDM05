function result = align_2D(videos)
    global numFrame 
    result = [];
    ref = videos(1).data;
    numJoint = size(ref, 1);    
    ref = imresize(ref, [numJoint numFrame]);
    
    for e = 2 : size(videos, 2)
        new = [];
        v = videos(e).data;
        for j = 1 : numJoint
                dim = ref(j,:);
                tmp = [v(j,:)];
                [w, n] = DTW(tmp', dim');
%                         figure;
%                         plot(n);hold on;plot(dim, 'r'); plot(tmp, 'g');
%                         new =[new; dim];
                new = [new; n'];            
        end
        result = [result, new];        
    end
    
    result=[ref, result];
end
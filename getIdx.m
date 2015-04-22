function [first, last] = getIdx(array, x)
    if isnumeric(x)
        k = find(array==x);
        first = k(1);
        last = k(end);
    elseif iscell(array)
        newarray=char(array);
        k=find(ismember(newarray, x));
        first = k(1);
        last = k(end);
    else
        disp 'wrong data strcuture';
        return;
    end
end
function [er2, bad2,simi_matrix,test_net] = cnnsimilarity(net, x, y,simi_test_num)
    %  feedforward
    
    net = cnnff(net, x);
    test_net=zeros(16,20000*16);
    test_net=net.o;
    [~, h] = max(net.o);
    [~, a] = max(y);
    bad2 = find(h ~= a);
    er2 = numel(bad2) / size(y, 2);
    simi_matrix=zeros(16);
    for i=1:16
        simi_matrix(:,i)=sum(net.o(:,1+simi_test_num*(i-1):simi_test_num*i),2);
    end
end

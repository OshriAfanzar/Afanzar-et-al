function [vidFrameK] = ProcessFrame(vidFrame)

    vidFrameInv = (vidFrame);
    
    vidFrame=imcomplement(vidFrame);       
    
    Q = (sort(vidFrameInv(:)));
    [~, Idx] = min(Q-linspace(min(Q),max(Q),length(Q))');
    TreshInv =  mean(Q(Idx));
    vidFrameInv = (vidFrameInv-TreshInv)>0;
    
    
    Q = sort((vidFrame(:)));
    [~, Idx] = min(Q-linspace(min(Q),max(Q),length(Q))');
    Tresh =  mean(Q(Idx));
    vidFrameK = (vidFrame-Tresh)>0 & ~vidFrameInv;

    vidFrameK=conv2(double(vidFrameK),ones(3,3),'same')>3;
    


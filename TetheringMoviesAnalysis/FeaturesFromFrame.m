function [Features,MajAx,MinAx,XCor,YCor] = FeaturesFromFrame(vidFrame,AllImgFilteredReduced)   



    [vidFrameK] = ProcessFrame(vidFrame);
    
    CC = bwconncomp(vidFrameK);
    Numel = cellfun(@numel,CC.PixelIdxList);
    Numel = find(Numel>10);
    Features = NaN(1,max(AllImgFilteredReduced(:)));
    MajAx = NaN(1,max(AllImgFilteredReduced(:)));
    MinAx = NaN(1,max(AllImgFilteredReduced(:)));
    XCor = NaN(1,max(AllImgFilteredReduced(:)));
    YCor = NaN(1,max(AllImgFilteredReduced(:)));
    RegProp = regionprops(CC,'Orientation','MajorAxisLength','MinorAxisLength','Centroid');
    for nn = 1:length(Numel)
        Loc = unique(AllImgFilteredReduced(CC.PixelIdxList{Numel(nn)}));
        Loc(Loc==0) = [];
        if ~isempty(Loc)
        Features(1,Loc(1)) = RegProp(Numel(nn)).Orientation;
        MajAx(1,Loc(1)) = RegProp(Numel(nn)).MajorAxisLength;
        MinAx(1,Loc(1)) = RegProp(Numel(nn)).MinorAxisLength;
        XCor(1,Loc(1)) = RegProp(Numel(nn)).Centroid(1);
        YCor(1,Loc(1)) = RegProp(Numel(nn)).Centroid(2);
        end
    end
    %%
%     imagesc(vidFrame)
%     hold on
%     s=RegProp;
%     t = linspace(0,2*pi,50);
% for k = 1:length(s)
%     a = s(k).MajorAxisLength/2;
%     b = s(k).MinorAxisLength/2;
%     Xc = s(k).Centroid(1);
%     Yc = s(k).Centroid(2);
%     phi = deg2rad(-s(k).Orientation);
%     x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
%     y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
%     plot(x,y,'r','Linewidth',1)
% end
% hold off
%     
end
    
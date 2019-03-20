function [ZZ,AllImgS,MeanImage] = StackImages(obj)

AllImg = zeros(size(read(obj,1)));
AllImg=AllImg(:,:,1);
MeanImage = AllImg;
FrameRate = round(obj.FrameRate);

for n = 1:FrameRate:(obj.NumberOfFrames)
 
    vidFrame = (double(read(obj,n)));

    vidFrame = vidFrame(:,:,1);
   [vidFrameK] = ProcessFrame(vidFrame);
    
    AllImg = AllImg + vidFrameK;
end
MeanImage = MeanImage./length(1:FrameRate:(obj.NumberOfFrames));
AllImg = AllImg./max(AllImg(:));
AllImgS = AllImg;

AllImgFilteredReduced = conv2(double(AllImg>0.95),ones(3,3),'same')>0;


ZZ = zeros(size(AllImgFilteredReduced));
CC = bwconncomp(AllImgFilteredReduced);
Numel = cellfun(@numel,CC.PixelIdxList);
NML = find(Numel>9);

for nn = 1:length(NML)
    ZZ(CC.PixelIdxList{NML(nn)}) = 1;
end
ZZ = bwlabel(ZZ);
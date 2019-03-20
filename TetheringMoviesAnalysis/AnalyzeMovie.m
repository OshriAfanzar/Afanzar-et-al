function [] = AnalyzeMovie(Directory,File,TimeCreated)

FileShort = File(1:end-4);
FileShort(FileShort=='.') = '_';
VideoFile = [Directory '\' File];

obj = VideoReader(VideoFile);

disp([VideoFile ' Start'])
tic
[AllImg,AllImgS,MeanImage] = StackImages(obj);
%%
Angle = zeros(obj.NumberOfFrames,max(AllImg(:)));
MajAx = zeros(obj.NumberOfFrames,max(AllImg(:)));
MinAx = zeros(obj.NumberOfFrames,max(AllImg(:)));
XCor = zeros(obj.NumberOfFrames,max(AllImg(:)));
YCor = zeros(obj.NumberOfFrames,max(AllImg(:)));
% parfor_progress(obj.NumberOfFrames); 
tic
parfor n = 1:1:(obj.NumberOfFrames) %%parfor
    Temp = read(obj,n);
    Temp = Temp(:,:,1);
    [Angle(n,:),MajAx(n,:),MinAx(n,:),XCor(n,:),YCor(n,:)]=FeaturesFromFrame(double(Temp),AllImg);
end
disp([VideoFile ' Done'])
toc
MovieLength = obj.NumberOfFrames;
FrameRate = obj.FrameRate;
DateString = TimeCreated;
formatIn = 'dd-mmm-yyyy HH:MM:SS';

TimeTaken = datevec(DateString,formatIn);
save([Directory '\' FileShort '_AnalysisData'],'AllImg','Angle','MovieLength','MajAx','MinAx','XCor','YCor','FrameRate','TimeTaken','AllImgS','MeanImage')


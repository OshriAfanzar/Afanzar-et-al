function [OK] = AnalyzeAndCropMovie(Directory,File,TimeCreated,Size,Compress)

%%% Initialize variables %%%%%%
OK=0;                         %
VideoFile = [Directory File]; %
Name = VideoFile(1:end-4);    %
Name(Name == '.') = '_';      %
MinNaN = 0.9;                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Analyze the movie, if it wasn't anayzed before %%
if ~exist([Name '_AnalysisData.mat'])              %%
    AnalyzeMovie(Directory,File,TimeCreated)       %% 
end                                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Get the direction of rotation of each element in the movie %%
load([Name '_AnalysisData'])                                   %%
GetRotation(SubDir,File)                                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% From here and on - If compress variable is 1, crop regions of rotating cells and stitch them to a new movie
if ~exist('FrameRate') || Compress==0; return; end

if (MovieLength./FrameRate)>60
    if Size<150  %% If movie is long and is < 150 mb, the size reduced by cropping is not amazing
        return
    else
        MinNaN = 0.3;
    end
end

% load([VideoFile(1:end-4) '_AnalysisDataB'])
obj = VideoReader(VideoFile);


ISOK = [];
TMaj = [];

NonDisruptedMax = sum(~isnan(MajAx))./length(MajAx(:,1));

Tresh=2;

for n = 1:length(Angle(1,:))
    Temp = histcounts(Angle(:,n),-90:10:90);
    ISOK(n) = ((sum(Temp>Tresh)./length(Temp))==1) & (sum(~isnan(MajAx(:,n)))./length(MajAx(:,n)))>(min([MinNaN NonDisruptedMax]))...
        &  (median(MajAx(~isnan(MajAx(:,n)),n))./median(MinAx(~isnan(MinAx(:,n)),n)) > 1.5);%... & nanmedian(MajAx)<50
    %          & (std(MajAx(~isnan(MajAx(:,n)),n))<median(MajAx(~isnan(MajAx(:,n)),n))./10) ...
    %         & (median(MajAx(~isnan(MajAx(:,n)),n))<2.*median(MajAx(~isnan(MajAx)))) & (median(MajAx(~isnan(MajAx(:,n)),n))>5);
    %
    TMaj(n) = median(MajAx(~isnan(MajAx(:,n)),n));
    YCorT(n) = median(YCor(~isnan(YCor(:,n)),n));
    XCorT(n) = median(XCor(~isnan(XCor(:,n)),n));
end

XCor = XCorT;
YCor = YCorT;
FindOK = find(ISOK);
TMaj = TMaj(FindOK);
[a b] = sort(TMaj);
TMaj = a;
FindOK = FindOK(b);
TMaj = ceil(TMaj);
BufferArray = uint8(zeros(1,1));
YCor = round(YCor);
XCor = round(XCor);
Count = 1;
CountVer = 1;

ImgLocation = {};

if sum(ISOK) == 0
    return
end
OriginalLocation = {};AllImgS = zeros(size(AllImg));
for n = 1:1:(obj.NumberOfFrames)
    %     disp(num2str(n./obj.NumberOfFrames))
    Temp = read(obj,n);
    Temp2=Temp;
    AllImgS = AllImgS+double(Temp(:,:,1));
    CountX = 0;
    LMax = 0;
    for m = 1:length(FindOK)
        XTemp = XCor(FindOK(m))-TMaj(m):XCor(FindOK(m))+TMaj(m);
        YTemp = YCor(FindOK(m))-TMaj(m):YCor(FindOK(m))+TMaj(m);
        XTemp(XTemp>length(AllImg(1,:))) = [];
        XTemp(XTemp<1) = [];
        YTemp(YTemp>length(AllImg(:,1))) = [];
        YTemp(YTemp<1) = [];
        TempImg = Temp(YTemp,XTemp,1);
        Temp2(YTemp,XTemp,3) = 1;
        LMax = max([LMax length(TempImg(:,1))]);
        BufferArray(CountVer:CountVer+length(TempImg(:,1))-1,Count:Count+length(TempImg(1,:))-1) = TempImg;
        ImgLocation{m,1} = CountVer:CountVer+length(TempImg(:,1))-1; ImgLocation{m,2} =Count:Count+length(TempImg(1,:))-1;
        OriginalLocation{m,1} = YTemp; OriginalLocation{m,2} =XTemp;
        
        Count = Count+length(TempImg(1,:))+1;
        CountX = CountX+1;
        if CountX>=ceil(sqrt(length(FindOK)))
            
            CountX = 1;
            CountVer=CountVer+LMax+1;
            Count = 1;
            LMax = 0;
        end
        
        
    end
    if n==1
        if length(BufferArray(:))>length(AllImg(:))./2
            return
        else
            v = VideoWriter([VideoFile(1:end-4) 'Compressed']);
            v.FrameRate = FrameRate;
            
            open(v)
        end
    end
    
    writeVideo(v,BufferArray)
    % toc
    %         imshow(Temp2);drawnow %hold on; plot(XCor(FindOK(:)),YCor(FindOK(:)),'.r','markersize',10)
    %         toc
    Count = 1;
    CountVer = 1;
end

save([VideoFile(1:end-4) '_AnalysisData'],'FindOK','ImgLocation','OriginalLocation','Angle','MajAx','MinAx','TimeTaken','MovieLength','AllImg','YCor','XCor','FrameRate','AllImgS')
close(v)
OK = 1;

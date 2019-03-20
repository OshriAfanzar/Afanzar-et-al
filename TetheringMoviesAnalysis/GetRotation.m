function [] = GetRotation(File)
load([File])
RestrictEvent = [];
Count = 0;
for q = 1:length(MajAx(1,:))
    Count = Count+1;
    Temp = MajAx(:,q);
    Temp(isnan(Temp)) = [];
    Temp2 = MinAx(:,q);
    Temp2(isnan(Temp2)) = [];
    
    

    RestrictEvent(Count,1) = median(Temp)>10 &  median(Temp)./median(Temp2) > 1.5;
end
if sum(RestrictEvent) == 0
    Included=0;CWBias=NaN;Angle=NaN;MajAx=NaN;MinAx=NaN;XCor=NaN;YCor=NaN;
    return
end
Included = (sum(isnan(Angle))./length(Angle(:,1)))<0.3 & RestrictEvent';
Angle(:,~Included) = [];
MajAx(:,~Included) = [];
MinAx(:,~Included) = [];
XCor(:,~Included) = [];
YCor(:,~Included) = [];
Angle = Angle.*(pi/180);

CWBias = false(zeros(size(Angle)));

for nn = 2:length(Angle(:,1))
    for n = 1:length(Angle(1,:))
        
        [X0 Y0] = pol2cart(Angle(nn-1,n),1);
        [X1 Y1] = pol2cart(Angle(nn,n),1);
        [X2 Y2] = pol2cart(pi+Angle(nn,n),1);
        
%         plot(X0,Y0,'.r');hold on;plot([X0 X1],[Y0 Y1],'-b');plot([X0 X2],[Y0 Y2],'-c')
        
        Dist1 = sqrt((X0-X1)^2 + (Y0-Y1)^2);
        Dist2 = sqrt((X0-X2)^2 + (Y0-Y2)^2);
        
        Dist = Dist1*(Dist1<=Dist2) + Dist2*(Dist2<Dist1);
        X = X1*(Dist1<=Dist2) + X2*(Dist2<Dist1);
        Y = Y1*(Dist1<=Dist2) + Y2*(Dist2<Dist1);
        

        
        CWBias(nn,n) =  ((X0*Y) - (X*Y0))>=0;
        
        [Angle(nn,n), rhoT] = cart2pol(X,Y);
        
        
        
    end
    
end


%%
Angle = Angle.*(180./pi);
Included = [];

ISOK = [];
TMaj = [];
for n = 1:length(Angle(1,:))
    Temp = histcounts(Angle(:,n),-180:10:180);
    Included(n) = (sum(Temp>(sum(Temp)./100))./length(Temp)==1) & (std(MajAx(~isnan(MajAx(:,n)),n))<1)  &  (median(MajAx(~isnan(MajAx(:,n)),n))./median(MinAx(~isnan(MinAx(:,n)),n)) > 1.5);
    %& (median(MajAx(~isnan(MajAx(:,n)),n))<2.*median(MajAx(~isnan(MajAx)))) & (median(MajAx(~isnan(MajAx(:,n)),n))>5)
    TMaj(n) = median(MajAx(~isnan(MajAx(:,n)),n));
end

for n = 1:length(XCor(1,:))
    
        XCorT(n) = mean(XCor(~isnan(XCor(:,n)),n));
        YCorT(n) = mean(YCor(~isnan(YCor(:,n)),n));
end
XCor = XCorT;
YCor = YCorT;
% Included = find(Included == 1);
% CWBias = single(CWBias);


CWBias(:,~Included) = [];
Angle(:,~Included) = [];
MajAx(:,~Included) = [];
MinAx(:,~Included) = [];
XCor(:,~Included) = [];
YCor(:,~Included) = [];

LAngle = length(Angle(1,:));

        save([File(1:end-4) 'B.mat'],'CWBias','Angle','Included','MajAx','MinAx','XCor','YCor','AllImg','File','SubDir','FrameRate','TimeTaken');


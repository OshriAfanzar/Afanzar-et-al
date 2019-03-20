function [List] = LookForAviOrRetreat(Directory,List,MainDir,Compress)

DirDirectory = dir(Directory);

for n = 1:length(DirDirectory)
    if (strcmp(DirDirectory(n).name , '.') == 1) || (strcmp(DirDirectory(n).name , '..') == 1)
        continue
    end
    if length(DirDirectory(n).name)>=4 %&& MainDir~=1
        if (strcmp(DirDirectory(n).name(end-3:end),'.avi') == 1)
            disp([Directory DirDirectory(n).name])
            List{end+1,1} = [Directory '\'];
            List{end,2} = [DirDirectory(n).name];
            if isempty(regexp(DirDirectory(n).name,'Compressed'))
                Size = DirDirectory(n).bytes./10^6;
                try
                OK = AnalyzeAndCropMovie([Directory '\'],[ DirDirectory(n).name],DirDirectory(n).date,Size,Compress);
                catch
                    List{end,2} = [List{end,2} 'ERROR IN ANALYSIS'];
                end
%                 if OK == 1 && Compress == 1
%                     delete([Directory '\' DirDirectory(n).name])
%                 end
            end
        end
    end
    
    if DirDirectory(n).isdir == 1
        [List] = LookForAviOrRetreat([Directory '\' DirDirectory(n).name '\'],List,0,Compress);
    end
end


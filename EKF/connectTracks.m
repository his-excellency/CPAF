load('Cut_vid_tracks.mat');

trackMatxp = trackMatx(:);
trackMatxp = trackMatxp';

[m,n] = size(trackMatxp);
[m1,n1] = size(trackMatxp{1});
ct = 0;

while(~(isempty(trackMatxp)))
    
    while(~(isempty(trackMatxp{1})))
        
        if(size(trackMatxp,2)==1)
            ct = ct+1;
            onetrack = trackMatxp{1}(:,:);
            theTracks{ct} = onetrack;
            clear onetrack;
            break;
        end
        
        if(~(isempty(trackMatxp{2})))
            D = pdist2(trackMatxp{1}(1,:),trackMatxp{2});
            [v,idx]=min(D);
        end
        onetrack(1,:) = trackMatxp{1}(1,:);
        %There was no need for this For loop
        for i=2:1:size(trackMatxp,2)-1
            if(v>30 ||  isempty(trackMatxp{i}) || trackMatxp{i}(idx,1)>=760)
                break;
            end
            onetrack(i,:) = trackMatxp{i}(idx,:);
            if(~(isempty(trackMatxp{i+1})))
                D = pdist2(trackMatxp{i}(idx,:),trackMatxp{i+1});
                previdx = idx;
                [v,idx]=min(D);
                if(previdx==1)
                    trackMatxp{i} = trackMatxp{i}(previdx+1:end,:);
                elseif(previdx==size(trackMatxp{i},1))
                    trackMatxp{i} = trackMatxp{i}(1:previdx-1,:);
                else
                    trackMatxp{i} = trackMatxp{i}([1:previdx-1,previdx+1:end],:);
                end
            else
                if(previdx==1)
                    trackMatxp{i} = trackMatxp{i}(idx+1:end,:);
                elseif(previdx==size(trackMatxp{i},1))
                    trackMatxp{i} = trackMatxp{i}(1:idx-1,:);
                else
                    trackMatxp{i} = trackMatxp{i}([1:idx-1,idx+1:end],:);
                end
            end
        end
        ct = ct+1;
        if(size(trackMatxp{1},1)>1)
            trackMatxp{1} = trackMatxp{1}(2:end,:);
        else
            trackMatxp{1} = [];
        end
        theTracks{ct} = onetrack;
        objframestart(ct) = 1+ (size(trackMatx,2) - size(trackMatxp,2));
        clear onetrack;
    end

    if(size(trackMatxp,2)>1)
        trackMatxp = trackMatxp(2:size(trackMatxp,2));
    else
        trackMatxp = [];
    end

end

ctn=0;
for k=1:1:size(theTracks,2)
    if(size(theTracks{k},1)>15)
        ctn=ctn+1;
        newTrak{ctn} = theTracks{k};
        reqObjFrm(ctn) = objframestart(k);   
    end
end
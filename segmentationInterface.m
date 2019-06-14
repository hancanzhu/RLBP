function segmentationInterface()
% RLBP segmentation interface.
    addpath('../tools/niiReader');
    parfor i=1:1
            SegmentationSubject(i);
    end
end

function SegmentationSubject(img_i)
    for outi=1:2
        % Left Hippocampus
        if outi==1
            out_dir='../data/Left/result/';
            Tar_Dir='../data/Left/target/';
            pre_in_dir='../data/Left/storeRegistration/';
        end
        
        % Right Hippocampus
        if outi==2
            out_dir='../data/Right/result/';
            Tar_Dir='../data/Right/target/';
            pre_in_dir='../data/Right/storeRegistration/';
        end
        
        sub_sel=20; % the number of selected atlases.
        str_dir=strcat(pre_in_dir,int2str(img_i),'/'); % the location of registered atlases.
        %% save atlas names in the following variables 
        AtlasImglist=[]; AtlasMsklist=[];
        for i=1:sub_sel
            t_str=strcat(str_dir,'wimg',int2str(i),'.nii');
            AtlasImglist{end+1}=t_str;                       
            t_str=strcat(str_dir,'wmask',int2str(i),'.nii');
            AtlasMsklist{end+1}=t_str; 
        end
        %%
        outfn=strcat(out_dir,'RLBP',int2str(img_i));
        targetFn=strcat(Tar_Dir,'TargetImg',int2str(img_i),'.nii');
        rs=1; rp=4; L=1000; C=4^(-4);
        multiatlasbasedlabeling(AtlasImglist,AtlasMsklist,targetFn,outfn,'RLBP',rs,rp,L,C);

    end
end
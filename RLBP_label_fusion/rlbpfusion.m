function rlbpImg=rlbpfusion(atlasImages,atlasLabels,targetImage,searchRadius,patchRadius,...
    updateRegion,mvResult,NumberofHiddenNeurons,C)
% rlbpfusion performs segmentation using local linear regression with random
% coding local binary pattern features method.
%   rlbpImg=rlbpfusion(atlasImages,atlasLabels,targetImage,searchRadius,patchRadius,...
%   updateRegion,mvResult,NumberofHiddenNeurons,C) estimate the segmentation of targetImage using
%   local linear regression with random coding local binary pattern features method. 
%   We only compute updateRegion of mvResult which are initialized by majority voting. 

rlbpImg=mvResult;
nSplit=int32(prod(size(targetImage))/prod([80,80,80]))+1;
stepRange=int32(size(targetImage,1)/nSplit);
[sizeIx,sizeIy,sizeIz]=size(targetImage);
NumofMaxDimension=max(max(sizeIx,sizeIy),sizeIz); 

for iSplit=1:nSplit
    %% split the update region for big data
    updateRegionSplit=zeros(size(updateRegion));
    if iSplit~=nSplit
        range=((iSplit-1)*stepRange+1):iSplit*stepRange;
    else
        range=((iSplit-1)*stepRange+1):size(targetImage,1);
    end
    updateRegionSplit(range,:,:)=updateRegion(range,:,:);  
    [targetPatches,atlasPatches]=patchgeneration(atlasImages,atlasLabels,...
        targetImage,updateRegionSplit,searchRadius,NumofMaxDimension,patchRadius);

    %% segment the update region
    [sx,sy,sz] = ind2sub(size(updateRegionSplit),find(updateRegionSplit == 1));
    for si=1:size(sx,1)
        if mod(si,500)==0
            disp(num2str(si/size(sx,1)));
        end
        nx=sx(si);ny=sy(si);nz=sz(si);
        targetIndex=NumofMaxDimension^2*nx+NumofMaxDimension*ny+nz;
        targetPatch=targetPatches{targetIndex};
        [atlasPatch,atlasLab]=getatlasinfo(atlasPatches,nx,ny,nz,searchRadius,NumofMaxDimension);          
        % compute the label of (nx,ny,nz) with the RLBP method
        rlbpImg(nx,ny,nz)=internalfusion(targetPatch,atlasPatch,atlasLab,NumberofHiddenNeurons, C);
    end
end
end

function lab=internalfusion(targetPatch,atlasPatch,atlasLab,NumberofHiddenNeurons, C)
%internalelm perform segmentation at one positon.
targetPatch=double(targetPatch);
atlasPatch=double(atlasPatch);
atlasLab=double(atlasLab);
unique_label=unique(atlasLab);
if length(unique_label)==1
    lab = atlasLab(1);
    return;
end

%% local linear regression with random coding local binary pattern features for labeling.
[atlasFea,targetFea]=randomLBP_features(atlasPatch,targetPatch, NumberofHiddenNeurons); % RLBP feature extraction
atlasLab=atlasLab'; atlasFea=atlasFea';

% compute the coeffients beta
NumberofFeatures=size(atlasFea,2);
beta=(atlasFea'*atlasFea+eye(NumberofFeatures)/C)\(atlasFea'*atlasLab);

% compute the target label
TY = targetFea'*beta;
if abs(TY-unique_label(1))<abs(TY-unique_label(2))
    lab=unique_label(1);
else
    lab=unique_label(2);
end
end

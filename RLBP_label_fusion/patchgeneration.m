function [targetPatch,atlasPatches]=patchgeneration(atlasImages,atlasLabels,...
    targetImage,updateRegion,searchRadius,NumofMaxDimension,patchRadius)
% patchgeneration geneartes patches from atlas and target image for segmentation
%   [targetFeatures,AtlasFeatures]=patchgeneration(atlasImages,atlasLabels,targetImage,
%   updateRegionSplit,searchRadius,patchRadius) generates patches from
%   targetImage to form targetPatches, generate patches from atlasImages and 
%   atlasLabels to form  AtlasPatches.

genRadius=searchRadius*2+1;
di=ones(genRadius,genRadius,genRadius);
genRegion=imfilter(single(updateRegion),di,'same');
genRegion=(genRegion>0);
[sx,sy,sz] = ind2sub(size(genRegion),find(genRegion == 1));
targetPatch=[];atlasPatches=[];
targetPatch{NumofMaxDimension^3}=0;
atlasPatches{NumofMaxDimension^3}=0;
disp('start to generate patches');
for si=1:size(sx,1)
    if mod(si,500)==1
           disp(num2str(si/size(sx,1)));
    end
    nx=sx(si);ny=sy(si);nz=sz(si);
    loadIndex=NumofMaxDimension^2*nx+NumofMaxDimension*ny+nz;
    targetPatch{loadIndex}=getpatch(targetImage,nx,ny,nz,patchRadius);
    atlasPatches{loadIndex}=getatlasPatches(atlasImages,atlasLabels,...
                                                  nx,ny,nz,patchRadius);
end
end
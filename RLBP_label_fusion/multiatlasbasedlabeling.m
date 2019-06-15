function multiatlasbasedlabeling(atlasImageFileList, atlasLabelFileList, targetImageName,targetLabelName,varargin)
% multiatlasbasedlabeling estimate label of a 3d target image using multiple
% warped atalses.
%   multiatlasbasedlabeling(atlasImageFileList, atlasLabelFileList,
%   targetImageName,targetLabelName) estimate the segmentation of
%   targetImageName using atlases with list of atlas image names
%   stored in atlasImageFileList and list of atlas label names stored in
%   atlasLabelFileList.  
%   The segment result is saved to targetLabelName.
%
%   -Majority Voting(MV):
%   multiatlasbasedlabeling(atlasImageFileList, atlasLabelFileList,
%   targetImageName,targetLabelName,'MV') 
%
%   -RLBP
%   multiatlasbasedlabeling(atlasImageFileList, atlasLabelFileList,
%   targetImageName,targetLabelName,'RLBP',searchRadius,patchRadius,NumofHiddenNotes,C).
%
% A third-party software is used, The user need to download and 
% set the environment properly themself:
% Tools for NIfTI and ANALYZE image for image IO
%   <http://www.mathworks.cn/matlabcentral/fileexchange/8797-tools-for-nifti
%   -and-analyze-image/content/view_nii.m>

% paramters input
if nargin<4
    error('Minimal requirement parameter numbers are four.');
end

if length(atlasImageFileList)~=length(atlasLabelFileList)
    error('Number of atlas images and number of atlas labels is not matching.');
end

if nargin>=5
    methodType=varargin{1};
end

if nargin>=6
    searchRadius=varargin{2};
end

if nargin>=7
    patchRadius=varargin{3};
end

if  nargin>=8
     NumberofHiddenNeurons=varargin{4};
end

if  nargin>=9
     C=varargin{5};
end     

%read in atlas and target images
atlasImages=[]; atlasLabels=[]; 
nAtlas=length(atlasImageFileList);

for iAi=1:nAtlas
    ni=load_untouch_nii(atlasImageFileList{iAi});
    atlasImages(:,:,:,iAi)=double(ni.img);
    ni=load_untouch_nii(atlasLabelFileList{iAi});
    isBinary=sum(single(int32(ni.img(:)))-ni.img(:))~=0;
    if isBinary
        maxLab=max(ni.img(:));
        normImg=ni.img/maxLab;
        ni.img=maxLab*single(int32(normImg));
    end
    atlasLabels(:,:,:,iAi)=int32(ni.img);
end
ni=load_untouch_nii(targetImageName);
targetImage=double(ni.img);

%Inital segmentation with majority voting
[mvResult,timeMax]=mode(atlasLabels,4);
%remove one atlas,update results
[mvResult,timeMax,atlasLabels,atlasImages]=removeone(atlasLabels,atlasImages,mvResult);
nAtlas=size(atlasLabels,4);
%
mvReg=timeMax~=nAtlas;
updateRegion=mvReg>0;

switch methodType
   case 'MV'
      saveimg(mvResult,targetLabelName,ni);
      disp('Labeling with Majority Voting');
    case 'RLBP'
      rlbpImg=rlbpfusion(atlasImages,atlasLabels,targetImage,searchRadius,patchRadius,...
         updateRegion,mvResult,NumberofHiddenNeurons,C);
      saveimg(rlbpImg,targetLabelName,ni);
      disp('Labeling with linear regression with random coding LBP features');
    otherwise
      disp('Unknown method')
end

end

function [mvResulto,timeMaxo,atlasLabelso,atlasImageso]=removeone(atlasLabels,atlasImages,mvResult)
%find the removeId
maxErr=-1; removeId=1;
for iAt=1:size(atlasLabels,4)
    labimg=atlasLabels(:,:,:,iAt);
    errors=sum(labimg(:)~=mvResult(:));
    if errors>maxErr
        maxErr=errors;
        removeId=iAt;
    end
end
%remove atlas
atlasLabels(:,:,:,removeId)=[];
atlasLabelso=atlasLabels;
atlasImages(:,:,:,removeId)=[];
atlasImageso=atlasImages;
%update mv result
[mvResulto,timeMaxo]=mode(atlasLabels,4);
end

function saveimg(segResult,targetLabelName,ni)
%saveimage write image to file
%   saveimg(mvResult,targetLabelName,ni) save image segResult to
%   targetLabelName, ni is a structure load using load_untouch_nii,this
%   function replace ni.img to segResult and save to targetLabelName.
    ni.img=segResult;
    save_untouch_nii(ni,targetLabelName);
end


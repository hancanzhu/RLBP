function patchesAndLabels=getatlasPatches(atlasImages,atlasLabels,xi,yi,zi,r)
% patchesAndLabels=getatlasPatches(atlasImages,atlasLabels,xi,yi,zi,r) 
% compute patches from atlasImages and atlasLabels at position(xi,yi,zi)

patchAtlas=[];labelAtlas=[];
nAtlas=size(atlasImages,4);
for iAtlas=1:nAtlas
    lab=atlasLabels(:,:,:,iAtlas);
    img=atlasImages(:,:,:,iAtlas);
    patch=getpatch(img,xi,yi,zi,r);
    label=lab(xi,yi,zi);
    patchAtlas=[patchAtlas,patch];
    labelAtlas=[labelAtlas,label];
end
patchesAndLabels=[labelAtlas;patchAtlas];
end
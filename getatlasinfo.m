function [atlasPatch,atlasLab]=getatlasinfo(atlasPatches,xi,yi,zi,searchRadius,NumofMaxDimension)
%  [atlasPatch,atlasLab]=getatlasinfo(atlasPatches,xi,yi,zi,searchRadius,NumofMaxDimension)
%  get atalas training data from atlasFeatures at postion(nx,ny,nz).
%  searchRadius is one parameter.
atlasPatch=[];atlasLab=[];
tmpMet=[];
    for i=xi-searchRadius:xi+searchRadius
        for j=yi-searchRadius:yi+searchRadius
            for k=zi-searchRadius:zi+searchRadius
                loadIndex=NumofMaxDimension^2*i+NumofMaxDimension*j+k;
                if length(atlasPatches)>=loadIndex && loadIndex>0
                    tmpMet=[tmpMet,atlasPatches{loadIndex}];
                end
            end
        end
    end
    if length(tmpMet)~=0
        atlasLab=[atlasLab,tmpMet(1,:)];
        atlasPatch=[atlasPatch,tmpMet(2:end,:)];
    end    
end
function patch=getpatch(img,xi,yi,zi,r)
% patch=getpatch(img,xi,yi,zi,r) extracts patches from image at 
% position(xi,yi,zi) with size r*r*r.

pos=[xi,yi,zi];
down=1-(pos-r); up=(pos+r)-size(img);
pos=pos+down.*(down>0); pos=pos-up.*(up>0);
x=pos(1);y=pos(2);z=pos(3);
patch=img(x-r:x+r,y-r:y+r,z-r:z+r);      
stdNormPatch=std(patch(:));
if stdNormPatch==0 
    stdNormPatch=1; 
end
patch=(patch(:)-mean(patch(:)))./stdNormPatch;
end

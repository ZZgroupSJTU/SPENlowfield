function maskRep                   = prepMask(mask,VD)
    if ~isempty(VD)
        maskSh                     = ifftshift(ifftshift(mask,1),2);
        maskRep                    = repmat(maskSh(:),1,size(VD,1));
    else
        maskRep                    = 1;
    end
end
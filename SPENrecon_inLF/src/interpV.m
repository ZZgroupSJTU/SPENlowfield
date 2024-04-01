function [VD2,SD2,UD2]             = interpV(VD1,SD1,UD1,tD1,tD2,svd_on)
    if ~isempty(VD1)
        if (length(tD1)~=length(tD2)) | norm(tD1-tD2) ~= 0 % if tD1 ~= tD2, do interpolation
            R                      = size(VD1,1);
            VD2                    = zeros(R,length(tD2));       
            for ind = 1:R
                VD2(ind,:)         = complex(interp1(tD1,real(squeeze(VD1(ind,:))),tD2,'spline'),...
                                             interp1(tD1,imag(squeeze(VD1(ind,:))),tD2,'spline'));
            end      
            if svd_on % do svd again
                temp               = UD1*VD2;
                [UD2,SD2,tVD2]     = svd(temp,'econ');
                VD2                = tVD2;
                UD2                = UD2*SD2;
            else
                SD2                = SD1;
                UD2                = UD1;
            end
        else % otherwise, no extra operation
            VD2                    = VD1;
            UD2                    = UD1;
            SD2                    = SD1;
        end
    else
        VD2                        = [];
        UD2                        = [];
        SD2                        = [];
    end       
end  
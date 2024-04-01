function [xt_w,xt_wr] = nsRm_CSI_LYL(xt, waterMask, B0Map, params, optWat, optLip, optMeta, optOther)
[Ny,Nx,Nt] = size(xt);
ImMask =logical(imresize(logical(waterMask),[Ny,Nx]));
%% preparation
xt_w                                = zeros(Ny,Nx,Nt);
xt_wr                               = zeros(Ny,Nx,Nt);
if ~exist('B0Map','var') || isempty(B0Map)
    B0Map                           = zeros(Ny,Nx);
end
if sum(size(B0Map) ~= [Ny,Nx]) > 0
    B0Map                           = imresize(B0Map,[Ny,Nx]);
end
if ~exist('optOther','var')
    optOther                        = [];
end
%% nuisance signal removal point by point
for indy = 1:Ny
    for indx = 1:Nx
        s_xt     = xt(indy,indx,:); % 1*1*522
        df         = B0Map(indy,indx);
        if ImMask(indy,indx)        == 1
            s_xt                           = reshape(s_xt,1,[]); % 1*522
            params.df                    = df;
            s_xtWaterFat               = sigselhsvd_LYL(s_xt, params, optWat, optLip, optMeta);
            s_xtWaterFatRemoved   = s_xt - s_xtWaterFat;
        elseif ~isempty(optOther)
            s_xt                          = reshape(s_xt,1,[]);
            params.df                   = df;
            s_xtWaterFat              = sigselhsvd_LYL(s_xt, params, optOther, optLip, optMeta);
            s_xtWaterFatRemoved  = s_xt - s_xtWaterFat;
        else
            s_xtWaterFat              = 0;
            s_xtWaterFatRemoved  = s_xt;
        end
        xt_w(indy,indx,:)           = s_xtWaterFat;
        xt_wr(indy,indx,:)          = s_xtWaterFatRemoved;
    end
end
end
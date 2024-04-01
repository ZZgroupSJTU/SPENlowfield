function [xtCsiWrLr, xtCsiWrM, xtCsiWrL, xtLGs] = fRmCsiEpsi_GS(xtCsiWr, xtL_EPSI, VtL, algParams, ...
                                                  algParamsGs, algParamsFrCsi)
    Nc                           = size(xtCsiWr,4);

    % initial guess of xtLGsDs
    temp                         = algParamsGs.reg;
    algParamsGs.reg              = 1e-1;
    txtCsiWrL                    = xtCsiWr(:,:,:,1:Nc);
    algParamsGs.VtL              = VtL(1:4,:);
    [~,xtLGsDs]                  = gsRecon(xtL_EPSI(:,:,:,1:Nc),txtCsiWrL,algParamsGs); % lipid temp
    
    % start iteration
    algParamsGs.reg              = temp;
    algParamsGs.VtL              = [];
    iter                         = 0;
    
    while (iter<algParams.maxIter)    
        txtCsiWrLr               = xtCsiWr(:,:,:,1:Nc) - xtLGsDs(:,:,:,1:Nc);
        
        % fat removal
        [~,~,xtCsiWrM,outputCsi] ...
                                 = fRmCsi(txtCsiWrLr(:,:,:,1:Nc), algParamsFrCsi, xtCsiWr, []);
        algParamsFrCsi.VMD1      = outputCsi{1}.VMD1;
        algParamsFrCsi.UMD1      = outputCsi{1}.UMD1;
        algParamsFrCsi.SMD1      = outputCsi{1}.SMD1;
        
        % GS reconstruction to use both CSI and EPSI data
        txtCsiWrL                = xtCsiWr(:,:,:,1:Nc) - xtCsiWrM(:,:,:,1:Nc);
        [~,xtLGsDs_new]          = gsRecon(xtL_EPSI(:,:,:,1:Nc),txtCsiWrL,algParamsGs);

        % calculate difference
        if (norm(xtLGsDs_new(:)-xtLGsDs(:)) > algParams.tol) && (iter < (algParams.maxIter-1))
            xtLGsDs              = xtLGsDs_new;
            iter                 = iter + 1;
        else 
            algParamsGs.VtL      = VtL;
            [xtLGs,xtLGsDs]      = gsRecon(xtL_EPSI(:,:,:,1:Nc),txtCsiWrL,algParamsGs);
            xtCsiWrLr            = xtCsiWr(:,:,:,1:Nc) - xtLGsDs(:,:,:,1:Nc);
            break;
        end
    end

    xtCsiWrL                     = xtLGsDs;
end
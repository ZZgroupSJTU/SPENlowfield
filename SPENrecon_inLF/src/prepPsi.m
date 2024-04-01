function Psi                       = prepPsi(B0Map,t,shift_on,VD)
    if ~isempty(VD)
        Nt                         = length(t);
        t                          = reshape(t, 1, Nt);
        if ~isempty(B0Map)
            if shift_on
                B0Map              = ifftshift(ifftshift(B0Map,1),2); 
            end
            temp                   = reshape(kron(B0Map(:),t),[],Nt);
            Psi                    = exp(1i*2*pi*temp);
        else
            Psi                    = 1;
        end
    else
        Psi                        = 1;
    end
end
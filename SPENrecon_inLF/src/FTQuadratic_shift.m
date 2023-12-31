function res=FTQuadratic_shift(Q,k,dy)
%%
% http://www.thefouriertransform.com/pairs/complexGaussian.php
if Q>0
    res=sqrt(pi/(2*pi*Q))*exp(-1i*(pi^2*k.^2/(2*pi*Q)-pi/4)).*exp(-1i*k.*dy);
else
    res=sqrt(pi/abs(2*pi*Q))*exp(1i*(pi^2*k.^2/abs(2*pi*Q)-pi/4)).*exp(-1i*k.*dy);
end

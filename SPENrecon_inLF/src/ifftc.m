function res = ifftc(x,dim)
%res = ifftc(x,dim)
if nargin==1
    res = sqrt(length(x))*fftshift(ifft(ifftshift(x)));
else
    res = sqrt(size(x,dim))*fftshift(ifft(ifftshift(x,dim),[],dim),dim);
end


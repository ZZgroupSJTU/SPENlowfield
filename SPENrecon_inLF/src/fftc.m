function res = fftc(x,dim)
% res = fftc(x,dim)
if nargin==1
    res = 1/sqrt(length(x))*fftshift(fft(ifftshift(x)));
else
    res = 1/sqrt(size(x,dim))*fftshift(fft(ifftshift(x,dim),[],dim),dim);
end

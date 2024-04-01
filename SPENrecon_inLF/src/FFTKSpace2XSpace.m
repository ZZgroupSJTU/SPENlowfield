function [PostFFT] = FFTKSpace2XSpace(PreFFT, Dim)
   
   PostFFT = fftshift(fft(ifftshift(PreFFT, Dim), [], Dim), Dim) ;
%    PostFFT = fft(PreFFT, [], Dim) ;
   
return ;

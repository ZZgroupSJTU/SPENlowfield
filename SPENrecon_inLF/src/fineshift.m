function dataOut=fineshift(dataIn,step)

datasize=size(dataIn);
if length(step)~=length(datasize);
    error('shift step need the same size of the input data');
end

dataOut=dataIn;
order=1:length(step);
for k=1:length(step)
    if(step(k)~=0)
        shiftorder=circshift(order,[0,1-k]);
        dataOut=ipermute(fftr2k(bsxfun(@times,fftk2r(permute(dataOut,shiftorder),[],1),...
                                             exp(1i*2*pi*step(k)*((0:datasize(k)-1)-datasize(k)/2)/datasize(k)).'),[],1),shiftorder);
%         dataOut=ipermute(ifft(bsxfun(@times,fft(permute(dataOut,shiftorder),[],1),...
%                                               exp(1i*2*pi*step(k)*((0:datasize(k)-1))/datasize(k)).'),[],1),shiftorder);
    end
end

function [CNR,psignal,pnoise]=calc_2DimCNR(im,Vnoise,Vsignal,c,titletxt)
%%
% Vnoise should be a n*4 matrix, where n is the number of noise region
% Vsignal should be a m*4 matrix, where m is the number of signal region;
%%
if ~exist('c','var')
    c=[];
end

imshow(abs(im),c);
N=size(Vnoise,1);
stdnoise=zeros(1,N);
for k=1:N
    noise=im(Vnoise(k,1):Vnoise(k,1)+Vnoise(k,4)-1,Vnoise(k,2):Vnoise(k,2)+Vnoise(k,3)-1);
    stdnoise(k)=std(noise(:));
    rectangle('Position',[Vnoise(k,2),Vnoise(k,1),Vnoise(k,3),Vnoise(k,4)],'LineWidth',1,'LineStyle','--','EdgeColor','y');
end
M=size(Vsignal,1);
meansignal=zeros(1,M);
for k=1:M
    signal=im(Vsignal(k,1):Vsignal(k,1)+Vsignal(k,4)-1,Vsignal(k,2):Vsignal(k,2)+Vsignal(k,3)-1);
    meansignal(k)=mean(signal(:));
    rectangle('Position',[Vsignal(k,2),Vsignal(k,1),Vsignal(k,3),Vsignal(k,4)],'LineWidth',1,'LineStyle','--','EdgeColor','r');
end
pnoise=abs(mean(stdnoise));
psignal=abs(meansignal(1)-meansignal(2));
CNR=psignal/pnoise;
if nargin==5
    ttxt={titletxt,['CNR est:',num2str(CNR)]};
    title(ttxt);
else
    title(['CNR: ',num2str(CNR)]);
end
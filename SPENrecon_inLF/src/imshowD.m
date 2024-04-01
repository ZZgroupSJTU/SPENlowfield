function imshowD(im,Dinfor)
%@zhiyong zhang
%%
im=im(:,:,:,:);
if length(size(im))<4
    im=permute(im,[1 2 4 3]);
end

DinforDefault.save=0;
DinforDefault.FrameRate=30;
DinforDefault.repeat=1;
DinforDefault.pause=0.5;
DinforDefault.imsize=[size(im,1),size(im,2)];
DinforDefault.scale=[];
DinforDefault.shape=[1,size(im,3)];

if nargin>1
    Dinfor = UpdateParams(DinforDefault, Dinfor, true);
else
    Dinfor=DinforDefault;
end

h=figure();

if (Dinfor.save)
    if ~isfield(Dinfor,'path')
       savefile=[pwd,filesep,'temp.avi'];
    else
       savefile=[Dinfor.path,filesep,'temp.avi'];
    end
    disp(['vedio will save as ',savefile]);

    writerObj=VideoWriter(savefile);
    writerObj.FrameRate=Dinfor.FrameRate;
    open(writerObj);
    set(gcf,'color','black')
end

% Qarray=[linspace(0,0.0012*2,32);linspace(0,0.0024*2,32);linspace(0,0.0036*2,32);linspace(0,0.0048*2,32)];
for n=1:Dinfor.repeat
    for m=1:size(im,4)
%   for m=1:size(im,2)
%         title={['Q= ',num2str(Qarray(1,m))],['Q= ',num2str(Qarray(2,m))],['Q= ',num2str(Qarray(3,m))],['Q= ',num2str(Qarray(4,m))]};
%         imshowMRI(imresize(im(:,:,:,m),Dinfor.imsize),Dinfor.scale,Dinfor.shape);
          imshow3(imresize(im(:,:,:,m),Dinfor.imsize),Dinfor.scale,Dinfor.shape);
%         tmp=im(:,:,:,m);
%         tmp=tmp./max(tmp(:));
%         if m==1 || m==12
%             imshow3(imresize(tmp,Dinfor.imsize),[0.0, 0.1],Dinfor.shape);
%         else
%             imshow3(imresize(tmp,Dinfor.imsize),[0.05, 0.35],Dinfor.shape);
%         end
%         plot(real(im(:,m)),'linewidth',2,'color',[0.5 0.5 0.5]);axis off;ylim([-1,1]);xlim([0 size(im,1)]);
        if(n==1 && Dinfor.save)
            frame=getframe(h);
            writeVideo(writerObj,frame);
        end
        pause(Dinfor.pause);
    end
    if(n==1 && Dinfor.save)
        close(writerObj);
    end

end


    
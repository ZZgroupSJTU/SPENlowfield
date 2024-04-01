function imshowDRGB(im,Dinfor)
%@zhiyong zhang
%%
im=im(:,:,:,:);
if length(size(im))<4
    im=permute(im,[1 2 4 3]);
end

DinforDefault.save=0;
DinforDefault.FrameRate=30;
DinforDefault.repeat=1;
DinforDefault.pause=0.1;
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
    set(gcf,'color','white')
end

for n=1:Dinfor.repeat
    for m=1:size(im,4)
        imshow(imresize(im(:,:,:,m),Dinfor.imsize));
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


    
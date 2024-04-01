function Img2video(Imgcell,Imgtitlecell,savefile)
%% To create a video file to show or compare the images
%  Input: 
%        Img: cell structure means serveral subplots, if it is a matrix, it will be changed to cell{1}.
%             The data in cell should be Nx*Ny*Nframe format;
%        Imgtitle: cell structure means titles for subplots, if it is a text, it will be changed to cell{1}.

%  Usage example: Img2video(Imgframe,{'a1','a2'}); 
%  Written by Zhiyong Zhang, zhiyongxmu@gmail.com, 2016.03.29

%%
if ~iscell(Imgcell)
    temp{1}=Imgcell;
    Imgcell=temp;
end
if exist('Imgtitlecell','var')
    if ~iscell(Imgtitlecell)
        temp{1}=Imgtitlecell;
        Imgtitlecell=temp;
    end
else
    Imgtitlecell{1}='';
end
if ~exist('savepath','var')
   savefile=[pwd,filesep,'temp.avi'];
   disp(['vedio will save as ',savefile]);
end
h=figure();

writerObj=VideoWriter(savefile);
writerObj.FrameRate=2;
open(writerObj);
set(gcf,'color','white')
Nframe=size(Imgcell{1},3);
Nsubplot=length(Imgcell);

make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
if ~make_it_tight,  clear subplot;  end

for n=1:Nframe
    for m=1:Nsubplot;
        subplot(1,Nsubplot,m);imagesc(abs(squeeze(Imgcell{m}(:,:,n))));colormap gray;axis square; axis off;
        if ischar(Imgtitlecell{m})
            title([Imgtitlecell{m},' .Frame:',num2str(n)]);
        end
    end
    frame=getframe(h);
    writeVideo(writerObj,frame);
    pause(0.5);
end
close(writerObj);

    
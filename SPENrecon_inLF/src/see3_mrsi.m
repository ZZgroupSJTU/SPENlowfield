function see3_mrsi(im,sw,immask,gridon)
im=im(:,:,:,:);
Nx=size(im,1);
Ny=size(im,2);
handles.figure=figure();
set(gcf,'Units','normalized');
set(gcf,'position',[0.1 0.25 0.8 0.5])
handles.imAxes=subplot(1,4,1);
handles.himshow=imshow(sos(im(:,:,:,1),3),[],'InitialMagnification','fit','Parent',handles.imAxes) ;
nh=1;
if nargin<2
    sw=size(im,3);
end
if nargin>2 
    maskRGB=[0 1 0;0 0 1; 1 0 1; 1 0.5 0;1 1 0];
    for m=1:size(immask,3)
        cmask =repmat(reshape(maskRGB(m,:),[1 1 3]),[Nx,Ny,1]);
        hold on;hwaterMask = imshow(cmask);hold off;
        set(hwaterMask , 'AlphaData', 0.15*immask(:,:,m));
        nh=nh+1;
    end
end
if nargin>3 && gridon==1
    x=0.5:1:Nx+0.5;
    y=0.5:1:Ny+0.5;
    [X,Y]=meshgrid(x,y);
    handles.hline1=line(X,Y,'Parent',handles.imAxes,'linewidth',0.5,'color','b');hold on;
    handles.hline2=line(Y,X,'Parent',handles.imAxes,'linewidth',0.5,'color','b');
    nh=nh+Nx+Ny+2;
end
handles.nh=nh;
impixelinfo(handles.imAxes);
set(handles.figure,'WindowButtonDownFcn',...
    @(i1,i2,i3)seeSpec_click(im,sw,handles)); 
end


function seeSpec_click(im,sw,handles)

ClickPoint = get(handles.imAxes,'currentpoint');
[Nx,Ny,Ncs,Narray]=size(im);
mask=zeros(Nx,Ny);
x = round(ClickPoint(1,1));
y = round(ClickPoint(1,2));

if (x>0) && (x<1+Nx) && (y>0) && (y<1+Ny)
    switch (get(gcbf,'SelectionType'))
        case 'normal'
            mask(y,x)=true;
        case 'alt'
            mask(y,x)=true;
    end

    if (length(handles.imAxes.Children)>handles.nh)
        delete(handles.imAxes.Children(1));
    end

    cred =zeros(Nx,Ny,3) ;
    cred(:,:,1)=1;


    axes(handles.imAxes);
    hold on;hmask = imshow(cred);hold off;
    set(hmask , 'AlphaData', mask);

    if length(sw)==Ncs
        f=sw;
    else
        f=linspace(-sw/2,sw/2,Ncs);
    end
    sp=reshape(im(repmat(logical(mask),[1 1 Ncs Narray])),[Ncs,Narray]);
    subplot(1,4,[2 3 4],'replace');
    for m=1:Narray
        hold on;plot(f,sp(:,m));hold off;
    end
    hold on;plot([0 0],[min(sp(:)) max(sp(:))],'--k');
    legend;
end

end

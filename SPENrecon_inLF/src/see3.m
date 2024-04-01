function see3(IM, noabs, rescale,holdon)

if nargin < 2 || noabs == 0
    IM = abs(IM);
end

if nargin < 3
    rescale = false;
end

if nargin < 4
    holdon = 0;
end

button=1;
im = sqrt(sum(abs(IM.^2),3));

figure(11), imshow(IM(:,:,1),[],'InitialMagnification','fit'), impixelinfo
% figure(11), imshow(im,[],'InitialMagnification','fit'), impixelinfo
figpointer = 22;
if rescale
    imsort = sort(IM(:), 'ascend');
    ymin = imsort(1);
    ymax = imsort(round(end - end/1000));
end

while button~=2
    figure(11);
    [x,y,button] = ginput(1);

    a = IM(round(y),round(x),:);
    a = a(:);
    figure(figpointer),
    if (holdon)
        hold on;
    end    
%     plot(a,'*-');
     plot(a,'linewidth',2);
    if rescale
        ylim([ymin, ymax]);
    end
    title(sprintf('(%d, %d)',round(y),round(x)));
    if button == 3
        figpointer = figpointer + 1;
    end
end

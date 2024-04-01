function [ a ] = see3roistack(IM, noabs, rescale, figpointer, count)

use_abs = false;
if nargin < 2 || noabs == 0
    use_abs = true;
end

if nargin < 3
    rescale = false;
end

if nargin < 4
    figpointer = 22;
end

if nargin < 5
    count = inf
end

button=1;
im = sqrt(sum(abs(IM.^2),3));


if rescale
    imsort = sort(abs(IM(:)), 'ascend');
    ymin = imsort(1);
    ymax = imsort(round(end - end/1000));
end

figmain = figpointer;
figpointer = figpointer + 1;

while count > 0
    count = count - 1;
    figure(figmain), imshow(im,[],'InitialMagnification','fit'), impixelinfo

    h = imellipse;
    BW = createMask(h);
    
    a=zeros(size(IM,3),sum(BW(:)));
    figure(11);
    for ii=1:size(IM,3)
        IM1 = IM(:,:,ii);
        if use_abs
            a(ii,:) = abs(IM1(BW));
        else
            a(ii,:) = IM1(BW);
        end
    end
    
%     figure(figpointer), plot(a);
%     figure(figpointer), waterfall(a.');
    figure();plot(sum(abs(a(:,:)),2));
    if rescale
        ylim([ymin, ymax]);
    end
%     title(sprintf('(%d, %d)',round(y),round(x)));
    if button == 3
        figpointer = figpointer + 1;
    end
    close(11);
end
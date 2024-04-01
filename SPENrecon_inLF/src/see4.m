function see4(IMS, noabs, rescale)

if iscell(IMS)
    IMS_cell = true;
else
    IMS_cell = false;
end

if nargin < 2 || noabs == 0
    if IMS_cell
        IMS = cellfun(@(x) abs(x), IMS, 'UniformOutput', false);
    else
        IMS = abs(IMS);
    end
end

if nargin < 3
    rescale = false;
end

button=1;
if IMS_cell
    ims = zeros(size(dimnorm(IMS{1},3)));
    for ii=1:length(IMS)
        ims = ims + dimnorm(IMS{ii},3);
    end
    ims = ims / length(IMS);
else
    ims = dimnorm(IMS, 3);
end

figure(11), imshow(ims,[]), impixelinfo

figpointer = 22;
if rescale
    if IMS_cell
        imsort = sort(reshape(cell2mat(IMS),[],1), 'ascend');
    else
        imsort = sort(IMS(:), 'ascend');
    end
    
    ymin = imsort(1);
    ymax = imsort(end);
end

while button~=2
    figure(11);
    [x,y,button] = ginput(1);

    if IMS_cell
        leg_str = {};
        a = zeros(size(IMS{1},3),length(IMS));
        for ii=1:length(IMS)
            leg_str{ii} = sprintf('im %d', ii);
            a(:,ii) = squeeze(IMS{ii}(round(y), round(x), :));
        end
    else
        a = IMS(round(y),round(x),:);
        a = a(:);
    end
    
    figure(figpointer),
    plot(a);
    legend(leg_str);
    if rescale
        ylim([ymin, ymax]);
    end
    title(sprintf('(%d, %d)',round(y),round(x)));
    if button == 3
        figpointer = figpointer + 1;
    end
end


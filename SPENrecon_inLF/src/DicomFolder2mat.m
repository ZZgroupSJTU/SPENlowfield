function [DicomImg,DicomInf]=DicomFolder2mat(DicomPath)

DicomImg=[];
dirOutput=dir(fullfile(DicomPath,'*.dcm'));
DicomFile={dirOutput.name}';

index=1;
for k=1:length(DicomFile)
    DicomInfoOut = dicominfo(fullfile(DicomPath, DicomFile{k})) ;
    if DicomInfoOut.FileSize>100
        DicomImg(:,:,index) = double(dicomread(fullfile(DicomPath, DicomFile{index}))) ;
        DicomInf{index}=DicomInfoOut;
        index=index+1;
    end
end
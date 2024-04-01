function params=exact_dims_epiPMC(s_umr)

% data size information
Nro=str2double(s_umr.prot.Root.Seq.KSpace.MatrixRO.Value.Text);
Npe=str2double(s_umr.prot.Root.Seq.KSpace.MatrixPE.Value.Text);
Ns=str2double(s_umr.prot.Root.Seq.GLI.SliceGroup.ss0.NumberOfSlice.Value.Text);
Nrep=str2double(s_umr.prot.Root.Seq.Basic.Repetition.Value.Text);
% Nshot=str2double(s_umr.prot.Root.Seq.App.ShotNum.Value.Text);
Nshot=str2double(s_umr.prot.Root.Seq.App.Shot_num.Value.Text);
Nc=size(s_umr.rawdata_unsorted,2);
Nblip=Npe/Nshot;

if ~(str2double(s_umr.prot.Root.Seq.GLI.SliceGroup.ss0.SliceOrder.Value.Text))
    sliceorder=[1:2:Ns,2:2:Ns];
else
    sliceorder=1:Ns;
end

% Diffusion information
NbValue=str2double(s_umr.prot.Root.Seq.App.Diffusion.bValueNumber.Value.Text);
NbDirections=str2double(s_umr.prot.Root.Seq.App.Diffusion.Directions.Value.Text);
bAverageCtrl=str2double(s_umr.prot.Root.Seq.App.Diffusion.bAverageCtrl.Value.Text);

if iscell(s_umr.prot.Root.Seq.App.Diffusion.bAverage.Value)
    M=length(s_umr.prot.Root.Seq.App.Diffusion.bAverage.Value);
    bAverage=zeros(1,M);
    for m=1:M
        bAverage(m)=str2double(s_umr.prot.Root.Seq.App.Diffusion.bAverage.Value{m}.Text);
    end
else
    bAverage=str2double(s_umr.prot.Root.Seq.App.Diffusion.bAverage.Value.Text);
end

if iscell(s_umr.prot.Root.Seq.App.Diffusion.bValue.Value)
    M=length(s_umr.prot.Root.Seq.App.Diffusion.bValue.Value);
    bvalue=zeros(1,M);
    for m=1:M
        bvalue(m)=str2double(s_umr.prot.Root.Seq.App.Diffusion.bValue.Value{m}.Text);
    end
else
    bvalue=str2double(s_umr.prot.Root.Seq.App.Diffusion.bValue.Value.Text);
end

if iscell(s_umr.prot.Root.Seq.App.Diffusion.DTIGradTable.Value)
    M=length(s_umr.prot.Root.Seq.App.Diffusion.DTIGradTable.Value);
    bvector=zeros(1,M);
    for m=1:M
        bvector(m)=str2double(s_umr.prot.Root.Seq.App.Diffusion.DTIGradTable.Value{m}.Text);
    end
    bvector=reshape(bvector,3,[]);
else
    bvector=str2double(s_umr.prot.Root.Seq.App.Diffusion.DTIGradTable.Value.Text);
end

bValueNumber=str2double(s_umr.prot.Root.Seq.App.Diffusion.bValueNumber.Value.Text);
NbRepetition=1+(bValueNumber-1)*NbDirections;


bvals=[];
for m=1:NbValue
    if m==1
        tmp=repmat(reshape(bvalue(m),1,[]),[1,bAverage(m)]);
        bvals=cat(2,bvals,reshape(tmp,1,[]));   
    else
        tmp=repmat(reshape(bvalue(m),1,[]),[1,NbDirections*bAverage(m)]);
        bvals=cat(2,bvals,reshape(tmp,1,[]));  
    end
end
bvals=repmat(bvals,[1 Nrep]);

% 
% 

bvecs=[];
for m=1:NbValue
    if m==1
        tmp=repmat(reshape(zeros(3,1),1,[]),[1,bAverage(m)]);
        bvecs=cat(2,bvecs,reshape(tmp,3,[]));   
    else
        tmp=repmat(reshape(bvector,1,[]),[1,bAverage(m)]);
        bvecs=cat(2,bvecs,reshape(tmp,3,[]));  
    end
end
bvecs=repmat(bvecs,[1 Nrep]);



% parallel imaging information
TE=s_umr.prot.Root.Seq.Basic.TE.Value.Text;
PPA=str2double(s_umr.prot.Root.Seq.PPA.Method.Value.Text);
Nref=str2double(s_umr.prot.Root.Seq.PPA.RefLineLengthPE.Value.Text);

% flag for the sequence
% PMCflag=s_umr.prot.Root.Seq.App.ContrastEcho.Value.Text;
% PMC_Sync_BefExc=s_umr.prot.Root.Seq.App.Sync_BefExc.Value.Text;
 PMC_Sync_BefExc=s_umr.prot.Root.Seq.App.Sync_Exc.Value.Text;
 
 
 
params.unsortdims={Nro, Nc, Nblip};
params.unsortpcdims={Nro Nc 3};
params.sortdims={Nro Nc Nblip Ns Nshot NbRepetition Nrep};
params.slicereorder=repmat({':'},[1 length(params.sortdims)]);
params.slicereorder{4}=sliceorder;

params.dsize={Nro,Nblip*Nshot,Ns,Nc,NbRepetition,Nrep};
params.dsizebart={Nro,Nblip*Nshot,1,Nc,1,Ns,NbRepetition,Nrep};

params.diffusion.NbDir=NbDirections;
params.diffusion.bValue=bvalue;
params.diffusion.bAverage=bAverage;
params.diffusion.bvals=bvals;
params.diffusion.bvecs=bvecs;

PMCdims=[Nblip,Ns,Nshot,NbRepetition,Nrep];
params.PMC.BefExc=PMC_Sync_BefExc;
params.PMC.m_aflOrientation=reshape(s_umr.rawdataDHL.m_aflOrientation(:,Ns*Nblip+1:end),[4 PMCdims]);
params.PMC.a_aflPosition=reshape(s_umr.rawdataDHL.m_aflPosition(:,Ns*Nblip+1:end),[3 PMCdims]);
[Rmatrix,angles]=Quat2RotMat(s_umr.rawdataDHL.m_aflOrientation);
DOF=cat(1,s_umr.rawdataDHL.m_aflPosition,angles);
params.PMC.Rmatrix=Rmatrix;
params.PMC.DOF=reshape(DOF(:,Ns*Nblip+1:end),[6 PMCdims]);

params.coil_compress='scc';
params.recon.ncc=12;
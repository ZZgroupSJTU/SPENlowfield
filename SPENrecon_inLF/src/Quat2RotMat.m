function [RotMat,angles] = Quat2RotMat(QVec)

  RotMat = zeros(3,3,size(QVec,2)) ;
  angles=zeros(3,size(QVec,2));
  a = QVec(1,:) ;
  b = QVec(2,:) ;
  c = QVec(3,:) ;
  d = QVec(4,:) ;

  RotMat(1,1,:) = a.^2 + b.^2 - c.^2 - d.^2 ;
  RotMat(1,2,:) = 2*b.*c + 2*a.*d ;
  RotMat(1,3,:) = 2*b.*d - 2*c.*a ;
  RotMat(2,1,:) = 2*b.*c - 2*a.*d ;
  RotMat(2,2,:) = a.^2 - b.^2 + c.^2 - d.^2 ;
  RotMat(2,3,:) = 2*c.*d + 2*a.*b ;
  RotMat(3,1,:) = 2*b.*d + 2*a.*c ;
  RotMat(3,2,:) = 2*c.*d - 2*a.*b ;
  RotMat(3,3,:) = a.^2 - b.^2 - c.^2 + d.^2 ;
  
%   angles(1,:)=atan2(squeeze(RotMat(3,2,:)),squeeze(RotMat(3,3,:)));
%   angles(2,:)=atan2(-squeeze(RotMat(3,1,:)),squeeze(sqrt(RotMat(3,3,:).^2+RotMat(3,2,:).^2)));
%   angles(3,:)=atan2(squeeze(RotMat(2,1,:)),squeeze(RotMat(1,1,:)));
  angles(1,:)=atan(squeeze(RotMat(3,3,:))./squeeze(RotMat(3,2,:)));
  angles(2,:)=atan(-squeeze(sqrt(RotMat(3,3,:).^2+RotMat(3,2,:).^2))./squeeze(RotMat(3,1,:)));
  angles(3,:)=atan(squeeze(RotMat(1,1,:))./squeeze(RotMat(2,1,:)));


return ;
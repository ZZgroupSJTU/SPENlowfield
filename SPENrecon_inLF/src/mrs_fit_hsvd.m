function [cs,T2,z,c]=mrs_fit_hsvd(st,dt,keep)
%%
st=st(:);
N=length(st);
L=round(N/2);
Hst=hankel(st(1:(L+1)),st((L+1):end));
[U,S,~]=svd(Hst);
if nargin>2
    RankEst=keep;
else
    RankEst=25;
end
%%
Ut=U(1:end-1,1:RankEst);
Ub=U(2:end,1:RankEst);
Z=inv(Ut'*Ut)*Ut'*Ub;
Zeig=eig(Z);
[~,order]=sort(angle(Zeig));   
z=Zeig(order);
cs=angle(z)/2/pi/dt;
T2=-dt./log(abs(z));
if nargin<3
    debug=0;
end
if (nargout>3)
    A=(z.^(1:N)).';
    c=pinv(A'*A)*A'*st;
end




           
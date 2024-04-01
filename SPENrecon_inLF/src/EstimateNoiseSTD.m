function noiseSTD = EstimateNoiseSTD(dataVec)
% Syntax:
%
%   noiseSTD = EstimateNoiseSTD(dataVec) 
% 
% Estimates the noise STD by the following steps:
% 1. The data is assumed to be of the form  s = y + n, where y is the
%    "actual" signal, n is the noise (assumed to be random), and s is the
%    signal.
% 2. Assuming that curvature is negligible between adjacent data points,
%    we subtract a linear estimate from each point, formed by its nearest
%    neighbors:
%    si ---> si - (s(i+1)+s(i-1))/2
%          = y(i) - (y(i+1)+y(i-1))/2         <--- y(i) - y_est(i)
%                 + n(i) - (n(i+1)+n(i-1))/2  <--- n(i) - n_est(i)
%    We assume y(i)-y_est(i) is negligible compared to n(i)-n_est(i). 
%    This will be justified below.
% 3. According to assumption, 
%    s_est(i) ~ n(i) - (n(i+1)+n(i-1))/2
%    Note that
%    <s_est> = 0
%    <s_est^2> = <n_est^2>
%              = <n(i)^2> - 1/2*(<n(i)*n(i+1)> + <n(i)*n(i-1)>)
%                         + 1/4*(<n(i+1)^2> + 2<n(i-1)n(i+1)> + <n(i-1)^2>)
%              = 3/2*<n^2>
%    where <n^2> is the actual variance of the noise.
% 4. We see that neglecting y_est amounts to neglecting <y_est^2> compared
%    to <n^2>. Note we can write
%    y_est(i) = (y(i) - y(i-1))/2 - (y(i+1)-y(i))/2
%             = (dy/di)(i) - (dy/di)(i-1)
%    Thus we are saying that the slope doesn't change appreciably. 
%    

%dataVec = 1/sqrt(3)*(dataVec(2:end-1) - (dataVec(1:end-2) + dataVec(3:end))/2);


estimatedNoiseVector = sqrt(2/3)*(dataVec(2:end-1) - (dataVec(1:end-2) + dataVec(3:end))/2);
noiseSTD = std(estimatedNoiseVector);

% Remove outliers which are 5 times the STD
%estimatedNoiseVector = estimatedNoiseVector(real(estimatedNoiseVector)<5*noiseSTD);
%estimatedNoiseVector = estimatedNoiseVector(real(estimatedNoiseVector)>-5*noiseSTD);
%noiseSTD = std(estimatedNoiseVector);
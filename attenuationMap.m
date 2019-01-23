function [ phi ] = attenuationMap(...
    H,...
    lowPassKS,...
    lowestImSize,...
    alphaFact,...
    beta)
% attenuationMap.m
%
% Author: Ilker GURCAN
%
% Description:
%   Calculates the gradient vector field of given luminance map after
%   transforming it into log space. Remember that forward finite difference
%   method is used for calculating the gradient.
% Input:
%   H : Luminance map for corresponding HDR image in log domain. Size of 
%       MxN.
%   lowPassKS : Kernel size for low pass filter, which is applied prior to
%       downsampling for avoiding aliasing. A Gaussian kernel is employed.
%   lowestImSize : Image size for the coarsest scale.
%   alphaFact : Alpha parameter is found by 'avgGrMag*alphaFact'.
%   beta : Beta parameter for attenuating mapping function.
%
% Output:
%   phi : Attenuation map at the finest scale
%
% Usage:
%   [phi]=gradVecField(H, lowPassKS, lowestImSize, alphaFact, beta)

% Calculate the # of pyramids. The size of image at the lowest scale should
% be of at least 32x32.
[h, w] = size(H);
numPyr = cast(...
    floor(log2(min([h, w])))-ceil(log2(lowestImSize)),...
    'int32'...
);  % # of levels other than the base one.

% Create pyramid for gradient map using central finite difference
Gk = fspecial('gaussian', lowPassKS, 1.0);
gX = [-1, 0, 1];  % Central/Horizontal
gY = [-1; 0; 1];  % Central/Vertical

Gp = repmat(struct('Gx', 0, 'Gy', 0), numPyr+1);  % Gaussian Pyramid
Lt = H;
% Calculate gradients at various scales (bottom-top)
for i=0:numPyr  % Start from 0. It is our base level
    Gx         = imfilter(Lt, gX, 'same') ./ double(2.0^(i+1));
    Gy         = imfilter(Lt, gY, 'same') ./ double(2.0^(i+1));
    Gp(i+1).Gx = Gx;
    Gp(i+1).Gy = Gy;
    if i < numPyr  % Last downsampling is unnecessary for it is not used.
        Lt = imresize(...
            imfilter(Lt, Gk, 'same'),...
            0.5,...
            'bilinear');% Downsampling
    end
end

% Find alpha factor which dets. the gradient mag. to remain as is.
sqG2  = sqrt(Gp(1).Gx.^2+Gp(1).Gy.^2); % Calculate it at the base level
avGr  = mean(sqG2(:));
alpha = avGr*alphaFact;

% Calculate phi at various scales (top-bottom) in a backprop sense
    function [phiK] = atMap(Gx, Gy)
        gradNorm = sqrt(Gx.^2+Gy.^2);  % L2-norm-Magnitude
        phiK     = (alpha./gradNorm).*((gradNorm./alpha).^beta);
        % (alpha./gradNorm) may cause infinities due to non-existing norm.
        % Replace them with the average of gradient map at given scale.
        idx = find(isnan(phiK) == 1);
        if ~isempty(idx)
            phiK      = RemoveSpecials(phiK);
            phiK(idx) = mean(phiK(:));
        end
    end

phiKp1 = atMap(Gp(numPyr+1).Gx, Gp(numPyr+1).Gy);  % Start at the coarsest
for i=numPyr:-1:1
    [r, c] = size(Gp(i).Gx);
    phiK   = atMap(Gp(i).Gx, Gp(i).Gy);
    phiKp1 = imresize(phiKp1, [r, c], 'bilinear').*phiK;
end

phi = phiKp1;

end


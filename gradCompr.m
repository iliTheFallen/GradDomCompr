function [ I ] = gradCompr( ...
    image,...
    alphaFact,...
    beta,...
    bound,...
    lowestImSize,...
    lowPassKS,...
    s)
% gradCompr.m
%
% Author: Ilker GURCAN
%
% Description:
%   Calculates the gradient vector field of given luminance map after
%   transforming it into log space.
% Input:
%   lumMap : Luminance map for corresponding HDR image. Size of MxN.
%
% Output:
%   toneMapped : 
%
% Usage:
%   [I]=gradCompr(
%       image, 
%       alphaFact, 
%       beta, 
%       bound,
%       lowestImSize,
%       lowPassKS,
%       s)

% Extract luminance using sRGB to XYZ transformation
lumMap = extrLum(image);
% Add a small amount to avoid singularities
H = double(log(lumMap+1e-6));
% Create gradient vector field(gvf)
[Gx, Gy] = gradVecField(H, bound);
% Generate Attenuating Mapping Function 'phi(x, y)' via Gaussian Pyramid
phi = attenuationMap(...
    H,...
    lowPassKS,...
    lowestImSize,...
    alphaFact,...
    beta);
% Calculate attenuated gradient vector field
Ga = struct('Gx', Gx.*phi, 'Gy', Gy.*phi);
% Calculate div(Ga) using backward finite difference
div = backDiv(Ga);
% Solve Non-homogeneous equation (Poisson Equation) to obtain the
% tonemapped image's luminance
lumRec = poiSolve(div);  % In logarithmic scale
lumRec = exp(lumRec); % In original image domain
% Rescale luminance values to stay in the range of [0, 1]
maxVal = max(lumRec(:));
minVal = min(lumRec(:));
lumRec = ClampImg((lumRec - minVal) / ( maxVal - minVal), 0, 1);
% Recover color information using the old chromacity information alongside
% newly recovered luminance map.
I = recColor(image, lumMap, lumRec, s);

end


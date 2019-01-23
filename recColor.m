function [ colored ] = recColor( image, lHDR, lTMP, s )

% recColor.m
%
% Author: Ilker GURCAN
%
% Description:
%   Recovers color information using old chromacity information plus HDR
%   and tonemapped luminance values.
% Input:
%   image : Colored (RGB) HDR image.
%   lHDR : Luminance for HDR image.
%   lTMP : Luminance for tonemapped image.
%   s : Color saturation factor for tonemapped image.
%
% Output:
%   colored : Colored (RGB) tonemapped image
%
% Usage:
%   [I]=poiSolve(div)

colored = zeros(size(image)); % Pre-allocation
for i=1:3
    colored(:, :, i) = ClampImg(((image(:, :, i)./lHDR).^s).*lTMP, 0.0, 1.0);
end

colored = RemoveSpecials(colored, 1.0);

end


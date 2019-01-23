function [ lumMap ] = extrLum( image )
% extrLum.m
%
% Author: Ilker GURCAN
%
% Description:
%   Extracts luminance value out of 3-channel image via sRGB. Check out
%   wikipieda for conversion from RGB to XYZ space.
% Input:
%   image : HDR image with 3 channels, RGB.
%
% Output:
%   lumMap : Luminance corresponding to the input image.
%
% Usage:
%   [lumMap]=extrLum(image)

lumMap = double(...
    0.2126*image(:,:,1)+...
    0.7152*image(:,:,2)+...
    0.0722*image(:,:,3));

end


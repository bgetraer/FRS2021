function [I,LON,LAT] = frs_imread(file_name)
% FRS_IMREAD reads in a TIFF file with associated .tfwx file projected in
% the NJ State Plane Coordinate system, and outputs the tiff data raster
% along with the associated LON and LAT rasters to plot the image properly
% in a projection. See frs_histmaps for examples.
%   The .tfwx file is an ESRI auxillary file with geoferencing parameters
%   that can be used to transform image coordinates to the coordinate
%   system of the georeferenced image. ESRI describes this as an 
%   "approximate affine transformation."
%   
% USEAGE:
%   [I,LON,LAT] = frs_imread(file_name)
% INPUT:
%   file_name   the name of the .tiff image file (without the extension)
% OUTPUT
%   I           the image data matrix
%   LON         an identically sized matrix of longitude values
%   LAT         an identically sized matrix of latitude values
% 
%   ***********************************************************************
%   The following open source toolboxes must be in your path:
%       STATEPLANESYSTEM/
%   ***********************************************************************
% 
% See also:
%   STATEPLANETOLATLONG (see toolbox STATEPLANESYSTEM/)
%
% written by benjamingetraer@gmail.com, 8/28/2021


I = imread([file_name '.tiff']);

% Transformation from image coordinates to NJ State Plane Coordinates using
% the associated ESRI world file
[X,Y] = tfwx_transform(file_name,size(I,1),size(I,2));

% standard of US Survey Foot to meter conversion 
%   (this standard is set to change after 12/31/2022 to the international
%   foot, 0.3048 meter, but existing data has US survey foot units.)
foot_to_meter = 0.3048006096012192;
NJ = 2900;  % SPCS ID
% Transform from Easting, Northing to Lat/Lon
[LAT, LON]= StatePlaneToLatLong(X.*foot_to_meter,Y.*foot_to_meter,NJ);
end

function [X1,Y1] = tfwx_transform(file_name,height,width)
% Generate approximate coordinate matrices for raster data with a tfwx file
% (ESRI world file)
% Transformation taken from ESRI support page
%   https://desktop.arcgis.com/en/arcmap/10.3/manage-data/raster-and-images/world-files-for-raster-datasets.htm

% x1 = Ax + By + C
% y1 = Dx + Ey + F
% 
% where
% 
% x1 = calculated x-coordinate of the pixel on the map
% y1 =  calculated y-coordinate of the pixel on the map
% x = column number of a pixel in the image
% y = row number of a pixel in the image
% A = x-scale; dimension of a pixel in map units in x direction
% B, D = rotation terms
% C, F = translation terms; x,y map coordinates of the center of the upper left pixel
% E = negative of y-scale; dimension of a pixel in map units in y direction
% 
% The transformation parameters are stored in the world file in this order:
% P1 - A
% P2 - D
% P3 - B
% P4 - E
% P5 - C
% P6 - F
%
% See associated .aux.xml file for projection information, ie what the
% coordinates you calculated are
%
% written by benjamingetraer@gmail.com, 8/28/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load tfwx file parameters
tfwfile = [file_name '.tfwx'];
param = load(tfwfile);

A = param(1);
D = param(2);
B = param(3);
E = param(4);
C = param(5);
F = param(6);

% Create matrices of row and column numbers
x = repmat(1:width,height,1);       % Column numbers
y = repmat((1:height)',1,width);    % Row numbers

% Execute the transformation
X1 = A.*x + B.*y + C;
Y1 = D.*x + E.*y + F;
end

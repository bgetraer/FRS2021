function [S,c] = frs_loadhist(year,type,campusdir)
%FRS_LOADHIST reads in polygon shapefiles of historical campus land use and
%returns a shapefile object and associated color. See frs_histmaps for
%examples
% 
% Vector Files From Historical Imagery
% Image analysis done for GEO 090 2017, "Analyzing Ecological Integrity"
%   Years: 1940,1951,1963,1995,2016
%   Data: polygon shapefiles of land use/coverage, drawn by hand in ArcGIS,
%       with types 'Cleared','Developed','Lake','Trees' (each distinct
%       files).
%   Coverage: Intersection of Princeton's main campus with the coverage of
%       the actual image.
% 
% INPUT
%   year        1940,1951,1963,1995,2016
%   type        'Cleared','Developed','Lake','Trees'
%   campusdir   location of the year directories (Campus/)
% 
% OUTPUT
%   S           a shapefile object from frs_shaperead
%   c           a color based on the coverage type
% 
% See also
%   frs_shaperead, frs_histmaps.m
% 
% written by benjamingetraer@gmail.com, 8/28/2021

fields = {'Cleared','Developed','Lake','Trees'};
color = {'yellow','black','blue','green'};

if ischar(type)
    type = find(ismember(fields,type));
end

file_name = [campusdir, num2str(year), '/', fields{type}];

S = frs_shaperead(file_name);
c = color{type};
end


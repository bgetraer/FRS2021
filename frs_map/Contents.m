%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% FRS_Map - toolbox for plotting Princeton campus GIS data 
% Written by benjamingetraer@gmail.com, Aug-2021
% 
% Mapping toolbox adapting functionality from m_map/ and StatePlaneSystem/ 
% to easily plot Princeton campus GIS data, especially shapefiles with NJ 
% State Plane coordinates. Does not require the use of Mathwork's 
% proprietary mapping toolbox.
% 
% Developed for use in Fall 2021 Princeton Geosciences Freshman Seminar.
% Specific functionality for accessing historical land use files gathered
% and created during the Fall 2017 GEO 090 "Analyzing Ecological Integrity"
% reading course.
%   
% Toolbox contents
%   Contents.m          - this file
%   frs_walkthrough.m   - script demonstrating functionality of FRS_MAP
%   functions, including loading and plotting data.
%   frs_histmaps        - script demonstrating the accessing and plotting 
%   of both vector and raster historical land use files using frs_loadhist 
%   and frs_imread
% 
% User-callable functions
%   frs_buffer      - buffer a set of (x,y) limits by a percentage
%   frs_imread      - loads georeferenced raster with NJ State Plane coordinates
%   frs_inpolygon   - extract set of points or shapefile segments from polygon
%   frs_loadhist    - loads historical vector land use data
%   frs_plot        - plot shapefiles objects with .lonlat field
%   frs_polyshape   - plot polygon shapefiles with .lonlat fields
%   frs_proj        - implement a Transverse Mercator projection centered on NJ
%   frs_rectangle   - plot a rectangle with lon, lat limits
%   frs_shaperead   - read in a shapefile with NJ State Plane coordinates
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
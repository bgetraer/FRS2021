function [handle] = frs_rectangle(varargin)
%FRS_RECTANGLE plots a rectangle in the current map projection, using 
%the lat/lon points of the two opposite corners.
%   FRS_RECTANGLE takes in two longitude coordinates and two latitude
%   coordinates and connects them into a plotted rectangle using m_plot().
%   
%
% USEAGE
%   FRS_RECTANGLE(LON_LIM, LAT_LIM, [OPTIONS])
%
% INPUT
%   lon_lim     - [lon_min lon_max]
%   lat_lim     - [lat_min lat_max]
%   options     - any normal Matlab plotting options
%
% OUTPUT
%   handle      - (optional) structure with the plotted object
% 
%
% EXAMPLE: to plot the minimum bounding rectangle of a shapefile:
%       S = frs_shaperead(file_name);
%       frs_proj(S.BUFlon,S.BUFlat);
%       figure(1);clf;hold on;m_grid();
%       frs_rectangle(S.MBRlon,S.MBRlat);
%
%   ***********************************************************************
%   The following open source toolboxes must be in your path:
%       M_MAP/
%   ***********************************************************************
%   See Also: 
%       M_PLOT (see toolbox M_MAP/)
%       FRS_SHAPEREAD, FRS_PROJ
%
% written by benjamingetraer@gmail.com, 8/26/2021

i = [1,1,2,2,1]; % index to create and connect all four points
lon = varargin{1}(i);
lat = varargin{2}(flip(i));
n = length(varargin);
handle = m_plot(lon,lat,varargin{3:n}); % plot it
end


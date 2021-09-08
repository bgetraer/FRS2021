function [handle] = frs_proj(lon_lim,lat_lim)
%FRS_PROJ Executes m_proj() in a Transverse Mercator projection centered
%on the longitude -74.5 deg, i.e. the projection of the NJ State Plane, 
%with map extent set by lon_lim and lat_lim.
%   FRS_PROJ uses the NJ State Plane projection, but the resulting map
%   is in lat/lon, NOT in State Plane coordinates. Useful map limits could
%   be the limits of your data, i.e. the minimum bounding rectangle, or a 
%   buffered minimum bounding rectangle -- see frs_shaperead().
%
% INPUT
%   lon_lim     - [lon_min, lon_max] i.e. S.MBRlon or S.BUFlon from frs_shaperead()
%   lat_lim     - [lat_min, lat_max] i.e. S.MBRlat or S.BUFlat from frs_shaperead()
% OUTPUT
%   handle      - (optional) structure with the projection object
%   
%   ***********************************************************************
%   The following open source toolboxes must be in your path:
%       M_MAP/
%   ***********************************************************************
%   See Also: 
%       M_PROJ (see toolbox M_MAP/)
%       FRS_SHAPEREAD
%
% written by benjamingetraer@gmail.com, 8/26/2021

handle = m_proj('Transverse Mercator','lon',lon_lim,...
    'lat',lat_lim,'clong',-74.5);
end


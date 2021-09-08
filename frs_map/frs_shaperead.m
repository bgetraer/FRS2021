function [S] = frs_shaperead(file_name)
%FRS_SHAPEREAD Reads in a shapefile in the NJ State Plane and converts
%it to a structure S with the following fields:
%   S.ncst = {[X, Y]} points in the State Plane
%   S.MBRx = [min_X, max_X] of minimum bounding rectangle in the State Plane
%   S.MBRy = [min_Y, max_Y] of minimum bounding rectangle in the State Plane
%   S.lonlat = {[lon, lat]} points in lat/lon
%   S.MBRlon = [min_lon, max_lon] of minimum bounding rectangle in lat/lon
%   S.MBRlat = [min_lat, max_lat] of minimum bounding rectangle in lat/lon
%   S.BUFlon = S.MBRlon buffered by 10%, for use in m_proj() and m_plot()
%   S.BUFlat = S.MBRlat buffered by 10%, for use in m_proj() and m_plot()
%
%   Expected input is a shapefile with projected in the NJ State Plane
%   coordinate system - a specific case of the Transverse Mercator 
%   projection with units in US survey feet. If behavior is not as
%   expected, check the associated .prj or other auxillary files to ensure
%   expected projection and coordinate system.
% 
%   If you want to read in a shapefile with a different projection, start
%   with m_shaperead, and consider creating parallel field structures
%   to the output here, to mesh well with the other functions in this
%   toolbox!
%
%   INPUT
%       file_name   - string, path of shapefile
%   OUTPUT
%       S   - structure with shapefile data as described above
%
%   ***********************************************************************
%   The following open source toolboxes must be in your path:
%       M_MAP/
%       STATEPLANESYSTEM/
%   ***********************************************************************
%   See Also: 
%       M_SHAPEREAD (see toolbox M_MAP/)
%       STATEPLANETOLATLONG (see toolbox STATEPLANESYSTEM/)
%       FRS_BUFFER
%
% written by benjamingetraer@gmail.com, 8/26/2021

S = m_shaperead(file_name); % read in shapefile

% standard of US Survey Foot to meter conversion 
%   (this standard is set to change after 12/31/2022 to the international
%   foot, 0.3048 meter, but existing data has US survey foot units.)
foot_to_meter = 0.3048006096012192;

% Extract SPCS X,Y coordinates, convert to meters, transform to lat/lon,
% and insert into new structure fields in S

NJ = 2900; % the FIPS zone or ICODE for the NJ State Plane
S.('lonlat') = cell(size(S.ncst)); % create parallel structure for lat/lon
% loop through all sub-shapes 
%   note: StatePlaneToLatLong outputs [lat, lon], S.lonlat{i} has structure
%   [lon, lat]
for i = 1:length(S.lonlat)
    [S.lonlat{i}(:,2), S.lonlat{i}(:,1)] = ...
        StatePlaneToLatLong(S.ncst{i}(:,1)*foot_to_meter, S.ncst{i}(:,2)*foot_to_meter, NJ);
end

% the minimum bounding rectangle of all information in the shapefile,
% transformed to lat/lon coordinates
[S.('MBRlat'), S.('MBRlon')] = StatePlaneToLatLong(S.MBRx*foot_to_meter,S.MBRy*foot_to_meter,NJ);

% the minimum bouding rectangle buffered outwards by r for use in
% projecting/plotting with m_proj() and m_plot() 
r = 0.1;    % buffer scale set to 10%
[S.('BUFlat'), S.('BUFlon')] = frs_buffer(S.MBRx,S.MBRy,r,'ft');
% [S.('BUFlat'), S.('BUFlon')] = frs_buffer(S.MBRlon,S.MBRlat,r,'ll');

end


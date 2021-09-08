function [BUFlat, BUFlon] = frs_buffer(x_lim,y_lim,r,units)
%FRS_BUFFER Scales a rectangle defined by x_lim and y_lim by its linear
%distance in the NJ State Plane coordinate system. 
%   Input can be a coordinate pair in NJ State Plane coordinates or in 
%   lat/lon. The output is the buffered coordinates in lat/lon - i.e. if 
%   r = 0.5, the output lat/lon coordinate pair defines a rectangle 50% 
%   LARGER than the input ON BOTH SIDES; if r = 0, the output is identical 
%   to the input (to the precision of the coordinate conversion).
%
% INPUT
%   x_lim   - [x_min, x_max] rectangle limits, either in ft (i.e. NJ State
%                    Plane coordinates) or longitude
%   y_lim   - [y_min, y_max] rectangle limits, either in ft (i.e. NJ State
%                    Plane coordinates) or latitude
%
% OUTPUT
%   BUFlat  - the latitude limits of the buffered rectangle
%   BUFlon  - the longitude limits of the buffered rectangle
%
% EXAMPLE: 
%     S = frs_shaperead(file_name);
%     [BUFlat, BUFlon] = frs_buffer(S.MBRlon,S.MBRlat,0.25,'ll');
%     frs_proj(BUFlon,BUFlat);
%     figure(1);clf; hold on;m_grid();
%     frs_rectangle(S.MBRlon,S1.MBRlat)
%
%   ***********************************************************************
%   The following open source toolboxes must be in your path:
%       STATEPLANESYSTEM/
%   ***********************************************************************
%   See Also: 
%       STATEPLANETOLATLONG, LATLONGTOSTATEPLANE (see toolbox STATEPLANESYSTEM/)
%       FRS_SHAPEREAD, FRS_PROJ
%
% written by benjamingetraer@gmail.com, 8/26/2021

NJ = 2900; % the FIPS zone or ICODE for the NJ State Plane

switch units
    case 'll'
        [X,Y] = LatLongToStatePlane(y_lim,x_lim,NJ); % the limits in meters(!)

        x_buf = diff(X).*r; % the buffer distance
        x_lim_buf = X + [-x_buf; x_buf]; % the buffered x limits
        
        y_buf = diff(Y).*r; % the buffer distance
        y_lim_buf = Y + [-y_buf; y_buf]; % the buffered y limits
        
        % convert NJ State Plane coordinates to lat/lon
        [BUFlat, BUFlon] = StatePlaneToLatLong(x_lim_buf,y_lim_buf,NJ);
        
    case 'ft'
        % the minimum bouding rectangle buffered outwards by r for use in
        % projecting/plotting with m_proj() and m_plot()
        
        x_buf = diff(x_lim).*r; % the buffer distance
        x_lim_buf = x_lim + [-x_buf; x_buf]; % the buffered x limits
        
        y_buf = diff(y_lim).*r; % the buffer distance
        y_lim_buf = y_lim + [-y_buf; y_buf]; % the buffered y limits
        
        % standard of US Survey Foot to meter conversion
        %   (this standard is set to change after 12/31/2022 to the international
        %   foot, 0.3048 meter, but existing data has US survey foot units.)
        foot_to_meter = 0.3048006096012192;
        
        % convert NJ State Plane coordinates to lat/lon
        [BUFlat, BUFlon] = StatePlaneToLatLong(x_lim_buf*foot_to_meter,y_lim_buf*foot_to_meter,NJ);
end
end

function [index] = frs_inpolygon(varargin)
%FRS_INPOLYGON Indexes coordinates based on whether they fall within the
%polygon defined by shapefile object T. Input is either a shapefile object,
%which analyzes entire sub-segments based on the 'options' below, or a set
%of [lon],[lat] vectors which are analyzed point-by-point. FRS_INPOLYGON
%only analyzes the points of the shapefiles, it does NOT actually compare
%the area overlap of polygons!
%   shapefile objects must have a .lonlat field, as in the output from
%   frs_shaperead().
%   options for shapefile object queries:
%       'all'   - segment must be entirely within polygon to be counted
%       'any'   - any point of segment may be within polygon to be counted
%       'most'  - majority of segment must be within polygon to be counted
%       'none'  - segment must be entirely outside polygon to be counted
%       'least'  - majority of segment must be outside polygon to be counted
%
% NOTE: this may not work perfectly when T (which defines the border) has
% many sub-polygons/segments. Check to make sure it looks right.
%
% USEAGE:
%   [index] = frs_inpolygon([lon],[lat],T,option)
%   [index] = frs_inpolygon(S,T,option)
%
% INPUT
%   [lon],[lat]     vectors of (lon,lat) coordinates
%   S   shapefile object, with segments to be indexed
%   T   shapefile object, the polygon which defines the extraction border
%   option  'all', 'any', 'most', 'none', 'least'
%
% OUTPUT
%   index   for [lon,lat] points:
%               boolean index array
%   index   for S shapefile object:
%               integer array of exact index numbers corresponding to the
%               segments in S, variable length
%
% written by benjamingetraer@gmail.com, 8/27/2021

% if the query points are a shapefile structure
if isstruct(varargin{1})
    S = varargin{1};
    T = varargin{2};
    option = varargin{3};
    
    n = length(S.lonlat);
    j = zeros(n,1); % boolean index array
    
    % all elements of the polygon, as a single polyshape in (x,y) coordinates
    Tlonlat = cat(1,T.lonlat{:});
    [xv,yv] =  m_ll2xy(Tlonlat(:,1),Tlonlat(:,2));
    pgon = polyshape(xv,yv);
    
    switch option
        case 'all'
            % segment must be entirely within polygon to be counted
            for i = 1:n
                [x,y] = m_ll2xy(S.lonlat{i}(:,1),S.lonlat{i}(:,2));
                j(i) = all(isinterior(pgon,x,y));
            end
        case 'any'
            for i = 1:n
                [x,y] = m_ll2xy(S.lonlat{i}(:,1),S.lonlat{i}(:,2));
                j(i) = any(isinterior(pgon,x,y));
            end
        case 'most'
            for i = 1:n
                [x,y] = m_ll2xy(S.lonlat{i}(:,1),S.lonlat{i}(:,2));
                points_in = sum(isinterior(pgon,x,y));
                j(i) = points_in > length(S.lonlat{i}(:,1))/2;
            end
        case 'none'
            for i = 1:n
                [x,y] = m_ll2xy(S.lonlat{i}(:,1),S.lonlat{i}(:,2));
                j(i) = ~any(isinterior(pgon,x,y));
            end
        case 'least'
            for i = 1:n
                [x,y] = m_ll2xy(S.lonlat{i}(:,1),S.lonlat{i}(:,2));
                points_in = sum(isinterior(pgon,x,y));
                j(i) = points_in < length(S.lonlat{i}(:,1))/2;
            end
    end
    % return just the index numbers we want
    index = find(j);
    
    % if the query points are [lon],[lat] vectors
else
    lon = varargin{1};
    lat = varargin{2};
    T = varargin{3};
    
    n = length(lon);
%     j = zeros(n,1); % boolean index array
    
    % all elements of the polygon, as a single polyshape in (x,y) coordinates
    m = length(T.lonlat);
    Tx = cell(1,m);
    Ty = cell(1,m);

    for i = 1:m
        [Tx{1,i},Ty{1,i}] =  m_ll2xy(T.lonlat{i}(:,1),T.lonlat{i}(:,2));
    end
    pgon = polyshape(Tx,Ty);
    
    [x,y] = m_ll2xy(lon,lat);
    % return a boolean index array
    index = isinterior(pgon,x,y);
end
function [handle] = frs_polyshape(varargin)
%FRS_POLYSHAPE plots a polyshape patch of (lon,lat) data of a shapefile using 
%Matlab's polyshape() and plot(), and maintaining proper projection using 
%M_MAP's m_ll2xy(). All options of plot(polyshape) are generally available.
%   frs_polyshape(S, [options])         - plots all segments of shapefile S
%   frs_polyshape(S, 'index',  [index]) - plots only the segments listed in the index
%
% INPUT
%   S       a shapefile object with .lonlat field, i.e. output of frs_shaperead
%   index   (optional) a vector of indices corresponding to the segments to
%               plot: [1,3,4] plots the 1st, 3rd, and 4th segments.
% OUTPUT
%   handle  plotting handle object
%
% See Also:
%   polyshape, m_ll2xy
%
% written by benjamingetraer@gmail.com, 8/27/2021


if length(varargin)==1
    % plot all segments
    handle = plot_all(varargin{:});
elseif strcmp(varargin{2},'index')
    % plot indexed segments
    handle = plot_index(varargin{:});
else
    % plot all segments
    handle = plot_all(varargin{:});
end


function [handle] = plot_all(varargin)
% plot all segments
n = length(varargin);
S = varargin{1};

Sx = cell(1,length(S.lonlat));
Sy = cell(1,length(S.lonlat));
for i = 1:length(S.lonlat)
    [Sx{1,i},Sy{1,i}] =  m_ll2xy(S.lonlat{i}(:,1),S.lonlat{i}(:,2));
end
% size(Sxy)
pgon = polyshape(Sx,Sy);
handle = plot(pgon,varargin{2:n});

function [handle] = plot_index(varargin)
% plot only the indexed segments
n = length(varargin);
S = varargin{1};
index = varargin{3};
% loop through the index only
for i = 1:length(index)
    % transform (lon,lat) projection coordinates to (x,y) plot coordinates
    [x,y] = m_ll2xy(S.lonlat{index(i)}(:,1),S.lonlat{index(i)}(:,2));
    % create polyshape
    pgon = polyshape(x,y);
    % plot
    handle = plot(pgon,varargin{4:n});
end
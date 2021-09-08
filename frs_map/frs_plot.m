function [handle] = frs_plot(varargin)
%FRS_PLOT plots the (lon,lat) data of a shapefile using m_plot. All options
%of plot() are generally available.
%   frs_plot(S, [options])          - plots all segments of shapefile S
%   frs_plot(S, 'index',  [index])	- plots only the segments listed in the index
%
% INPUT
%   S       a shapefile object with .lonlat field, i.e. output of frs_shaperead
%   index   (optional) a vector of indices corresponding to the segments to
%               plot: [1,3,4] plots the 1st, 3rd, and 4th segments.
% OUTPUT
%   handle  plotting handle object
%
% See Also:
%   m_plot, frs_inpolygon
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
% loop through everything
for i = 1:length(S.lonlat)
    handle = m_plot(S.lonlat{i}(:,1),S.lonlat{i}(:,2),...
        varargin{2:n});
end

function [handle] = plot_index(varargin)
% plot only the indexed segments
n = length(varargin);
S = varargin{1};
index = varargin{3};
% loop through the index only
for i = 1:length(index)
    handle = m_plot(S.lonlat{index(i)}(:,1),S.lonlat{index(i)}(:,2),...
        varargin{4:n});
end
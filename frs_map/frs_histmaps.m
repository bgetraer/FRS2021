%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRS_HISTMAPS loads historical campus map data and plots them in example
% maps.
%
% USEAGE:
%   Each section generates a series of maps, pausing in between each one.
%   This script is intended to be with frs_map/ as the current directory.
%
% Overview: 
%   1)  Vector Files From Historical Imagery
%           Image analysis done for GEO 090 2017, "Analyzing Ecological
%           Integrity"
%   2)  Raster Files From 2016 Campus Plan
%           Created through unknown analysis for "Princeton Campus Plan,"
%           published 2008 by Beyer Blinder Belle Architects & Planners
%           LLP.
% 
% See also:
%   frs_loadhist, frs_imread
%
% written by benjamingetraer@gmail.com, 8/28/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath ../m_map ../StatePlaneSystem    % add toolboxes to path
shpfile_dir = '../../Vector/Campus/';   % the path of the vector data
raster_dir = '../../Raster/historical_maps/';   % the path of the raster data

% import Princeton Campus shapefile
PC = frs_shaperead([shpfile_dir 'REGIONS/Campus_Border']);
%% Vector Files From Historical Imagery
% Image analysis done for GEO 090 2017, "Analyzing Ecological Integrity"
%   Years: 1940,1951,1963,1995,2016
%   Data: polygon shapefiles of land use/coverage, drawn by hand in ArcGIS,
%       with types 'Cleared','Developed','Lake','Trees' (each distinct
%       files).
%   Coverage: Intersection of Princeton's main campus with the coverage of
%       the actual image.

% id info for the vector files
years = [1940,1951,1963,1995,2016];
fields = {'Cleared','Developed','Lake','Trees'};

% generate maps!
for j = 1:length(years)
    
    % initiate a cleared figure
    figure(1); clf; hold on;
    % create map projection of campus and plot campus outline
    frs_proj(PC.BUFlon,PC.BUFlat);
    m_grid('box','fancy','tickdir','out'); % nice m_map function for axis labels
    frs_plot(PC);
    
    % loop through all of the fields for each year
    h = cell(size(fields));
    for i = 1:length(fields)
        % load the shapefile with its associated color
        [S,c] = frs_loadhist(years(j),fields{i},shpfile_dir); % import Princeton Campus shapefile as an object
        h{i} = frs_polyshape(S,'facecolor',c);
    end
    
    % legend and title
    maintitle = sprintf('\\bf Princeton Campus land use: %i',years(j));
    subtitle = '\rm Historical imagery analysis from GEO 090, Fall 2017';
    title({maintitle,subtitle});
    legend([h{:}],fields{:},'location','southeast');
    
    % pause!
    pause();
end

%% Raster Files From 2016 Campus Plan
% Created through unknown analysis for "Princeton Campus Plan,"
% published 2008 by Beyer Blinder Belle Architects & Planners
% LLP. See the Read-Me in the source directory or more information.
% 
% Georeferencing was done in Fall 2017 for GEO 090 "Analyzing Ecological 
% Integrity" reading course.
% 
% The projection function m_pcolor() does not display RGB, please see the
% image files in the source directory for the original color scheme and 
% legend.png for interpretation.

years = [1756, 1852, 1897, 1927, 1975, 2006];

for i = 1:length(years)
file_name = [raster_dir num2str(years(i)) '-map'];

% Read in georeferenced tiff
[I,LON,LAT] = frs_imread(file_name);
% create a 2% buffer for the map extent
r = 0.02;
[latbuf,lonbuf] = frs_buffer([min(LON(:)) max(LON(:))]',[min(LAT(:)) max(LAT(:))]',r,'ll');

% project the map
frs_proj(lonbuf,latbuf);
% make the figure
figure(1);clf; hold on;
m_grid('box','fancy','tickdir','out');
% plot the raster data using m_pcolor
m_pcolor(LON,LAT,I(:,:,1))
% plot the campus border
frs_plot(PC,'k-','linewidth',2);

% legend and title
maintitle = sprintf('\\bf Princeton Campus land use: %i',years(i));
subtitle = '\rm See original images and legend.png in the source directory for interpretation';
title({maintitle,subtitle});

pause();
end
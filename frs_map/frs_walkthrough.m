%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRS_WALKTHROUGH   - a script showing how to utilize functions in FRS_MAP/ 
% to open and plot shapefile data in Matlab. Assembles a map of the
% buildings on Princeton's main campus, highlighting buildings on land that
% was forested in historical imagery from 1951.
%   The Matlab mapping toolbox is not utilized here. Instead two supporting 
%   toolboxes are used: M_MAP, and STATEPLANESYSTEM
%
% USEAGE:
%   This script is intended to be with frs_map/ as the current directory.
%   You can run the entire thing at once, but it's design is intended to
%   walk through examples of frs_map/ functionality section by section.
% 
% Overview: 
%   1)  Environment and Toolboxes
%   2)  Loading Shapefiles into MatLab
%   3)  What is in a shapefile
%   4)  Plotting a Shapefile / Creating a Map
%   5)  Displaying Projection Axes
%   6)  Minimum Bounding Box
%   7)  Changing the Map Extent
%   8)  Shapefiles with Multiple Segments
%   9)  Extracting Elements with Another Shapefile
%   10) Plotting Filled Polyshapes
%   11) Extracting Elements from Polyshapes
%   12) Plotting your own points
%   10) Title and legend
%
% The following toolboxes and functions are called directly -
% See Also:
%       FRS_MAP/    frs_shaperead, frs_proj, frs_plot, frs_polyshape,
%                   frs_inpolygon, frs_buffer, frs_rectangle  
%       M_MAP/      m_plot, m_grid, m_ruler, m_ginput    
%
%
% written by benjamingetraer@gmail.com, 8/27/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Environment and Toolboxes
% This script assumes the following directory structure:
%
% /FRS_2021/
%     Matlab/
%         frs_map/
%         m_map/
%         StatePlaneSystem/
%     Vector/
%         Campus/
%
% Let's start by adding m_map and StatePlaneSystem to our working path and
% printing the contents of Vector/Campus/ where example shapefiles should
% be.

addpath ../m_map ../StatePlaneSystem    % add toolboxes to path
shpfile_dir = '../../Vector/CAMPUS/';   % save the path of our vector data
ls(shpfile_dir)                         % check for campus vector files
%% Loading Shapefiles into MatLab
% We can start by loading the outline of the main Princeton Campus. First 
% define the file path, then import the shapefile to an object in MatLab.

file_name = [shpfile_dir 'REGIONS/Campus_Border']; % don't include the file extension
PC = frs_shaperead(file_name); % import Princeton Campus shapefile as an object 

% note: "# Records in file" in terminal output tells you how many segments 
% the shapefile contains within it.

%% What is in a shapefile
% The shapefile object contains some metadata, as well as:
%   - coordinates in the NJ State Plane Coordinate System (SPCS)
%   - coordinates in Lat/Lon
%   - the "minimum bounding rectangle" (MBR) of the coordinates,in Lat/Lon
%       as well as the NJ SPCS
%   - a buffered MBR in Lat/Lon (buffered by 10% on each side)

% Coordinates in the NJ State Plane Coordinate System, the data of the
% original shapefile (these are Eastings and Northings in feet)
clc     % clear command window
display(PC.ncst{1}(1:10,:))     % check out some (easting, northing) data
%%
% Coordinates in Lat/Lon, generated by campus_shaperead() when we loaded
% the shapefile
clc
display(PC.lonlat{:}(1:10,:))   % check out some (lon, lat) data
%% Plotting a Shapefile / Creating a Map
% The plotting tools are based in the m_map/ toolbox, and allow us to 
% project data using (lon,lat) coordinates on Cartesian MatLab axes with 
% ease.
% 
% First, we set a projection that determines how coordinates are plotted, 
% as well as the extent of the map that gets drawn. The general function is
% m_proj, but here we use frs_proj which calls m_proj to implement a 
% specific case of the Transverse Mercator projection suitable for campus 
% data -- actually, the same projection used in the NJ State Plane, just 
% with (lon,lat) coordinates rather than (Easting,Northing) in feet.
% 
% To do this, all we have to choose is the extent of the map. In this case,
% lets use the 10% buffer around the minimum bouding rectangle, already 
% generated in the shapefile object:
frs_proj(PC.BUFlon,PC.BUFlat);

% Next we plot the (lon, lat) coordinates of the shapefile.
% For clarity, here is how you access the lon and lat:
PClon = PC.lonlat{1}(:,1);
PClat = PC.lonlat{1}(:,2);

% open a figure window, clear it in case it's already initiated, hold on to
%   plot multiple things
figure(1);clf; hold on; 
% plot (lat,lon) coordinates directly with the chosen projection using
%   m_plot():
m_plot(PClon,PClat,'-','linewidth',1); 

%% 
% alternatively, we can plot a shapefile directly using frs_plot()
figure(1);clf; hold on; pause(0.2);
frs_plot(PC,'-','linewidth',1);
%% Displaying Projection Axes
% Figure(1) currently is showing the coordinates of the cartesian axes that
% Matlab initiated. m_map tracks the transformation between those axes
% and the (lon,lat) of our projection for us! Display these with m_grid().

% Label the axes with our projection coordinates:
figure(1)
m_grid('box','fancy','tickdir','out'); % nice m_map function for axis labels

% This is also a nice time to add a scale bar using m_ruler()
y = 0.05; x_lim = [0.03 0.3]; n_ticks = 3; height = 0.005;
m_ruler(x_lim,y,n_ticks,'tickdir','out','ticklength',height);
%% Minimum Bounding Box
% When we set the projection using frs_proj() we also set the map extent to
% the minimum bounding box of our shapefile data, buffered by 10%. 

% Next, let's check out the miminum bounding rectangle of the data. To do 
% this, we can feed the longitude and latitude limits (already stored in 
% the PC object we created) to frs_rectangle which plots the rectangle 
% defined by a set of (x,y) limits.
figure(1)
frs_rectangle(PC.MBRlon,PC.MBRlat);

%% Changing the Map Extent
% If we decide we want a different map extent, we can reproject. We could
% choose any limits we want, but let's say we want a slightly larger buffer
% of the minimum bounding rectangle:

% get the 25% buffer limits of the mbr using lat/lon units
r=0.25;
[latbuf,lonbuf] = frs_buffer(PC.MBRlon,PC.MBRlat,r,'ll'); 
frs_proj(lonbuf,latbuf);

% Replot same data with new projection

% reset figure(1) and make it a little bigger
f1 = figure(1);clf; hold on; f1.Position = [100 100 720 534];
m_grid('box','fancy','tickdir','out');
m_ruler(x_lim,y,n_ticks,'tickdir','out','ticklength',height);
h_campus = frs_plot(PC,'-','linewidth',1); % the shapefile
h_mbr = frs_rectangle(PC.MBRlon,PC.MBRlat); % the mbr
h_buf = frs_rectangle(PC.BUFlon,PC.BUFlat,'--k'); % the default buffer
%% Shapefiles with Multiple Segments
% Next, let's load a shapefile that has more than one line segment. For 
% example, every Princeton University building from 2013:

file_name = [shpfile_dir 'BuildingOutlines/Buildings2013'];
PB_2013 = frs_shaperead(file_name);
% Each (of 2,220) building segment gets it's own cell with Lat/Lon 
% coordinates, so we would have to loop through to plot them all. 

%% Extracting elements with another shapefile
% If we just want the buildings on the main campus, we can choose only the 
% segments that fall completely within our main campus polygon.  

% index of 2013 buildings that have any of their points within the main campus
index = frs_inpolygon(PB_2013,PC,'any'); 

% plot them using the 'index' option in frs_plot
figure(1);
h_pb = frs_plot(PB_2013,'index',index,'k','linewidth',0.1);
%% Plotting Filled Polyshapes
% Next, we take a look at some vector data taken from historical imagery. 
% Let's look at the polygon of forested land on the main campus from 1951:
file_name = [shpfile_dir  '1951/Trees'];
F51 = frs_shaperead(file_name);

% We could plot this as a line using frs_plot(), similar to the main campus
% outline we have, or we could plot using frs_polyshape() which allows us
% to plot a filled polygon with multiple segments and holes:
figure(1);
h_f51 = frs_polyshape(F51,'FaceColor','green');

%% Extracting Elements from Polyshapes
% You can choose segments of shapefiles that fall within a polyshape just
% like a more simple polygon. This is mostly working, but take a look at
% the data if you use this! If coordinates for multiple shapes are
% unexpectedly stored in a single shape, this will yield undesired results.

% Get the buildings that are entirely on land that was forested in 1951:
index51 = frs_inpolygon(PB_2013,F51,'all'); 

% Plot
figure(1);
h_pb_f51 = frs_polyshape(PB_2013,'index',index51,'facecolor','k','linewidth',1.25);

% Looking at the plot, we see that the patch of woods surrounding the 
% Washington Rd stream (S of Frick) used to extend further East, and was
% significantly reduced by the construction of Jadwin Gym, one of the 
% largest buildings on the current campus.

%% Plotting your own points
% Use m_plot() to plot points in (lon,lat). 
% Here we will first select some arbitrary points in (lon, lat) using
% m_ginput().

% choose some points, including some within the forested area:
figure(1)
some_points = m_ginput();
h_points = m_plot(some_points(:,1),some_points(:,2),'ok','markerfacecolor','k');
figure(1)
%%
% find the points that are inside of the forested area polyshape:
figure(1)
[index] = frs_inpolygon(some_points(:,1),some_points(:,2),F51);
h_points_in = m_plot(some_points(index,1),some_points(index,2),'or','markerfacecolor','r');
%% Title and Legend
figure(1)
maintitle = '\bf Princeton Buildings on 1951 Forested Land';
subtitle = sprintf('\\rm Map extent: %i%% buffer of main campus minimum bounding rectangle',...
    r*100);
title({maintitle,subtitle});
legend([h_campus, h_f51, h_pb, h_pb_f51, h_mbr, h_buf, h_points,h_points_in],...
    'Princeton campus','historically forested land (1951)',...
    'Princeton University buildings','buildings on 1951 forested land',...
    'mbr example','10% buffered mbr','user input points','points on 1951 forested land','location','southeast');
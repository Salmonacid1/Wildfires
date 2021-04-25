%% Loading Data for Acres Burned due to Wildfires in California

filename='1987-2018CalWildfireData';
TotalAcresBurned=readtable(filename);
Total_Burned=table2array(TotalAcresBurned);
Total_Burned(9,2)=209815; %had to fill in value from table because comma caused it to be a NaN

%Graphing Exploratory 
figure (1)
bar(Total_Burned(:,1),Total_Burned(:,2))
xlabel("Year")
ylabel("Acres Burned")
title("Acres Burned due to Wildfires from 1987-2018")

%% Loading Spatial Data for 2020 Wildfires in California

filename='fire_nrt_M-C61_195333';
WildfireLocations2020=readtable(filename);
Wildfire_Locations_2020 = WildfireLocations2020;
% LAT = WildfireLocations2020.latitude;
% LON = WildfireLocations2020.longitude;

%Removing wildfires that did not occur in boundaries of California
%Border Range: 
%   Longitude: 114.133333 W to 124.4 W
%   Latitude: 32.5 N to 42 N
% 
% Latitude = LAT
% Longitude = LON

toDelete =Wildfire_Locations_2020.latitude > 42;
Wildfire_Locations_2020(toDelete, :) = [];

toDelete = Wildfire_Locations_2020.latitude < 32.5;
Wildfire_Locations_2020(toDelete, :) = [];
 
toDelete = Wildfire_Locations_2020.longitude < -124.4 ;
Wildfire_Locations_2020(toDelete, :) = [];
  
toDelete = Wildfire_Locations_2020.longitude > -114.133333;
Wildfire_Locations_2020(toDelete, :) = [];

%Plotting 2020 Wildfire Data on a Map 
latlim= [32.5 42]
lonlim = [-124.4 -114.133333]

figure (2)
ax= usamap(latlim,lonlim)
axis off
getm(gca, 'MapProjection')
states = shaperead('usastatehi',...
    'UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
faceColors = makesymbolspec('Polygon',...
    {'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
geoshow(ax,states,'SymbolSpec',faceColors)
scatterm(Wildfire_Locations_2020.latitude,Wildfire_Locations_2020.longitude,5,'filled','k')
title('Location of Wildfires in California in 2020')



% cali = shaperead('usastatehi', 'UseGeoCoords', true,'Selector',{@(name) strcmpi(name,'California'), 'Name'});
% axesm mercator; %Define Map axes
% geoshow(cali); %Display map
% plotm(LAT,LON,'Color','r','Marker','.','MarkerSize',1); %plot point at [lat,lon] location
% 
% %%use worldmap and constrain the lat/long for california 

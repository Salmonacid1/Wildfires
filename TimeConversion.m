function [CD_Adjusted_Time] = TimeConversion(filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Precipitation_CD = readtable(filename)
Precip_Info = table2array(Precipitation_CD);
CD_Date = Precip_Info(:,1)
Proper_Year = floor(CD_Date./100);
Proper_Month = CD_Date -(Proper_Year .* 100); 
CD_Adjusted_Time = datenum(Proper_Year, Proper_Month, 0);

end


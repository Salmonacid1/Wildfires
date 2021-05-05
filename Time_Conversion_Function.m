function [CD_Adjusted_Time] = TimeConversion(filename)
%===================================================================
%
% USAGE:  [CD_Adjusted_Time] = TimeConversion(filename)
%
% DESCRIPTION:
%   Use this function to convert the recorded times of the Climate Division
%   Precipitation and Temperature data into a MATLAB recognized time. 


CD_Data = readtable(filename)
CD_Info = table2array(CD_Data);
CD_Date = CD_Info(:,1)
Proper_Year = floor(CD_Date./100);
Proper_Month = CD_Date -(Proper_Year .* 100); 
CD_Adjusted_Time = datenum(Proper_Year, Proper_Month, 0);

end


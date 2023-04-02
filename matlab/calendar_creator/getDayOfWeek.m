function dayOfWeek = getDayOfWeek(month, day, year)
    % Construct a string representing the date
    dateString = sprintf('%04d-%02d-%02d', year, month, day);
    
    % Convert the string to a serial date number
    serialDateNum = datenum(dateString);
    
    % Use the serial date number to get the corresponding day of the week
    dayOfWeek = datestr(serialDateNum, 'dddd');
end

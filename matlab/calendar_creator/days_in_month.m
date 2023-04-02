function num_days = days_in_month(year, month)
  % Determine the number of days in the given month and year
  if month == 2 % February has 28 or 29 days depending on whether the year is a leap year
    if mod(year, 4) == 0 && (mod(year, 100) != 0 || mod(year, 400) == 0)
      num_days = 29;
    else
      num_days = 28;
    end
  elseif ismember(month, [4 6 9 11]) % April, June, September, and November have 30 days
    num_days = 30;
  else % All other months have 31 days
    num_days = 31;
  end
end

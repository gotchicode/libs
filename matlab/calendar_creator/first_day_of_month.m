function day_of_week = first_day_of_month(year, month)
  % Calculer le nombre de jours depuis le 1er janvier 1900 (date de référence pour le calendrier utilisé par Octave)
  days_since_reference = (year - 1900) * 365 + floor((year - 1900) / 4);
  days_since_reference += sum([0 31 59 90 120 151 181 212 243 273 304 334](1:(month-1)));
  if (month > 2 && mod(year, 4) == 0 && (mod(year, 100) != 0 || mod(year, 400) == 0))
    days_since_reference += 1;
  end

  % Calculer le jour de la semaine correspondant
  day_of_week = mod(days_since_reference, 7) + 1;
end
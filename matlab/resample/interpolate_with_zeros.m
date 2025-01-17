function interpolated_sequence = interpolate_with_zeros(data_sequence, ovr)
    interpolated_sequence = [];
    
    for i = 1:length(data_sequence)
        interpolated_sequence = [interpolated_sequence, data_sequence(i)];
        for j = 1:(ovr - 1)
            interpolated_sequence = [interpolated_sequence, 0];
        end
    end
end
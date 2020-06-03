function position = find_minus_6dB(data_in)

for k=1:length(data_in)
    delta(k)=abs(data_in(k)-0.5);
end
[value_min_delta, value_min_delta_position]=min(delta);
position=value_min_delta_position;

end
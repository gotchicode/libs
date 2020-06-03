function unfold_data_out = unfold(unfold_data_in,R,nb_points)

unfold_data_out=zeros(1,nb_points*R);
unfold_data_cnt_out=zeros(1,nb_points*R);
m=1;
for k=1:R
    for n=1:nb_points
        unfold_data_cnt_out(m)=mod(m,nb_points);
         if m>nb_points
             unfold_data_cnt_out(m)=(k-1)*nb_points+1-n;
             unfold_data_out(m)=unfold_data_out((k-1)*nb_points+1-n);
         else
             unfold_data_out(m)=unfold_data_in(n);
             unfold_data_cnt_out(m)=m;
         end
        m=m+1;
    end
end
end
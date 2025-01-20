%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBUG SUBPLOT TED and PED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,1);
plot(ADEBUG_TABLE_ted_phase_out,'o');
title ("ted phase out");

subplot(3,3,2);
plot(ADEBUG_TABLE_loop_out_ted,'o');
title ("loop out ted");

subplot(3,3,3);
plot(ADEBUG_TABLE_sum_corrections_ted,'o');
title ("sum corrections ted");

subplot(3,3,4);
plot(ADEBUG_TABLE_data_symbols_angle,'o');
title ("data symbols angle");

subplot(3,3,5);
plot(ADEBUG_TABLE_loop_out_ped,'o');
title ("loop out ped");

subplot(3,3,6);
plot(data_symbols(end-1024:end),'o');
title ("data symbols");

subplot(3,3,7);
##plot(ADEBUG_TABLE_ted_loop_accu_pulse);
##hold on;
plot(ADEBUG_TABLE_ted_mean,'o');
##hold on;
##plot(ADEBUG_TABLE_ted_rms, 'x');
title ("ted mean and rms");

subplot(3,3,8);
##plot(ADEBUG_TABLE_ped_loop_accu_pulse);
##hold on;
plot(ADEBUG_TABLE_ped_mean,'o');
##hold on;
##plot(ADEBUG_TABLE_ped_rms, 'x');
title ("ped mean and rms");


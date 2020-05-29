
function [const_1em9_val, const_45_val, const_90_val, const_135_val, const_180_val, const_225_val, const_270_val, const_315_val, const_360_val, const_K, atan_const] = cordic_cos_sin_const(quant)



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Theorical values / Exact
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	pi_const          =   pi;%3.14159265359;
	const_1em9_val    =   2 * pi_const/360 * 1e-9;
	const_45_val      =   2 * pi_const/360 * 45;
	const_90_val      =   2 * pi_const/360 * 90;
	const_135_val     =   2 * pi_const/360 * 135;
	const_180_val     =   2 * pi_const/360 * 180;
	const_225_val     =   2 * pi_const/360 * 225;
	const_270_val     =   2 * pi_const/360 * 270;
	const_315_val     =   2 * pi_const/360 * 315;
	const_360_val     =   2 * pi_const/360 * 360;
	const_K           =   0.6072529350088814;


	atan_const=[];
	for k=0:31
		%if debug==1
		%  fprintf("i=%d 2^-i=%f atan=%f rad atan=%f deg\n",k,2^-k,atan(2^-k),atan(2^-k)/2/pi*const_360_val);
		%end
		atan_const=[atan_const atan(2^-k)];
	end
	
if quant==1
  
else
  
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Quantified
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	const_1em9_val    =   1;
	const_45_val      =   round((quant-1) * const_45_val   / 2 / pi);    
	const_90_val      =   round((quant-1) * const_90_val   / 2 / pi);    
	const_135_val     =   round((quant-1) * const_135_val  / 2 / pi);   
	const_180_val     =   round((quant-1) * const_180_val  / 2 / pi);   
	const_225_val     =   round((quant-1) * const_225_val  / 2 / pi);   
	const_270_val     =   round((quant-1) * const_270_val  / 2 / pi);   
	const_315_val     =   round((quant-1) * const_315_val  / 2 / pi);   
	const_360_val     =   round((quant-1) * const_360_val  / 2 / pi);   
	const_K           =   round((quant-1) * const_K        / 2 / pi);   

	atan_const        =   round((quant-1) * atan_const     / 2 / pi); 
	
end

end
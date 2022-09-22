library IEEE;                                                                                            
use IEEE.std_logic_1164.all;                                                                             
use IEEE.numeric_std.all;                                                                                
use     ieee.math_real.all;                                                                              
                                                                                                         
entity fir_with_opt_accu is                                                                                            
 port (                                                                                                  
            clk             : in std_logic;                                                              
                                                                                                         
            data_in         : in std_logic_vector(11 downto 0);                                          
            data_in_en      : in std_logic;                                                              
                                                                                                         
			data_out		: out std_logic_vector(11 downto 0);                                          
			data_out_en		: out std_logic                                                               
                                                                                                         
 );                                                                                                      
end entity fir_with_opt_accu;                                                                                          
                                                                                                         
architecture rtl of fir_with_opt_accu is                                                                               
                                                                                                         
                                                                                                         
                                                                                                         
constant nb_taps                        : integer:=342;                                                   
type taps_type                          is array (0 to nb_taps-1) of signed(13 downto 0);                
signal taps                             : taps_type;                                                     
type fir_reg_type                       is array (0 to nb_taps-1) of signed(11 downto 0);                
signal fir_reg                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d1                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d2                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d3                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d4                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d5                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d6                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d7                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d8                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d9                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d10                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d11                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d12                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d13                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d14                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d15                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d16                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d17                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d18                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d19                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d20                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d21                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d22                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d23                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d24                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d25                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d26                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d27                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d28                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d29                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d30                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d31                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d32                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d33                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d34                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d35                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d36                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d37                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d38                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d39                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d40                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d41                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d42                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d43                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d44                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d45                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d46                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d47                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d48                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d49                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d50                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d51                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d52                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d53                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d54                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d55                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d56                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d57                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d58                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d59                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d60                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d61                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d62                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d63                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d64                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d65                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d66                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d67                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d68                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d69                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d70                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d71                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d72                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d73                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d74                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d75                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d76                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d77                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d78                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d79                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d80                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d81                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d82                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d83                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d84                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d85                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d86                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d87                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d88                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d89                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d90                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d91                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d92                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d93                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d94                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d95                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d96                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d97                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d98                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d99                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d100                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d101                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d102                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d103                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d104                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d105                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d106                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d107                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d108                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d109                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d110                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d111                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d112                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d113                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d114                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d115                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d116                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d117                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d118                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d119                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d120                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d121                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d122                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d123                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d124                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d125                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d126                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d127                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d128                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d129                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d130                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d131                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d132                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d133                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d134                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d135                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d136                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d137                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d138                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d139                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d140                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d141                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d142                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d143                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d144                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d145                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d146                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d147                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d148                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d149                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d150                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d151                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d152                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d153                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d154                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d155                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d156                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d157                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d158                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d159                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d160                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d161                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d162                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d163                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d164                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d165                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d166                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d167                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d168                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d169                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d170                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d171                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d172                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d173                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d174                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d175                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d176                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d177                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d178                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d179                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d180                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d181                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d182                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d183                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d184                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d185                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d186                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d187                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d188                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d189                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d190                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d191                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d192                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d193                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d194                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d195                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d196                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d197                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d198                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d199                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d200                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d201                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d202                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d203                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d204                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d205                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d206                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d207                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d208                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d209                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d210                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d211                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d212                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d213                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d214                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d215                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d216                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d217                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d218                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d219                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d220                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d221                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d222                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d223                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d224                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d225                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d226                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d227                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d228                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d229                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d230                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d231                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d232                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d233                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d234                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d235                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d236                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d237                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d238                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d239                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d240                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d241                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d242                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d243                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d244                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d245                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d246                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d247                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d248                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d249                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d250                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d251                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d252                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d253                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d254                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d255                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d256                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d257                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d258                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d259                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d260                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d261                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d262                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d263                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d264                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d265                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d266                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d267                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d268                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d269                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d270                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d271                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d272                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d273                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d274                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d275                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d276                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d277                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d278                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d279                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d280                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d281                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d282                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d283                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d284                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d285                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d286                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d287                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d288                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d289                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d290                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d291                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d292                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d293                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d294                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d295                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d296                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d297                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d298                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d299                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d300                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d301                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d302                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d303                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d304                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d305                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d306                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d307                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d308                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d309                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d310                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d311                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d312                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d313                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d314                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d315                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d316                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d317                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d318                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d319                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d320                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d321                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d322                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d323                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d324                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d325                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d326                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d327                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d328                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d329                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d330                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d331                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d332                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d333                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d334                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d335                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d336                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d337                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d338                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d339                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d340                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d341                          : fir_reg_type:=(others=>(others=>'0'));                        
signal fir_reg_d342                          : fir_reg_type:=(others=>(others=>'0'));                        
type taps_x_fir_reg_type                is array (0 to nb_taps-1) of signed(25 downto 0);                
signal taps_x_fir_reg                   : taps_x_fir_reg_type;                                           
                                                                                                         
                                                                                                         
                                                                                                         
type taps_x_fir_reg_accu_type           is array (0 to nb_taps) of signed(63 downto 0);                  
signal taps_x_fir_reg_accu              : taps_x_fir_reg_accu_type:=(others=>(others=>'0')); 
signal taps_x_fir_reg_accu_en           : std_logic_vector(nb_taps-1 downto 0);                          
                                                                                                         
                                                                                                         
                                                                                                         
signal data_in_en_r1               : std_logic;                                                          
signal data_in_en_r2               : std_logic;                                                          
signal data_in_en_r3               : std_logic;                                                          
signal data_out_prepare            : std_logic_vector(11 downto 0);                                      
signal data_out_prepare_en         : std_logic;                                                          
                                                                                                         
begin                                                                                                    
                                                                                                         
                                                                                                         
                                                                                                         
    ------------------------------------------                                                           
    -- Fir implementation                                                                                
    ------------------------------------------                                                           
    process(clk)                                                                                         
    variable v_round : signed(1 downto 0);                                                               
    begin                                                                                                
                                                                                                         
        if rising_edge(clk) then                                                                         
                                                                                                         
            --shift registers                                                                            
            if data_in_en='1' then                                                                     
                fir_reg(0) <= signed(data_in);                                                           
                for I in 1 to nb_taps-1 loop                                                             
                       fir_reg(I) <= fir_reg(I-1);                                                       
                    end loop;                                                                            
            end if;                                                                                      
            data_in_en_r1 <= data_in_en;                                                                 
            data_in_en_r2 <= data_in_en_r1;                                                                 
                                                                                                         
            --multiply                                                                                   
            --First tap                                                                                  
            taps_x_fir_reg_accu(0) <= resize(fir_reg(0) *  taps(0),64);                                  
            fir_reg_d1 <= fir_reg;                                                                       
            taps_x_fir_reg_accu_en(0)<= data_in_en_r2;                                                   
                                                                                                         
            fir_reg_d2 <= fir_reg_d1;                                                                 
            taps_x_fir_reg(1)           <= fir_reg_d1(1) *  taps(1);                                                 
            taps_x_fir_reg_accu(1)      <= taps_x_fir_reg(1) + taps_x_fir_reg_accu(0);                                    
            taps_x_fir_reg_accu_en(1)   <= taps_x_fir_reg_accu_en(0);                                  
                                                                                                         
            fir_reg_d3 <= fir_reg_d2;                                                                 
            taps_x_fir_reg(2)           <= fir_reg_d2(2) *  taps(2);                                                 
            taps_x_fir_reg_accu(2)      <= taps_x_fir_reg(2) + taps_x_fir_reg_accu(1);                                    
            taps_x_fir_reg_accu_en(2)   <= taps_x_fir_reg_accu_en(1);                                  
                                                                                                         
            fir_reg_d4 <= fir_reg_d3;                                                                 
            taps_x_fir_reg(3)           <= fir_reg_d3(3) *  taps(3);                                                 
            taps_x_fir_reg_accu(3)      <= taps_x_fir_reg(3) + taps_x_fir_reg_accu(2);                                    
            taps_x_fir_reg_accu_en(3)   <= taps_x_fir_reg_accu_en(2);                                  
                                                                                                         
            fir_reg_d5 <= fir_reg_d4;                                                                 
            taps_x_fir_reg(4)           <= fir_reg_d4(4) *  taps(4);                                                 
            taps_x_fir_reg_accu(4)      <= taps_x_fir_reg(4) + taps_x_fir_reg_accu(3);                                    
            taps_x_fir_reg_accu_en(4)   <= taps_x_fir_reg_accu_en(3);                                  
                                                                                                         
            fir_reg_d6 <= fir_reg_d5;                                                                 
            taps_x_fir_reg(5)           <= fir_reg_d5(5) *  taps(5);                                                 
            taps_x_fir_reg_accu(5)      <= taps_x_fir_reg(5) + taps_x_fir_reg_accu(4);                                    
            taps_x_fir_reg_accu_en(5)   <= taps_x_fir_reg_accu_en(4);                                  
                                                                                                         
            fir_reg_d7 <= fir_reg_d6;                                                                 
            taps_x_fir_reg(6)           <= fir_reg_d6(6) *  taps(6);                                                 
            taps_x_fir_reg_accu(6)      <= taps_x_fir_reg(6) + taps_x_fir_reg_accu(5);                                    
            taps_x_fir_reg_accu_en(6)   <= taps_x_fir_reg_accu_en(5);                                  
                                                                                                         
            fir_reg_d8 <= fir_reg_d7;                                                                 
            taps_x_fir_reg(7)           <= fir_reg_d7(7) *  taps(7);                                                 
            taps_x_fir_reg_accu(7)      <= taps_x_fir_reg(7) + taps_x_fir_reg_accu(6);                                    
            taps_x_fir_reg_accu_en(7)   <= taps_x_fir_reg_accu_en(6);                                  
                                                                                                         
            fir_reg_d9 <= fir_reg_d8;                                                                 
            taps_x_fir_reg(8)           <= fir_reg_d8(8) *  taps(8);                                                 
            taps_x_fir_reg_accu(8)      <= taps_x_fir_reg(8) + taps_x_fir_reg_accu(7);                                    
            taps_x_fir_reg_accu_en(8)   <= taps_x_fir_reg_accu_en(7);                                  
                                                                                                         
            fir_reg_d10 <= fir_reg_d9;                                                                 
            taps_x_fir_reg(9)           <= fir_reg_d9(9) *  taps(9);                                                 
            taps_x_fir_reg_accu(9)      <= taps_x_fir_reg(9) + taps_x_fir_reg_accu(8);                                    
            taps_x_fir_reg_accu_en(9)   <= taps_x_fir_reg_accu_en(8);                                  
                                                                                                         
            fir_reg_d11 <= fir_reg_d10;                                                                 
            taps_x_fir_reg(10)           <= fir_reg_d10(10) *  taps(10);                                                 
            taps_x_fir_reg_accu(10)      <= taps_x_fir_reg(10) + taps_x_fir_reg_accu(9);                                    
            taps_x_fir_reg_accu_en(10)   <= taps_x_fir_reg_accu_en(9);                                  
                                                                                                         
            fir_reg_d12 <= fir_reg_d11;                                                                 
            taps_x_fir_reg(11)           <= fir_reg_d11(11) *  taps(11);                                                 
            taps_x_fir_reg_accu(11)      <= taps_x_fir_reg(11) + taps_x_fir_reg_accu(10);                                    
            taps_x_fir_reg_accu_en(11)   <= taps_x_fir_reg_accu_en(10);                                  
                                                                                                         
            fir_reg_d13 <= fir_reg_d12;                                                                 
            taps_x_fir_reg(12)           <= fir_reg_d12(12) *  taps(12);                                                 
            taps_x_fir_reg_accu(12)      <= taps_x_fir_reg(12) + taps_x_fir_reg_accu(11);                                    
            taps_x_fir_reg_accu_en(12)   <= taps_x_fir_reg_accu_en(11);                                  
                                                                                                         
            fir_reg_d14 <= fir_reg_d13;                                                                 
            taps_x_fir_reg(13)           <= fir_reg_d13(13) *  taps(13);                                                 
            taps_x_fir_reg_accu(13)      <= taps_x_fir_reg(13) + taps_x_fir_reg_accu(12);                                    
            taps_x_fir_reg_accu_en(13)   <= taps_x_fir_reg_accu_en(12);                                  
                                                                                                         
            fir_reg_d15 <= fir_reg_d14;                                                                 
            taps_x_fir_reg(14)           <= fir_reg_d14(14) *  taps(14);                                                 
            taps_x_fir_reg_accu(14)      <= taps_x_fir_reg(14) + taps_x_fir_reg_accu(13);                                    
            taps_x_fir_reg_accu_en(14)   <= taps_x_fir_reg_accu_en(13);                                  
                                                                                                         
            fir_reg_d16 <= fir_reg_d15;                                                                 
            taps_x_fir_reg(15)           <= fir_reg_d15(15) *  taps(15);                                                 
            taps_x_fir_reg_accu(15)      <= taps_x_fir_reg(15) + taps_x_fir_reg_accu(14);                                    
            taps_x_fir_reg_accu_en(15)   <= taps_x_fir_reg_accu_en(14);                                  
                                                                                                         
            fir_reg_d17 <= fir_reg_d16;                                                                 
            taps_x_fir_reg(16)           <= fir_reg_d16(16) *  taps(16);                                                 
            taps_x_fir_reg_accu(16)      <= taps_x_fir_reg(16) + taps_x_fir_reg_accu(15);                                    
            taps_x_fir_reg_accu_en(16)   <= taps_x_fir_reg_accu_en(15);                                  
                                                                                                         
            fir_reg_d18 <= fir_reg_d17;                                                                 
            taps_x_fir_reg(17)           <= fir_reg_d17(17) *  taps(17);                                                 
            taps_x_fir_reg_accu(17)      <= taps_x_fir_reg(17) + taps_x_fir_reg_accu(16);                                    
            taps_x_fir_reg_accu_en(17)   <= taps_x_fir_reg_accu_en(16);                                  
                                                                                                         
            fir_reg_d19 <= fir_reg_d18;                                                                 
            taps_x_fir_reg(18)           <= fir_reg_d18(18) *  taps(18);                                                 
            taps_x_fir_reg_accu(18)      <= taps_x_fir_reg(18) + taps_x_fir_reg_accu(17);                                    
            taps_x_fir_reg_accu_en(18)   <= taps_x_fir_reg_accu_en(17);                                  
                                                                                                         
            fir_reg_d20 <= fir_reg_d19;                                                                 
            taps_x_fir_reg(19)           <= fir_reg_d19(19) *  taps(19);                                                 
            taps_x_fir_reg_accu(19)      <= taps_x_fir_reg(19) + taps_x_fir_reg_accu(18);                                    
            taps_x_fir_reg_accu_en(19)   <= taps_x_fir_reg_accu_en(18);                                  
                                                                                                         
            fir_reg_d21 <= fir_reg_d20;                                                                 
            taps_x_fir_reg(20)           <= fir_reg_d20(20) *  taps(20);                                                 
            taps_x_fir_reg_accu(20)      <= taps_x_fir_reg(20) + taps_x_fir_reg_accu(19);                                    
            taps_x_fir_reg_accu_en(20)   <= taps_x_fir_reg_accu_en(19);                                  
                                                                                                         
            fir_reg_d22 <= fir_reg_d21;                                                                 
            taps_x_fir_reg(21)           <= fir_reg_d21(21) *  taps(21);                                                 
            taps_x_fir_reg_accu(21)      <= taps_x_fir_reg(21) + taps_x_fir_reg_accu(20);                                    
            taps_x_fir_reg_accu_en(21)   <= taps_x_fir_reg_accu_en(20);                                  
                                                                                                         
            fir_reg_d23 <= fir_reg_d22;                                                                 
            taps_x_fir_reg(22)           <= fir_reg_d22(22) *  taps(22);                                                 
            taps_x_fir_reg_accu(22)      <= taps_x_fir_reg(22) + taps_x_fir_reg_accu(21);                                    
            taps_x_fir_reg_accu_en(22)   <= taps_x_fir_reg_accu_en(21);                                  
                                                                                                         
            fir_reg_d24 <= fir_reg_d23;                                                                 
            taps_x_fir_reg(23)           <= fir_reg_d23(23) *  taps(23);                                                 
            taps_x_fir_reg_accu(23)      <= taps_x_fir_reg(23) + taps_x_fir_reg_accu(22);                                    
            taps_x_fir_reg_accu_en(23)   <= taps_x_fir_reg_accu_en(22);                                  
                                                                                                         
            fir_reg_d25 <= fir_reg_d24;                                                                 
            taps_x_fir_reg(24)           <= fir_reg_d24(24) *  taps(24);                                                 
            taps_x_fir_reg_accu(24)      <= taps_x_fir_reg(24) + taps_x_fir_reg_accu(23);                                    
            taps_x_fir_reg_accu_en(24)   <= taps_x_fir_reg_accu_en(23);                                  
                                                                                                         
            fir_reg_d26 <= fir_reg_d25;                                                                 
            taps_x_fir_reg(25)           <= fir_reg_d25(25) *  taps(25);                                                 
            taps_x_fir_reg_accu(25)      <= taps_x_fir_reg(25) + taps_x_fir_reg_accu(24);                                    
            taps_x_fir_reg_accu_en(25)   <= taps_x_fir_reg_accu_en(24);                                  
                                                                                                         
            fir_reg_d27 <= fir_reg_d26;                                                                 
            taps_x_fir_reg(26)           <= fir_reg_d26(26) *  taps(26);                                                 
            taps_x_fir_reg_accu(26)      <= taps_x_fir_reg(26) + taps_x_fir_reg_accu(25);                                    
            taps_x_fir_reg_accu_en(26)   <= taps_x_fir_reg_accu_en(25);                                  
                                                                                                         
            fir_reg_d28 <= fir_reg_d27;                                                                 
            taps_x_fir_reg(27)           <= fir_reg_d27(27) *  taps(27);                                                 
            taps_x_fir_reg_accu(27)      <= taps_x_fir_reg(27) + taps_x_fir_reg_accu(26);                                    
            taps_x_fir_reg_accu_en(27)   <= taps_x_fir_reg_accu_en(26);                                  
                                                                                                         
            fir_reg_d29 <= fir_reg_d28;                                                                 
            taps_x_fir_reg(28)           <= fir_reg_d28(28) *  taps(28);                                                 
            taps_x_fir_reg_accu(28)      <= taps_x_fir_reg(28) + taps_x_fir_reg_accu(27);                                    
            taps_x_fir_reg_accu_en(28)   <= taps_x_fir_reg_accu_en(27);                                  
                                                                                                         
            fir_reg_d30 <= fir_reg_d29;                                                                 
            taps_x_fir_reg(29)           <= fir_reg_d29(29) *  taps(29);                                                 
            taps_x_fir_reg_accu(29)      <= taps_x_fir_reg(29) + taps_x_fir_reg_accu(28);                                    
            taps_x_fir_reg_accu_en(29)   <= taps_x_fir_reg_accu_en(28);                                  
                                                                                                         
            fir_reg_d31 <= fir_reg_d30;                                                                 
            taps_x_fir_reg(30)           <= fir_reg_d30(30) *  taps(30);                                                 
            taps_x_fir_reg_accu(30)      <= taps_x_fir_reg(30) + taps_x_fir_reg_accu(29);                                    
            taps_x_fir_reg_accu_en(30)   <= taps_x_fir_reg_accu_en(29);                                  
                                                                                                         
            fir_reg_d32 <= fir_reg_d31;                                                                 
            taps_x_fir_reg(31)           <= fir_reg_d31(31) *  taps(31);                                                 
            taps_x_fir_reg_accu(31)      <= taps_x_fir_reg(31) + taps_x_fir_reg_accu(30);                                    
            taps_x_fir_reg_accu_en(31)   <= taps_x_fir_reg_accu_en(30);                                  
                                                                                                         
            fir_reg_d33 <= fir_reg_d32;                                                                 
            taps_x_fir_reg(32)           <= fir_reg_d32(32) *  taps(32);                                                 
            taps_x_fir_reg_accu(32)      <= taps_x_fir_reg(32) + taps_x_fir_reg_accu(31);                                    
            taps_x_fir_reg_accu_en(32)   <= taps_x_fir_reg_accu_en(31);                                  
                                                                                                         
            fir_reg_d34 <= fir_reg_d33;                                                                 
            taps_x_fir_reg(33)           <= fir_reg_d33(33) *  taps(33);                                                 
            taps_x_fir_reg_accu(33)      <= taps_x_fir_reg(33) + taps_x_fir_reg_accu(32);                                    
            taps_x_fir_reg_accu_en(33)   <= taps_x_fir_reg_accu_en(32);                                  
                                                                                                         
            fir_reg_d35 <= fir_reg_d34;                                                                 
            taps_x_fir_reg(34)           <= fir_reg_d34(34) *  taps(34);                                                 
            taps_x_fir_reg_accu(34)      <= taps_x_fir_reg(34) + taps_x_fir_reg_accu(33);                                    
            taps_x_fir_reg_accu_en(34)   <= taps_x_fir_reg_accu_en(33);                                  
                                                                                                         
            fir_reg_d36 <= fir_reg_d35;                                                                 
            taps_x_fir_reg(35)           <= fir_reg_d35(35) *  taps(35);                                                 
            taps_x_fir_reg_accu(35)      <= taps_x_fir_reg(35) + taps_x_fir_reg_accu(34);                                    
            taps_x_fir_reg_accu_en(35)   <= taps_x_fir_reg_accu_en(34);                                  
                                                                                                         
            fir_reg_d37 <= fir_reg_d36;                                                                 
            taps_x_fir_reg(36)           <= fir_reg_d36(36) *  taps(36);                                                 
            taps_x_fir_reg_accu(36)      <= taps_x_fir_reg(36) + taps_x_fir_reg_accu(35);                                    
            taps_x_fir_reg_accu_en(36)   <= taps_x_fir_reg_accu_en(35);                                  
                                                                                                         
            fir_reg_d38 <= fir_reg_d37;                                                                 
            taps_x_fir_reg(37)           <= fir_reg_d37(37) *  taps(37);                                                 
            taps_x_fir_reg_accu(37)      <= taps_x_fir_reg(37) + taps_x_fir_reg_accu(36);                                    
            taps_x_fir_reg_accu_en(37)   <= taps_x_fir_reg_accu_en(36);                                  
                                                                                                         
            fir_reg_d39 <= fir_reg_d38;                                                                 
            taps_x_fir_reg(38)           <= fir_reg_d38(38) *  taps(38);                                                 
            taps_x_fir_reg_accu(38)      <= taps_x_fir_reg(38) + taps_x_fir_reg_accu(37);                                    
            taps_x_fir_reg_accu_en(38)   <= taps_x_fir_reg_accu_en(37);                                  
                                                                                                         
            fir_reg_d40 <= fir_reg_d39;                                                                 
            taps_x_fir_reg(39)           <= fir_reg_d39(39) *  taps(39);                                                 
            taps_x_fir_reg_accu(39)      <= taps_x_fir_reg(39) + taps_x_fir_reg_accu(38);                                    
            taps_x_fir_reg_accu_en(39)   <= taps_x_fir_reg_accu_en(38);                                  
                                                                                                         
            fir_reg_d41 <= fir_reg_d40;                                                                 
            taps_x_fir_reg(40)           <= fir_reg_d40(40) *  taps(40);                                                 
            taps_x_fir_reg_accu(40)      <= taps_x_fir_reg(40) + taps_x_fir_reg_accu(39);                                    
            taps_x_fir_reg_accu_en(40)   <= taps_x_fir_reg_accu_en(39);                                  
                                                                                                         
            fir_reg_d42 <= fir_reg_d41;                                                                 
            taps_x_fir_reg(41)           <= fir_reg_d41(41) *  taps(41);                                                 
            taps_x_fir_reg_accu(41)      <= taps_x_fir_reg(41) + taps_x_fir_reg_accu(40);                                    
            taps_x_fir_reg_accu_en(41)   <= taps_x_fir_reg_accu_en(40);                                  
                                                                                                         
            fir_reg_d43 <= fir_reg_d42;                                                                 
            taps_x_fir_reg(42)           <= fir_reg_d42(42) *  taps(42);                                                 
            taps_x_fir_reg_accu(42)      <= taps_x_fir_reg(42) + taps_x_fir_reg_accu(41);                                    
            taps_x_fir_reg_accu_en(42)   <= taps_x_fir_reg_accu_en(41);                                  
                                                                                                         
            fir_reg_d44 <= fir_reg_d43;                                                                 
            taps_x_fir_reg(43)           <= fir_reg_d43(43) *  taps(43);                                                 
            taps_x_fir_reg_accu(43)      <= taps_x_fir_reg(43) + taps_x_fir_reg_accu(42);                                    
            taps_x_fir_reg_accu_en(43)   <= taps_x_fir_reg_accu_en(42);                                  
                                                                                                         
            fir_reg_d45 <= fir_reg_d44;                                                                 
            taps_x_fir_reg(44)           <= fir_reg_d44(44) *  taps(44);                                                 
            taps_x_fir_reg_accu(44)      <= taps_x_fir_reg(44) + taps_x_fir_reg_accu(43);                                    
            taps_x_fir_reg_accu_en(44)   <= taps_x_fir_reg_accu_en(43);                                  
                                                                                                         
            fir_reg_d46 <= fir_reg_d45;                                                                 
            taps_x_fir_reg(45)           <= fir_reg_d45(45) *  taps(45);                                                 
            taps_x_fir_reg_accu(45)      <= taps_x_fir_reg(45) + taps_x_fir_reg_accu(44);                                    
            taps_x_fir_reg_accu_en(45)   <= taps_x_fir_reg_accu_en(44);                                  
                                                                                                         
            fir_reg_d47 <= fir_reg_d46;                                                                 
            taps_x_fir_reg(46)           <= fir_reg_d46(46) *  taps(46);                                                 
            taps_x_fir_reg_accu(46)      <= taps_x_fir_reg(46) + taps_x_fir_reg_accu(45);                                    
            taps_x_fir_reg_accu_en(46)   <= taps_x_fir_reg_accu_en(45);                                  
                                                                                                         
            fir_reg_d48 <= fir_reg_d47;                                                                 
            taps_x_fir_reg(47)           <= fir_reg_d47(47) *  taps(47);                                                 
            taps_x_fir_reg_accu(47)      <= taps_x_fir_reg(47) + taps_x_fir_reg_accu(46);                                    
            taps_x_fir_reg_accu_en(47)   <= taps_x_fir_reg_accu_en(46);                                  
                                                                                                         
            fir_reg_d49 <= fir_reg_d48;                                                                 
            taps_x_fir_reg(48)           <= fir_reg_d48(48) *  taps(48);                                                 
            taps_x_fir_reg_accu(48)      <= taps_x_fir_reg(48) + taps_x_fir_reg_accu(47);                                    
            taps_x_fir_reg_accu_en(48)   <= taps_x_fir_reg_accu_en(47);                                  
                                                                                                         
            fir_reg_d50 <= fir_reg_d49;                                                                 
            taps_x_fir_reg(49)           <= fir_reg_d49(49) *  taps(49);                                                 
            taps_x_fir_reg_accu(49)      <= taps_x_fir_reg(49) + taps_x_fir_reg_accu(48);                                    
            taps_x_fir_reg_accu_en(49)   <= taps_x_fir_reg_accu_en(48);                                  
                                                                                                         
            fir_reg_d51 <= fir_reg_d50;                                                                 
            taps_x_fir_reg(50)           <= fir_reg_d50(50) *  taps(50);                                                 
            taps_x_fir_reg_accu(50)      <= taps_x_fir_reg(50) + taps_x_fir_reg_accu(49);                                    
            taps_x_fir_reg_accu_en(50)   <= taps_x_fir_reg_accu_en(49);                                  
                                                                                                         
            fir_reg_d52 <= fir_reg_d51;                                                                 
            taps_x_fir_reg(51)           <= fir_reg_d51(51) *  taps(51);                                                 
            taps_x_fir_reg_accu(51)      <= taps_x_fir_reg(51) + taps_x_fir_reg_accu(50);                                    
            taps_x_fir_reg_accu_en(51)   <= taps_x_fir_reg_accu_en(50);                                  
                                                                                                         
            fir_reg_d53 <= fir_reg_d52;                                                                 
            taps_x_fir_reg(52)           <= fir_reg_d52(52) *  taps(52);                                                 
            taps_x_fir_reg_accu(52)      <= taps_x_fir_reg(52) + taps_x_fir_reg_accu(51);                                    
            taps_x_fir_reg_accu_en(52)   <= taps_x_fir_reg_accu_en(51);                                  
                                                                                                         
            fir_reg_d54 <= fir_reg_d53;                                                                 
            taps_x_fir_reg(53)           <= fir_reg_d53(53) *  taps(53);                                                 
            taps_x_fir_reg_accu(53)      <= taps_x_fir_reg(53) + taps_x_fir_reg_accu(52);                                    
            taps_x_fir_reg_accu_en(53)   <= taps_x_fir_reg_accu_en(52);                                  
                                                                                                         
            fir_reg_d55 <= fir_reg_d54;                                                                 
            taps_x_fir_reg(54)           <= fir_reg_d54(54) *  taps(54);                                                 
            taps_x_fir_reg_accu(54)      <= taps_x_fir_reg(54) + taps_x_fir_reg_accu(53);                                    
            taps_x_fir_reg_accu_en(54)   <= taps_x_fir_reg_accu_en(53);                                  
                                                                                                         
            fir_reg_d56 <= fir_reg_d55;                                                                 
            taps_x_fir_reg(55)           <= fir_reg_d55(55) *  taps(55);                                                 
            taps_x_fir_reg_accu(55)      <= taps_x_fir_reg(55) + taps_x_fir_reg_accu(54);                                    
            taps_x_fir_reg_accu_en(55)   <= taps_x_fir_reg_accu_en(54);                                  
                                                                                                         
            fir_reg_d57 <= fir_reg_d56;                                                                 
            taps_x_fir_reg(56)           <= fir_reg_d56(56) *  taps(56);                                                 
            taps_x_fir_reg_accu(56)      <= taps_x_fir_reg(56) + taps_x_fir_reg_accu(55);                                    
            taps_x_fir_reg_accu_en(56)   <= taps_x_fir_reg_accu_en(55);                                  
                                                                                                         
            fir_reg_d58 <= fir_reg_d57;                                                                 
            taps_x_fir_reg(57)           <= fir_reg_d57(57) *  taps(57);                                                 
            taps_x_fir_reg_accu(57)      <= taps_x_fir_reg(57) + taps_x_fir_reg_accu(56);                                    
            taps_x_fir_reg_accu_en(57)   <= taps_x_fir_reg_accu_en(56);                                  
                                                                                                         
            fir_reg_d59 <= fir_reg_d58;                                                                 
            taps_x_fir_reg(58)           <= fir_reg_d58(58) *  taps(58);                                                 
            taps_x_fir_reg_accu(58)      <= taps_x_fir_reg(58) + taps_x_fir_reg_accu(57);                                    
            taps_x_fir_reg_accu_en(58)   <= taps_x_fir_reg_accu_en(57);                                  
                                                                                                         
            fir_reg_d60 <= fir_reg_d59;                                                                 
            taps_x_fir_reg(59)           <= fir_reg_d59(59) *  taps(59);                                                 
            taps_x_fir_reg_accu(59)      <= taps_x_fir_reg(59) + taps_x_fir_reg_accu(58);                                    
            taps_x_fir_reg_accu_en(59)   <= taps_x_fir_reg_accu_en(58);                                  
                                                                                                         
            fir_reg_d61 <= fir_reg_d60;                                                                 
            taps_x_fir_reg(60)           <= fir_reg_d60(60) *  taps(60);                                                 
            taps_x_fir_reg_accu(60)      <= taps_x_fir_reg(60) + taps_x_fir_reg_accu(59);                                    
            taps_x_fir_reg_accu_en(60)   <= taps_x_fir_reg_accu_en(59);                                  
                                                                                                         
            fir_reg_d62 <= fir_reg_d61;                                                                 
            taps_x_fir_reg(61)           <= fir_reg_d61(61) *  taps(61);                                                 
            taps_x_fir_reg_accu(61)      <= taps_x_fir_reg(61) + taps_x_fir_reg_accu(60);                                    
            taps_x_fir_reg_accu_en(61)   <= taps_x_fir_reg_accu_en(60);                                  
                                                                                                         
            fir_reg_d63 <= fir_reg_d62;                                                                 
            taps_x_fir_reg(62)           <= fir_reg_d62(62) *  taps(62);                                                 
            taps_x_fir_reg_accu(62)      <= taps_x_fir_reg(62) + taps_x_fir_reg_accu(61);                                    
            taps_x_fir_reg_accu_en(62)   <= taps_x_fir_reg_accu_en(61);                                  
                                                                                                         
            fir_reg_d64 <= fir_reg_d63;                                                                 
            taps_x_fir_reg(63)           <= fir_reg_d63(63) *  taps(63);                                                 
            taps_x_fir_reg_accu(63)      <= taps_x_fir_reg(63) + taps_x_fir_reg_accu(62);                                    
            taps_x_fir_reg_accu_en(63)   <= taps_x_fir_reg_accu_en(62);                                  
                                                                                                         
            fir_reg_d65 <= fir_reg_d64;                                                                 
            taps_x_fir_reg(64)           <= fir_reg_d64(64) *  taps(64);                                                 
            taps_x_fir_reg_accu(64)      <= taps_x_fir_reg(64) + taps_x_fir_reg_accu(63);                                    
            taps_x_fir_reg_accu_en(64)   <= taps_x_fir_reg_accu_en(63);                                  
                                                                                                         
            fir_reg_d66 <= fir_reg_d65;                                                                 
            taps_x_fir_reg(65)           <= fir_reg_d65(65) *  taps(65);                                                 
            taps_x_fir_reg_accu(65)      <= taps_x_fir_reg(65) + taps_x_fir_reg_accu(64);                                    
            taps_x_fir_reg_accu_en(65)   <= taps_x_fir_reg_accu_en(64);                                  
                                                                                                         
            fir_reg_d67 <= fir_reg_d66;                                                                 
            taps_x_fir_reg(66)           <= fir_reg_d66(66) *  taps(66);                                                 
            taps_x_fir_reg_accu(66)      <= taps_x_fir_reg(66) + taps_x_fir_reg_accu(65);                                    
            taps_x_fir_reg_accu_en(66)   <= taps_x_fir_reg_accu_en(65);                                  
                                                                                                         
            fir_reg_d68 <= fir_reg_d67;                                                                 
            taps_x_fir_reg(67)           <= fir_reg_d67(67) *  taps(67);                                                 
            taps_x_fir_reg_accu(67)      <= taps_x_fir_reg(67) + taps_x_fir_reg_accu(66);                                    
            taps_x_fir_reg_accu_en(67)   <= taps_x_fir_reg_accu_en(66);                                  
                                                                                                         
            fir_reg_d69 <= fir_reg_d68;                                                                 
            taps_x_fir_reg(68)           <= fir_reg_d68(68) *  taps(68);                                                 
            taps_x_fir_reg_accu(68)      <= taps_x_fir_reg(68) + taps_x_fir_reg_accu(67);                                    
            taps_x_fir_reg_accu_en(68)   <= taps_x_fir_reg_accu_en(67);                                  
                                                                                                         
            fir_reg_d70 <= fir_reg_d69;                                                                 
            taps_x_fir_reg(69)           <= fir_reg_d69(69) *  taps(69);                                                 
            taps_x_fir_reg_accu(69)      <= taps_x_fir_reg(69) + taps_x_fir_reg_accu(68);                                    
            taps_x_fir_reg_accu_en(69)   <= taps_x_fir_reg_accu_en(68);                                  
                                                                                                         
            fir_reg_d71 <= fir_reg_d70;                                                                 
            taps_x_fir_reg(70)           <= fir_reg_d70(70) *  taps(70);                                                 
            taps_x_fir_reg_accu(70)      <= taps_x_fir_reg(70) + taps_x_fir_reg_accu(69);                                    
            taps_x_fir_reg_accu_en(70)   <= taps_x_fir_reg_accu_en(69);                                  
                                                                                                         
            fir_reg_d72 <= fir_reg_d71;                                                                 
            taps_x_fir_reg(71)           <= fir_reg_d71(71) *  taps(71);                                                 
            taps_x_fir_reg_accu(71)      <= taps_x_fir_reg(71) + taps_x_fir_reg_accu(70);                                    
            taps_x_fir_reg_accu_en(71)   <= taps_x_fir_reg_accu_en(70);                                  
                                                                                                         
            fir_reg_d73 <= fir_reg_d72;                                                                 
            taps_x_fir_reg(72)           <= fir_reg_d72(72) *  taps(72);                                                 
            taps_x_fir_reg_accu(72)      <= taps_x_fir_reg(72) + taps_x_fir_reg_accu(71);                                    
            taps_x_fir_reg_accu_en(72)   <= taps_x_fir_reg_accu_en(71);                                  
                                                                                                         
            fir_reg_d74 <= fir_reg_d73;                                                                 
            taps_x_fir_reg(73)           <= fir_reg_d73(73) *  taps(73);                                                 
            taps_x_fir_reg_accu(73)      <= taps_x_fir_reg(73) + taps_x_fir_reg_accu(72);                                    
            taps_x_fir_reg_accu_en(73)   <= taps_x_fir_reg_accu_en(72);                                  
                                                                                                         
            fir_reg_d75 <= fir_reg_d74;                                                                 
            taps_x_fir_reg(74)           <= fir_reg_d74(74) *  taps(74);                                                 
            taps_x_fir_reg_accu(74)      <= taps_x_fir_reg(74) + taps_x_fir_reg_accu(73);                                    
            taps_x_fir_reg_accu_en(74)   <= taps_x_fir_reg_accu_en(73);                                  
                                                                                                         
            fir_reg_d76 <= fir_reg_d75;                                                                 
            taps_x_fir_reg(75)           <= fir_reg_d75(75) *  taps(75);                                                 
            taps_x_fir_reg_accu(75)      <= taps_x_fir_reg(75) + taps_x_fir_reg_accu(74);                                    
            taps_x_fir_reg_accu_en(75)   <= taps_x_fir_reg_accu_en(74);                                  
                                                                                                         
            fir_reg_d77 <= fir_reg_d76;                                                                 
            taps_x_fir_reg(76)           <= fir_reg_d76(76) *  taps(76);                                                 
            taps_x_fir_reg_accu(76)      <= taps_x_fir_reg(76) + taps_x_fir_reg_accu(75);                                    
            taps_x_fir_reg_accu_en(76)   <= taps_x_fir_reg_accu_en(75);                                  
                                                                                                         
            fir_reg_d78 <= fir_reg_d77;                                                                 
            taps_x_fir_reg(77)           <= fir_reg_d77(77) *  taps(77);                                                 
            taps_x_fir_reg_accu(77)      <= taps_x_fir_reg(77) + taps_x_fir_reg_accu(76);                                    
            taps_x_fir_reg_accu_en(77)   <= taps_x_fir_reg_accu_en(76);                                  
                                                                                                         
            fir_reg_d79 <= fir_reg_d78;                                                                 
            taps_x_fir_reg(78)           <= fir_reg_d78(78) *  taps(78);                                                 
            taps_x_fir_reg_accu(78)      <= taps_x_fir_reg(78) + taps_x_fir_reg_accu(77);                                    
            taps_x_fir_reg_accu_en(78)   <= taps_x_fir_reg_accu_en(77);                                  
                                                                                                         
            fir_reg_d80 <= fir_reg_d79;                                                                 
            taps_x_fir_reg(79)           <= fir_reg_d79(79) *  taps(79);                                                 
            taps_x_fir_reg_accu(79)      <= taps_x_fir_reg(79) + taps_x_fir_reg_accu(78);                                    
            taps_x_fir_reg_accu_en(79)   <= taps_x_fir_reg_accu_en(78);                                  
                                                                                                         
            fir_reg_d81 <= fir_reg_d80;                                                                 
            taps_x_fir_reg(80)           <= fir_reg_d80(80) *  taps(80);                                                 
            taps_x_fir_reg_accu(80)      <= taps_x_fir_reg(80) + taps_x_fir_reg_accu(79);                                    
            taps_x_fir_reg_accu_en(80)   <= taps_x_fir_reg_accu_en(79);                                  
                                                                                                         
            fir_reg_d82 <= fir_reg_d81;                                                                 
            taps_x_fir_reg(81)           <= fir_reg_d81(81) *  taps(81);                                                 
            taps_x_fir_reg_accu(81)      <= taps_x_fir_reg(81) + taps_x_fir_reg_accu(80);                                    
            taps_x_fir_reg_accu_en(81)   <= taps_x_fir_reg_accu_en(80);                                  
                                                                                                         
            fir_reg_d83 <= fir_reg_d82;                                                                 
            taps_x_fir_reg(82)           <= fir_reg_d82(82) *  taps(82);                                                 
            taps_x_fir_reg_accu(82)      <= taps_x_fir_reg(82) + taps_x_fir_reg_accu(81);                                    
            taps_x_fir_reg_accu_en(82)   <= taps_x_fir_reg_accu_en(81);                                  
                                                                                                         
            fir_reg_d84 <= fir_reg_d83;                                                                 
            taps_x_fir_reg(83)           <= fir_reg_d83(83) *  taps(83);                                                 
            taps_x_fir_reg_accu(83)      <= taps_x_fir_reg(83) + taps_x_fir_reg_accu(82);                                    
            taps_x_fir_reg_accu_en(83)   <= taps_x_fir_reg_accu_en(82);                                  
                                                                                                         
            fir_reg_d85 <= fir_reg_d84;                                                                 
            taps_x_fir_reg(84)           <= fir_reg_d84(84) *  taps(84);                                                 
            taps_x_fir_reg_accu(84)      <= taps_x_fir_reg(84) + taps_x_fir_reg_accu(83);                                    
            taps_x_fir_reg_accu_en(84)   <= taps_x_fir_reg_accu_en(83);                                  
                                                                                                         
            fir_reg_d86 <= fir_reg_d85;                                                                 
            taps_x_fir_reg(85)           <= fir_reg_d85(85) *  taps(85);                                                 
            taps_x_fir_reg_accu(85)      <= taps_x_fir_reg(85) + taps_x_fir_reg_accu(84);                                    
            taps_x_fir_reg_accu_en(85)   <= taps_x_fir_reg_accu_en(84);                                  
                                                                                                         
            fir_reg_d87 <= fir_reg_d86;                                                                 
            taps_x_fir_reg(86)           <= fir_reg_d86(86) *  taps(86);                                                 
            taps_x_fir_reg_accu(86)      <= taps_x_fir_reg(86) + taps_x_fir_reg_accu(85);                                    
            taps_x_fir_reg_accu_en(86)   <= taps_x_fir_reg_accu_en(85);                                  
                                                                                                         
            fir_reg_d88 <= fir_reg_d87;                                                                 
            taps_x_fir_reg(87)           <= fir_reg_d87(87) *  taps(87);                                                 
            taps_x_fir_reg_accu(87)      <= taps_x_fir_reg(87) + taps_x_fir_reg_accu(86);                                    
            taps_x_fir_reg_accu_en(87)   <= taps_x_fir_reg_accu_en(86);                                  
                                                                                                         
            fir_reg_d89 <= fir_reg_d88;                                                                 
            taps_x_fir_reg(88)           <= fir_reg_d88(88) *  taps(88);                                                 
            taps_x_fir_reg_accu(88)      <= taps_x_fir_reg(88) + taps_x_fir_reg_accu(87);                                    
            taps_x_fir_reg_accu_en(88)   <= taps_x_fir_reg_accu_en(87);                                  
                                                                                                         
            fir_reg_d90 <= fir_reg_d89;                                                                 
            taps_x_fir_reg(89)           <= fir_reg_d89(89) *  taps(89);                                                 
            taps_x_fir_reg_accu(89)      <= taps_x_fir_reg(89) + taps_x_fir_reg_accu(88);                                    
            taps_x_fir_reg_accu_en(89)   <= taps_x_fir_reg_accu_en(88);                                  
                                                                                                         
            fir_reg_d91 <= fir_reg_d90;                                                                 
            taps_x_fir_reg(90)           <= fir_reg_d90(90) *  taps(90);                                                 
            taps_x_fir_reg_accu(90)      <= taps_x_fir_reg(90) + taps_x_fir_reg_accu(89);                                    
            taps_x_fir_reg_accu_en(90)   <= taps_x_fir_reg_accu_en(89);                                  
                                                                                                         
            fir_reg_d92 <= fir_reg_d91;                                                                 
            taps_x_fir_reg(91)           <= fir_reg_d91(91) *  taps(91);                                                 
            taps_x_fir_reg_accu(91)      <= taps_x_fir_reg(91) + taps_x_fir_reg_accu(90);                                    
            taps_x_fir_reg_accu_en(91)   <= taps_x_fir_reg_accu_en(90);                                  
                                                                                                         
            fir_reg_d93 <= fir_reg_d92;                                                                 
            taps_x_fir_reg(92)           <= fir_reg_d92(92) *  taps(92);                                                 
            taps_x_fir_reg_accu(92)      <= taps_x_fir_reg(92) + taps_x_fir_reg_accu(91);                                    
            taps_x_fir_reg_accu_en(92)   <= taps_x_fir_reg_accu_en(91);                                  
                                                                                                         
            fir_reg_d94 <= fir_reg_d93;                                                                 
            taps_x_fir_reg(93)           <= fir_reg_d93(93) *  taps(93);                                                 
            taps_x_fir_reg_accu(93)      <= taps_x_fir_reg(93) + taps_x_fir_reg_accu(92);                                    
            taps_x_fir_reg_accu_en(93)   <= taps_x_fir_reg_accu_en(92);                                  
                                                                                                         
            fir_reg_d95 <= fir_reg_d94;                                                                 
            taps_x_fir_reg(94)           <= fir_reg_d94(94) *  taps(94);                                                 
            taps_x_fir_reg_accu(94)      <= taps_x_fir_reg(94) + taps_x_fir_reg_accu(93);                                    
            taps_x_fir_reg_accu_en(94)   <= taps_x_fir_reg_accu_en(93);                                  
                                                                                                         
            fir_reg_d96 <= fir_reg_d95;                                                                 
            taps_x_fir_reg(95)           <= fir_reg_d95(95) *  taps(95);                                                 
            taps_x_fir_reg_accu(95)      <= taps_x_fir_reg(95) + taps_x_fir_reg_accu(94);                                    
            taps_x_fir_reg_accu_en(95)   <= taps_x_fir_reg_accu_en(94);                                  
                                                                                                         
            fir_reg_d97 <= fir_reg_d96;                                                                 
            taps_x_fir_reg(96)           <= fir_reg_d96(96) *  taps(96);                                                 
            taps_x_fir_reg_accu(96)      <= taps_x_fir_reg(96) + taps_x_fir_reg_accu(95);                                    
            taps_x_fir_reg_accu_en(96)   <= taps_x_fir_reg_accu_en(95);                                  
                                                                                                         
            fir_reg_d98 <= fir_reg_d97;                                                                 
            taps_x_fir_reg(97)           <= fir_reg_d97(97) *  taps(97);                                                 
            taps_x_fir_reg_accu(97)      <= taps_x_fir_reg(97) + taps_x_fir_reg_accu(96);                                    
            taps_x_fir_reg_accu_en(97)   <= taps_x_fir_reg_accu_en(96);                                  
                                                                                                         
            fir_reg_d99 <= fir_reg_d98;                                                                 
            taps_x_fir_reg(98)           <= fir_reg_d98(98) *  taps(98);                                                 
            taps_x_fir_reg_accu(98)      <= taps_x_fir_reg(98) + taps_x_fir_reg_accu(97);                                    
            taps_x_fir_reg_accu_en(98)   <= taps_x_fir_reg_accu_en(97);                                  
                                                                                                         
            fir_reg_d100 <= fir_reg_d99;                                                                 
            taps_x_fir_reg(99)           <= fir_reg_d99(99) *  taps(99);                                                 
            taps_x_fir_reg_accu(99)      <= taps_x_fir_reg(99) + taps_x_fir_reg_accu(98);                                    
            taps_x_fir_reg_accu_en(99)   <= taps_x_fir_reg_accu_en(98);                                  
                                                                                                         
            fir_reg_d101 <= fir_reg_d100;                                                                 
            taps_x_fir_reg(100)           <= fir_reg_d100(100) *  taps(100);                                                 
            taps_x_fir_reg_accu(100)      <= taps_x_fir_reg(100) + taps_x_fir_reg_accu(99);                                    
            taps_x_fir_reg_accu_en(100)   <= taps_x_fir_reg_accu_en(99);                                  
                                                                                                         
            fir_reg_d102 <= fir_reg_d101;                                                                 
            taps_x_fir_reg(101)           <= fir_reg_d101(101) *  taps(101);                                                 
            taps_x_fir_reg_accu(101)      <= taps_x_fir_reg(101) + taps_x_fir_reg_accu(100);                                    
            taps_x_fir_reg_accu_en(101)   <= taps_x_fir_reg_accu_en(100);                                  
                                                                                                         
            fir_reg_d103 <= fir_reg_d102;                                                                 
            taps_x_fir_reg(102)           <= fir_reg_d102(102) *  taps(102);                                                 
            taps_x_fir_reg_accu(102)      <= taps_x_fir_reg(102) + taps_x_fir_reg_accu(101);                                    
            taps_x_fir_reg_accu_en(102)   <= taps_x_fir_reg_accu_en(101);                                  
                                                                                                         
            fir_reg_d104 <= fir_reg_d103;                                                                 
            taps_x_fir_reg(103)           <= fir_reg_d103(103) *  taps(103);                                                 
            taps_x_fir_reg_accu(103)      <= taps_x_fir_reg(103) + taps_x_fir_reg_accu(102);                                    
            taps_x_fir_reg_accu_en(103)   <= taps_x_fir_reg_accu_en(102);                                  
                                                                                                         
            fir_reg_d105 <= fir_reg_d104;                                                                 
            taps_x_fir_reg(104)           <= fir_reg_d104(104) *  taps(104);                                                 
            taps_x_fir_reg_accu(104)      <= taps_x_fir_reg(104) + taps_x_fir_reg_accu(103);                                    
            taps_x_fir_reg_accu_en(104)   <= taps_x_fir_reg_accu_en(103);                                  
                                                                                                         
            fir_reg_d106 <= fir_reg_d105;                                                                 
            taps_x_fir_reg(105)           <= fir_reg_d105(105) *  taps(105);                                                 
            taps_x_fir_reg_accu(105)      <= taps_x_fir_reg(105) + taps_x_fir_reg_accu(104);                                    
            taps_x_fir_reg_accu_en(105)   <= taps_x_fir_reg_accu_en(104);                                  
                                                                                                         
            fir_reg_d107 <= fir_reg_d106;                                                                 
            taps_x_fir_reg(106)           <= fir_reg_d106(106) *  taps(106);                                                 
            taps_x_fir_reg_accu(106)      <= taps_x_fir_reg(106) + taps_x_fir_reg_accu(105);                                    
            taps_x_fir_reg_accu_en(106)   <= taps_x_fir_reg_accu_en(105);                                  
                                                                                                         
            fir_reg_d108 <= fir_reg_d107;                                                                 
            taps_x_fir_reg(107)           <= fir_reg_d107(107) *  taps(107);                                                 
            taps_x_fir_reg_accu(107)      <= taps_x_fir_reg(107) + taps_x_fir_reg_accu(106);                                    
            taps_x_fir_reg_accu_en(107)   <= taps_x_fir_reg_accu_en(106);                                  
                                                                                                         
            fir_reg_d109 <= fir_reg_d108;                                                                 
            taps_x_fir_reg(108)           <= fir_reg_d108(108) *  taps(108);                                                 
            taps_x_fir_reg_accu(108)      <= taps_x_fir_reg(108) + taps_x_fir_reg_accu(107);                                    
            taps_x_fir_reg_accu_en(108)   <= taps_x_fir_reg_accu_en(107);                                  
                                                                                                         
            fir_reg_d110 <= fir_reg_d109;                                                                 
            taps_x_fir_reg(109)           <= fir_reg_d109(109) *  taps(109);                                                 
            taps_x_fir_reg_accu(109)      <= taps_x_fir_reg(109) + taps_x_fir_reg_accu(108);                                    
            taps_x_fir_reg_accu_en(109)   <= taps_x_fir_reg_accu_en(108);                                  
                                                                                                         
            fir_reg_d111 <= fir_reg_d110;                                                                 
            taps_x_fir_reg(110)           <= fir_reg_d110(110) *  taps(110);                                                 
            taps_x_fir_reg_accu(110)      <= taps_x_fir_reg(110) + taps_x_fir_reg_accu(109);                                    
            taps_x_fir_reg_accu_en(110)   <= taps_x_fir_reg_accu_en(109);                                  
                                                                                                         
            fir_reg_d112 <= fir_reg_d111;                                                                 
            taps_x_fir_reg(111)           <= fir_reg_d111(111) *  taps(111);                                                 
            taps_x_fir_reg_accu(111)      <= taps_x_fir_reg(111) + taps_x_fir_reg_accu(110);                                    
            taps_x_fir_reg_accu_en(111)   <= taps_x_fir_reg_accu_en(110);                                  
                                                                                                         
            fir_reg_d113 <= fir_reg_d112;                                                                 
            taps_x_fir_reg(112)           <= fir_reg_d112(112) *  taps(112);                                                 
            taps_x_fir_reg_accu(112)      <= taps_x_fir_reg(112) + taps_x_fir_reg_accu(111);                                    
            taps_x_fir_reg_accu_en(112)   <= taps_x_fir_reg_accu_en(111);                                  
                                                                                                         
            fir_reg_d114 <= fir_reg_d113;                                                                 
            taps_x_fir_reg(113)           <= fir_reg_d113(113) *  taps(113);                                                 
            taps_x_fir_reg_accu(113)      <= taps_x_fir_reg(113) + taps_x_fir_reg_accu(112);                                    
            taps_x_fir_reg_accu_en(113)   <= taps_x_fir_reg_accu_en(112);                                  
                                                                                                         
            fir_reg_d115 <= fir_reg_d114;                                                                 
            taps_x_fir_reg(114)           <= fir_reg_d114(114) *  taps(114);                                                 
            taps_x_fir_reg_accu(114)      <= taps_x_fir_reg(114) + taps_x_fir_reg_accu(113);                                    
            taps_x_fir_reg_accu_en(114)   <= taps_x_fir_reg_accu_en(113);                                  
                                                                                                         
            fir_reg_d116 <= fir_reg_d115;                                                                 
            taps_x_fir_reg(115)           <= fir_reg_d115(115) *  taps(115);                                                 
            taps_x_fir_reg_accu(115)      <= taps_x_fir_reg(115) + taps_x_fir_reg_accu(114);                                    
            taps_x_fir_reg_accu_en(115)   <= taps_x_fir_reg_accu_en(114);                                  
                                                                                                         
            fir_reg_d117 <= fir_reg_d116;                                                                 
            taps_x_fir_reg(116)           <= fir_reg_d116(116) *  taps(116);                                                 
            taps_x_fir_reg_accu(116)      <= taps_x_fir_reg(116) + taps_x_fir_reg_accu(115);                                    
            taps_x_fir_reg_accu_en(116)   <= taps_x_fir_reg_accu_en(115);                                  
                                                                                                         
            fir_reg_d118 <= fir_reg_d117;                                                                 
            taps_x_fir_reg(117)           <= fir_reg_d117(117) *  taps(117);                                                 
            taps_x_fir_reg_accu(117)      <= taps_x_fir_reg(117) + taps_x_fir_reg_accu(116);                                    
            taps_x_fir_reg_accu_en(117)   <= taps_x_fir_reg_accu_en(116);                                  
                                                                                                         
            fir_reg_d119 <= fir_reg_d118;                                                                 
            taps_x_fir_reg(118)           <= fir_reg_d118(118) *  taps(118);                                                 
            taps_x_fir_reg_accu(118)      <= taps_x_fir_reg(118) + taps_x_fir_reg_accu(117);                                    
            taps_x_fir_reg_accu_en(118)   <= taps_x_fir_reg_accu_en(117);                                  
                                                                                                         
            fir_reg_d120 <= fir_reg_d119;                                                                 
            taps_x_fir_reg(119)           <= fir_reg_d119(119) *  taps(119);                                                 
            taps_x_fir_reg_accu(119)      <= taps_x_fir_reg(119) + taps_x_fir_reg_accu(118);                                    
            taps_x_fir_reg_accu_en(119)   <= taps_x_fir_reg_accu_en(118);                                  
                                                                                                         
            fir_reg_d121 <= fir_reg_d120;                                                                 
            taps_x_fir_reg(120)           <= fir_reg_d120(120) *  taps(120);                                                 
            taps_x_fir_reg_accu(120)      <= taps_x_fir_reg(120) + taps_x_fir_reg_accu(119);                                    
            taps_x_fir_reg_accu_en(120)   <= taps_x_fir_reg_accu_en(119);                                  
                                                                                                         
            fir_reg_d122 <= fir_reg_d121;                                                                 
            taps_x_fir_reg(121)           <= fir_reg_d121(121) *  taps(121);                                                 
            taps_x_fir_reg_accu(121)      <= taps_x_fir_reg(121) + taps_x_fir_reg_accu(120);                                    
            taps_x_fir_reg_accu_en(121)   <= taps_x_fir_reg_accu_en(120);                                  
                                                                                                         
            fir_reg_d123 <= fir_reg_d122;                                                                 
            taps_x_fir_reg(122)           <= fir_reg_d122(122) *  taps(122);                                                 
            taps_x_fir_reg_accu(122)      <= taps_x_fir_reg(122) + taps_x_fir_reg_accu(121);                                    
            taps_x_fir_reg_accu_en(122)   <= taps_x_fir_reg_accu_en(121);                                  
                                                                                                         
            fir_reg_d124 <= fir_reg_d123;                                                                 
            taps_x_fir_reg(123)           <= fir_reg_d123(123) *  taps(123);                                                 
            taps_x_fir_reg_accu(123)      <= taps_x_fir_reg(123) + taps_x_fir_reg_accu(122);                                    
            taps_x_fir_reg_accu_en(123)   <= taps_x_fir_reg_accu_en(122);                                  
                                                                                                         
            fir_reg_d125 <= fir_reg_d124;                                                                 
            taps_x_fir_reg(124)           <= fir_reg_d124(124) *  taps(124);                                                 
            taps_x_fir_reg_accu(124)      <= taps_x_fir_reg(124) + taps_x_fir_reg_accu(123);                                    
            taps_x_fir_reg_accu_en(124)   <= taps_x_fir_reg_accu_en(123);                                  
                                                                                                         
            fir_reg_d126 <= fir_reg_d125;                                                                 
            taps_x_fir_reg(125)           <= fir_reg_d125(125) *  taps(125);                                                 
            taps_x_fir_reg_accu(125)      <= taps_x_fir_reg(125) + taps_x_fir_reg_accu(124);                                    
            taps_x_fir_reg_accu_en(125)   <= taps_x_fir_reg_accu_en(124);                                  
                                                                                                         
            fir_reg_d127 <= fir_reg_d126;                                                                 
            taps_x_fir_reg(126)           <= fir_reg_d126(126) *  taps(126);                                                 
            taps_x_fir_reg_accu(126)      <= taps_x_fir_reg(126) + taps_x_fir_reg_accu(125);                                    
            taps_x_fir_reg_accu_en(126)   <= taps_x_fir_reg_accu_en(125);                                  
                                                                                                         
            fir_reg_d128 <= fir_reg_d127;                                                                 
            taps_x_fir_reg(127)           <= fir_reg_d127(127) *  taps(127);                                                 
            taps_x_fir_reg_accu(127)      <= taps_x_fir_reg(127) + taps_x_fir_reg_accu(126);                                    
            taps_x_fir_reg_accu_en(127)   <= taps_x_fir_reg_accu_en(126);                                  
                                                                                                         
            fir_reg_d129 <= fir_reg_d128;                                                                 
            taps_x_fir_reg(128)           <= fir_reg_d128(128) *  taps(128);                                                 
            taps_x_fir_reg_accu(128)      <= taps_x_fir_reg(128) + taps_x_fir_reg_accu(127);                                    
            taps_x_fir_reg_accu_en(128)   <= taps_x_fir_reg_accu_en(127);                                  
                                                                                                         
            fir_reg_d130 <= fir_reg_d129;                                                                 
            taps_x_fir_reg(129)           <= fir_reg_d129(129) *  taps(129);                                                 
            taps_x_fir_reg_accu(129)      <= taps_x_fir_reg(129) + taps_x_fir_reg_accu(128);                                    
            taps_x_fir_reg_accu_en(129)   <= taps_x_fir_reg_accu_en(128);                                  
                                                                                                         
            fir_reg_d131 <= fir_reg_d130;                                                                 
            taps_x_fir_reg(130)           <= fir_reg_d130(130) *  taps(130);                                                 
            taps_x_fir_reg_accu(130)      <= taps_x_fir_reg(130) + taps_x_fir_reg_accu(129);                                    
            taps_x_fir_reg_accu_en(130)   <= taps_x_fir_reg_accu_en(129);                                  
                                                                                                         
            fir_reg_d132 <= fir_reg_d131;                                                                 
            taps_x_fir_reg(131)           <= fir_reg_d131(131) *  taps(131);                                                 
            taps_x_fir_reg_accu(131)      <= taps_x_fir_reg(131) + taps_x_fir_reg_accu(130);                                    
            taps_x_fir_reg_accu_en(131)   <= taps_x_fir_reg_accu_en(130);                                  
                                                                                                         
            fir_reg_d133 <= fir_reg_d132;                                                                 
            taps_x_fir_reg(132)           <= fir_reg_d132(132) *  taps(132);                                                 
            taps_x_fir_reg_accu(132)      <= taps_x_fir_reg(132) + taps_x_fir_reg_accu(131);                                    
            taps_x_fir_reg_accu_en(132)   <= taps_x_fir_reg_accu_en(131);                                  
                                                                                                         
            fir_reg_d134 <= fir_reg_d133;                                                                 
            taps_x_fir_reg(133)           <= fir_reg_d133(133) *  taps(133);                                                 
            taps_x_fir_reg_accu(133)      <= taps_x_fir_reg(133) + taps_x_fir_reg_accu(132);                                    
            taps_x_fir_reg_accu_en(133)   <= taps_x_fir_reg_accu_en(132);                                  
                                                                                                         
            fir_reg_d135 <= fir_reg_d134;                                                                 
            taps_x_fir_reg(134)           <= fir_reg_d134(134) *  taps(134);                                                 
            taps_x_fir_reg_accu(134)      <= taps_x_fir_reg(134) + taps_x_fir_reg_accu(133);                                    
            taps_x_fir_reg_accu_en(134)   <= taps_x_fir_reg_accu_en(133);                                  
                                                                                                         
            fir_reg_d136 <= fir_reg_d135;                                                                 
            taps_x_fir_reg(135)           <= fir_reg_d135(135) *  taps(135);                                                 
            taps_x_fir_reg_accu(135)      <= taps_x_fir_reg(135) + taps_x_fir_reg_accu(134);                                    
            taps_x_fir_reg_accu_en(135)   <= taps_x_fir_reg_accu_en(134);                                  
                                                                                                         
            fir_reg_d137 <= fir_reg_d136;                                                                 
            taps_x_fir_reg(136)           <= fir_reg_d136(136) *  taps(136);                                                 
            taps_x_fir_reg_accu(136)      <= taps_x_fir_reg(136) + taps_x_fir_reg_accu(135);                                    
            taps_x_fir_reg_accu_en(136)   <= taps_x_fir_reg_accu_en(135);                                  
                                                                                                         
            fir_reg_d138 <= fir_reg_d137;                                                                 
            taps_x_fir_reg(137)           <= fir_reg_d137(137) *  taps(137);                                                 
            taps_x_fir_reg_accu(137)      <= taps_x_fir_reg(137) + taps_x_fir_reg_accu(136);                                    
            taps_x_fir_reg_accu_en(137)   <= taps_x_fir_reg_accu_en(136);                                  
                                                                                                         
            fir_reg_d139 <= fir_reg_d138;                                                                 
            taps_x_fir_reg(138)           <= fir_reg_d138(138) *  taps(138);                                                 
            taps_x_fir_reg_accu(138)      <= taps_x_fir_reg(138) + taps_x_fir_reg_accu(137);                                    
            taps_x_fir_reg_accu_en(138)   <= taps_x_fir_reg_accu_en(137);                                  
                                                                                                         
            fir_reg_d140 <= fir_reg_d139;                                                                 
            taps_x_fir_reg(139)           <= fir_reg_d139(139) *  taps(139);                                                 
            taps_x_fir_reg_accu(139)      <= taps_x_fir_reg(139) + taps_x_fir_reg_accu(138);                                    
            taps_x_fir_reg_accu_en(139)   <= taps_x_fir_reg_accu_en(138);                                  
                                                                                                         
            fir_reg_d141 <= fir_reg_d140;                                                                 
            taps_x_fir_reg(140)           <= fir_reg_d140(140) *  taps(140);                                                 
            taps_x_fir_reg_accu(140)      <= taps_x_fir_reg(140) + taps_x_fir_reg_accu(139);                                    
            taps_x_fir_reg_accu_en(140)   <= taps_x_fir_reg_accu_en(139);                                  
                                                                                                         
            fir_reg_d142 <= fir_reg_d141;                                                                 
            taps_x_fir_reg(141)           <= fir_reg_d141(141) *  taps(141);                                                 
            taps_x_fir_reg_accu(141)      <= taps_x_fir_reg(141) + taps_x_fir_reg_accu(140);                                    
            taps_x_fir_reg_accu_en(141)   <= taps_x_fir_reg_accu_en(140);                                  
                                                                                                         
            fir_reg_d143 <= fir_reg_d142;                                                                 
            taps_x_fir_reg(142)           <= fir_reg_d142(142) *  taps(142);                                                 
            taps_x_fir_reg_accu(142)      <= taps_x_fir_reg(142) + taps_x_fir_reg_accu(141);                                    
            taps_x_fir_reg_accu_en(142)   <= taps_x_fir_reg_accu_en(141);                                  
                                                                                                         
            fir_reg_d144 <= fir_reg_d143;                                                                 
            taps_x_fir_reg(143)           <= fir_reg_d143(143) *  taps(143);                                                 
            taps_x_fir_reg_accu(143)      <= taps_x_fir_reg(143) + taps_x_fir_reg_accu(142);                                    
            taps_x_fir_reg_accu_en(143)   <= taps_x_fir_reg_accu_en(142);                                  
                                                                                                         
            fir_reg_d145 <= fir_reg_d144;                                                                 
            taps_x_fir_reg(144)           <= fir_reg_d144(144) *  taps(144);                                                 
            taps_x_fir_reg_accu(144)      <= taps_x_fir_reg(144) + taps_x_fir_reg_accu(143);                                    
            taps_x_fir_reg_accu_en(144)   <= taps_x_fir_reg_accu_en(143);                                  
                                                                                                         
            fir_reg_d146 <= fir_reg_d145;                                                                 
            taps_x_fir_reg(145)           <= fir_reg_d145(145) *  taps(145);                                                 
            taps_x_fir_reg_accu(145)      <= taps_x_fir_reg(145) + taps_x_fir_reg_accu(144);                                    
            taps_x_fir_reg_accu_en(145)   <= taps_x_fir_reg_accu_en(144);                                  
                                                                                                         
            fir_reg_d147 <= fir_reg_d146;                                                                 
            taps_x_fir_reg(146)           <= fir_reg_d146(146) *  taps(146);                                                 
            taps_x_fir_reg_accu(146)      <= taps_x_fir_reg(146) + taps_x_fir_reg_accu(145);                                    
            taps_x_fir_reg_accu_en(146)   <= taps_x_fir_reg_accu_en(145);                                  
                                                                                                         
            fir_reg_d148 <= fir_reg_d147;                                                                 
            taps_x_fir_reg(147)           <= fir_reg_d147(147) *  taps(147);                                                 
            taps_x_fir_reg_accu(147)      <= taps_x_fir_reg(147) + taps_x_fir_reg_accu(146);                                    
            taps_x_fir_reg_accu_en(147)   <= taps_x_fir_reg_accu_en(146);                                  
                                                                                                         
            fir_reg_d149 <= fir_reg_d148;                                                                 
            taps_x_fir_reg(148)           <= fir_reg_d148(148) *  taps(148);                                                 
            taps_x_fir_reg_accu(148)      <= taps_x_fir_reg(148) + taps_x_fir_reg_accu(147);                                    
            taps_x_fir_reg_accu_en(148)   <= taps_x_fir_reg_accu_en(147);                                  
                                                                                                         
            fir_reg_d150 <= fir_reg_d149;                                                                 
            taps_x_fir_reg(149)           <= fir_reg_d149(149) *  taps(149);                                                 
            taps_x_fir_reg_accu(149)      <= taps_x_fir_reg(149) + taps_x_fir_reg_accu(148);                                    
            taps_x_fir_reg_accu_en(149)   <= taps_x_fir_reg_accu_en(148);                                  
                                                                                                         
            fir_reg_d151 <= fir_reg_d150;                                                                 
            taps_x_fir_reg(150)           <= fir_reg_d150(150) *  taps(150);                                                 
            taps_x_fir_reg_accu(150)      <= taps_x_fir_reg(150) + taps_x_fir_reg_accu(149);                                    
            taps_x_fir_reg_accu_en(150)   <= taps_x_fir_reg_accu_en(149);                                  
                                                                                                         
            fir_reg_d152 <= fir_reg_d151;                                                                 
            taps_x_fir_reg(151)           <= fir_reg_d151(151) *  taps(151);                                                 
            taps_x_fir_reg_accu(151)      <= taps_x_fir_reg(151) + taps_x_fir_reg_accu(150);                                    
            taps_x_fir_reg_accu_en(151)   <= taps_x_fir_reg_accu_en(150);                                  
                                                                                                         
            fir_reg_d153 <= fir_reg_d152;                                                                 
            taps_x_fir_reg(152)           <= fir_reg_d152(152) *  taps(152);                                                 
            taps_x_fir_reg_accu(152)      <= taps_x_fir_reg(152) + taps_x_fir_reg_accu(151);                                    
            taps_x_fir_reg_accu_en(152)   <= taps_x_fir_reg_accu_en(151);                                  
                                                                                                         
            fir_reg_d154 <= fir_reg_d153;                                                                 
            taps_x_fir_reg(153)           <= fir_reg_d153(153) *  taps(153);                                                 
            taps_x_fir_reg_accu(153)      <= taps_x_fir_reg(153) + taps_x_fir_reg_accu(152);                                    
            taps_x_fir_reg_accu_en(153)   <= taps_x_fir_reg_accu_en(152);                                  
                                                                                                         
            fir_reg_d155 <= fir_reg_d154;                                                                 
            taps_x_fir_reg(154)           <= fir_reg_d154(154) *  taps(154);                                                 
            taps_x_fir_reg_accu(154)      <= taps_x_fir_reg(154) + taps_x_fir_reg_accu(153);                                    
            taps_x_fir_reg_accu_en(154)   <= taps_x_fir_reg_accu_en(153);                                  
                                                                                                         
            fir_reg_d156 <= fir_reg_d155;                                                                 
            taps_x_fir_reg(155)           <= fir_reg_d155(155) *  taps(155);                                                 
            taps_x_fir_reg_accu(155)      <= taps_x_fir_reg(155) + taps_x_fir_reg_accu(154);                                    
            taps_x_fir_reg_accu_en(155)   <= taps_x_fir_reg_accu_en(154);                                  
                                                                                                         
            fir_reg_d157 <= fir_reg_d156;                                                                 
            taps_x_fir_reg(156)           <= fir_reg_d156(156) *  taps(156);                                                 
            taps_x_fir_reg_accu(156)      <= taps_x_fir_reg(156) + taps_x_fir_reg_accu(155);                                    
            taps_x_fir_reg_accu_en(156)   <= taps_x_fir_reg_accu_en(155);                                  
                                                                                                         
            fir_reg_d158 <= fir_reg_d157;                                                                 
            taps_x_fir_reg(157)           <= fir_reg_d157(157) *  taps(157);                                                 
            taps_x_fir_reg_accu(157)      <= taps_x_fir_reg(157) + taps_x_fir_reg_accu(156);                                    
            taps_x_fir_reg_accu_en(157)   <= taps_x_fir_reg_accu_en(156);                                  
                                                                                                         
            fir_reg_d159 <= fir_reg_d158;                                                                 
            taps_x_fir_reg(158)           <= fir_reg_d158(158) *  taps(158);                                                 
            taps_x_fir_reg_accu(158)      <= taps_x_fir_reg(158) + taps_x_fir_reg_accu(157);                                    
            taps_x_fir_reg_accu_en(158)   <= taps_x_fir_reg_accu_en(157);                                  
                                                                                                         
            fir_reg_d160 <= fir_reg_d159;                                                                 
            taps_x_fir_reg(159)           <= fir_reg_d159(159) *  taps(159);                                                 
            taps_x_fir_reg_accu(159)      <= taps_x_fir_reg(159) + taps_x_fir_reg_accu(158);                                    
            taps_x_fir_reg_accu_en(159)   <= taps_x_fir_reg_accu_en(158);                                  
                                                                                                         
            fir_reg_d161 <= fir_reg_d160;                                                                 
            taps_x_fir_reg(160)           <= fir_reg_d160(160) *  taps(160);                                                 
            taps_x_fir_reg_accu(160)      <= taps_x_fir_reg(160) + taps_x_fir_reg_accu(159);                                    
            taps_x_fir_reg_accu_en(160)   <= taps_x_fir_reg_accu_en(159);                                  
                                                                                                         
            fir_reg_d162 <= fir_reg_d161;                                                                 
            taps_x_fir_reg(161)           <= fir_reg_d161(161) *  taps(161);                                                 
            taps_x_fir_reg_accu(161)      <= taps_x_fir_reg(161) + taps_x_fir_reg_accu(160);                                    
            taps_x_fir_reg_accu_en(161)   <= taps_x_fir_reg_accu_en(160);                                  
                                                                                                         
            fir_reg_d163 <= fir_reg_d162;                                                                 
            taps_x_fir_reg(162)           <= fir_reg_d162(162) *  taps(162);                                                 
            taps_x_fir_reg_accu(162)      <= taps_x_fir_reg(162) + taps_x_fir_reg_accu(161);                                    
            taps_x_fir_reg_accu_en(162)   <= taps_x_fir_reg_accu_en(161);                                  
                                                                                                         
            fir_reg_d164 <= fir_reg_d163;                                                                 
            taps_x_fir_reg(163)           <= fir_reg_d163(163) *  taps(163);                                                 
            taps_x_fir_reg_accu(163)      <= taps_x_fir_reg(163) + taps_x_fir_reg_accu(162);                                    
            taps_x_fir_reg_accu_en(163)   <= taps_x_fir_reg_accu_en(162);                                  
                                                                                                         
            fir_reg_d165 <= fir_reg_d164;                                                                 
            taps_x_fir_reg(164)           <= fir_reg_d164(164) *  taps(164);                                                 
            taps_x_fir_reg_accu(164)      <= taps_x_fir_reg(164) + taps_x_fir_reg_accu(163);                                    
            taps_x_fir_reg_accu_en(164)   <= taps_x_fir_reg_accu_en(163);                                  
                                                                                                         
            fir_reg_d166 <= fir_reg_d165;                                                                 
            taps_x_fir_reg(165)           <= fir_reg_d165(165) *  taps(165);                                                 
            taps_x_fir_reg_accu(165)      <= taps_x_fir_reg(165) + taps_x_fir_reg_accu(164);                                    
            taps_x_fir_reg_accu_en(165)   <= taps_x_fir_reg_accu_en(164);                                  
                                                                                                         
            fir_reg_d167 <= fir_reg_d166;                                                                 
            taps_x_fir_reg(166)           <= fir_reg_d166(166) *  taps(166);                                                 
            taps_x_fir_reg_accu(166)      <= taps_x_fir_reg(166) + taps_x_fir_reg_accu(165);                                    
            taps_x_fir_reg_accu_en(166)   <= taps_x_fir_reg_accu_en(165);                                  
                                                                                                         
            fir_reg_d168 <= fir_reg_d167;                                                                 
            taps_x_fir_reg(167)           <= fir_reg_d167(167) *  taps(167);                                                 
            taps_x_fir_reg_accu(167)      <= taps_x_fir_reg(167) + taps_x_fir_reg_accu(166);                                    
            taps_x_fir_reg_accu_en(167)   <= taps_x_fir_reg_accu_en(166);                                  
                                                                                                         
            fir_reg_d169 <= fir_reg_d168;                                                                 
            taps_x_fir_reg(168)           <= fir_reg_d168(168) *  taps(168);                                                 
            taps_x_fir_reg_accu(168)      <= taps_x_fir_reg(168) + taps_x_fir_reg_accu(167);                                    
            taps_x_fir_reg_accu_en(168)   <= taps_x_fir_reg_accu_en(167);                                  
                                                                                                         
            fir_reg_d170 <= fir_reg_d169;                                                                 
            taps_x_fir_reg(169)           <= fir_reg_d169(169) *  taps(169);                                                 
            taps_x_fir_reg_accu(169)      <= taps_x_fir_reg(169) + taps_x_fir_reg_accu(168);                                    
            taps_x_fir_reg_accu_en(169)   <= taps_x_fir_reg_accu_en(168);                                  
                                                                                                         
            fir_reg_d171 <= fir_reg_d170;                                                                 
            taps_x_fir_reg(170)           <= fir_reg_d170(170) *  taps(170);                                                 
            taps_x_fir_reg_accu(170)      <= taps_x_fir_reg(170) + taps_x_fir_reg_accu(169);                                    
            taps_x_fir_reg_accu_en(170)   <= taps_x_fir_reg_accu_en(169);                                  
                                                                                                         
            fir_reg_d172 <= fir_reg_d171;                                                                 
            taps_x_fir_reg(171)           <= fir_reg_d171(171) *  taps(171);                                                 
            taps_x_fir_reg_accu(171)      <= taps_x_fir_reg(171) + taps_x_fir_reg_accu(170);                                    
            taps_x_fir_reg_accu_en(171)   <= taps_x_fir_reg_accu_en(170);                                  
                                                                                                         
            fir_reg_d173 <= fir_reg_d172;                                                                 
            taps_x_fir_reg(172)           <= fir_reg_d172(172) *  taps(172);                                                 
            taps_x_fir_reg_accu(172)      <= taps_x_fir_reg(172) + taps_x_fir_reg_accu(171);                                    
            taps_x_fir_reg_accu_en(172)   <= taps_x_fir_reg_accu_en(171);                                  
                                                                                                         
            fir_reg_d174 <= fir_reg_d173;                                                                 
            taps_x_fir_reg(173)           <= fir_reg_d173(173) *  taps(173);                                                 
            taps_x_fir_reg_accu(173)      <= taps_x_fir_reg(173) + taps_x_fir_reg_accu(172);                                    
            taps_x_fir_reg_accu_en(173)   <= taps_x_fir_reg_accu_en(172);                                  
                                                                                                         
            fir_reg_d175 <= fir_reg_d174;                                                                 
            taps_x_fir_reg(174)           <= fir_reg_d174(174) *  taps(174);                                                 
            taps_x_fir_reg_accu(174)      <= taps_x_fir_reg(174) + taps_x_fir_reg_accu(173);                                    
            taps_x_fir_reg_accu_en(174)   <= taps_x_fir_reg_accu_en(173);                                  
                                                                                                         
            fir_reg_d176 <= fir_reg_d175;                                                                 
            taps_x_fir_reg(175)           <= fir_reg_d175(175) *  taps(175);                                                 
            taps_x_fir_reg_accu(175)      <= taps_x_fir_reg(175) + taps_x_fir_reg_accu(174);                                    
            taps_x_fir_reg_accu_en(175)   <= taps_x_fir_reg_accu_en(174);                                  
                                                                                                         
            fir_reg_d177 <= fir_reg_d176;                                                                 
            taps_x_fir_reg(176)           <= fir_reg_d176(176) *  taps(176);                                                 
            taps_x_fir_reg_accu(176)      <= taps_x_fir_reg(176) + taps_x_fir_reg_accu(175);                                    
            taps_x_fir_reg_accu_en(176)   <= taps_x_fir_reg_accu_en(175);                                  
                                                                                                         
            fir_reg_d178 <= fir_reg_d177;                                                                 
            taps_x_fir_reg(177)           <= fir_reg_d177(177) *  taps(177);                                                 
            taps_x_fir_reg_accu(177)      <= taps_x_fir_reg(177) + taps_x_fir_reg_accu(176);                                    
            taps_x_fir_reg_accu_en(177)   <= taps_x_fir_reg_accu_en(176);                                  
                                                                                                         
            fir_reg_d179 <= fir_reg_d178;                                                                 
            taps_x_fir_reg(178)           <= fir_reg_d178(178) *  taps(178);                                                 
            taps_x_fir_reg_accu(178)      <= taps_x_fir_reg(178) + taps_x_fir_reg_accu(177);                                    
            taps_x_fir_reg_accu_en(178)   <= taps_x_fir_reg_accu_en(177);                                  
                                                                                                         
            fir_reg_d180 <= fir_reg_d179;                                                                 
            taps_x_fir_reg(179)           <= fir_reg_d179(179) *  taps(179);                                                 
            taps_x_fir_reg_accu(179)      <= taps_x_fir_reg(179) + taps_x_fir_reg_accu(178);                                    
            taps_x_fir_reg_accu_en(179)   <= taps_x_fir_reg_accu_en(178);                                  
                                                                                                         
            fir_reg_d181 <= fir_reg_d180;                                                                 
            taps_x_fir_reg(180)           <= fir_reg_d180(180) *  taps(180);                                                 
            taps_x_fir_reg_accu(180)      <= taps_x_fir_reg(180) + taps_x_fir_reg_accu(179);                                    
            taps_x_fir_reg_accu_en(180)   <= taps_x_fir_reg_accu_en(179);                                  
                                                                                                         
            fir_reg_d182 <= fir_reg_d181;                                                                 
            taps_x_fir_reg(181)           <= fir_reg_d181(181) *  taps(181);                                                 
            taps_x_fir_reg_accu(181)      <= taps_x_fir_reg(181) + taps_x_fir_reg_accu(180);                                    
            taps_x_fir_reg_accu_en(181)   <= taps_x_fir_reg_accu_en(180);                                  
                                                                                                         
            fir_reg_d183 <= fir_reg_d182;                                                                 
            taps_x_fir_reg(182)           <= fir_reg_d182(182) *  taps(182);                                                 
            taps_x_fir_reg_accu(182)      <= taps_x_fir_reg(182) + taps_x_fir_reg_accu(181);                                    
            taps_x_fir_reg_accu_en(182)   <= taps_x_fir_reg_accu_en(181);                                  
                                                                                                         
            fir_reg_d184 <= fir_reg_d183;                                                                 
            taps_x_fir_reg(183)           <= fir_reg_d183(183) *  taps(183);                                                 
            taps_x_fir_reg_accu(183)      <= taps_x_fir_reg(183) + taps_x_fir_reg_accu(182);                                    
            taps_x_fir_reg_accu_en(183)   <= taps_x_fir_reg_accu_en(182);                                  
                                                                                                         
            fir_reg_d185 <= fir_reg_d184;                                                                 
            taps_x_fir_reg(184)           <= fir_reg_d184(184) *  taps(184);                                                 
            taps_x_fir_reg_accu(184)      <= taps_x_fir_reg(184) + taps_x_fir_reg_accu(183);                                    
            taps_x_fir_reg_accu_en(184)   <= taps_x_fir_reg_accu_en(183);                                  
                                                                                                         
            fir_reg_d186 <= fir_reg_d185;                                                                 
            taps_x_fir_reg(185)           <= fir_reg_d185(185) *  taps(185);                                                 
            taps_x_fir_reg_accu(185)      <= taps_x_fir_reg(185) + taps_x_fir_reg_accu(184);                                    
            taps_x_fir_reg_accu_en(185)   <= taps_x_fir_reg_accu_en(184);                                  
                                                                                                         
            fir_reg_d187 <= fir_reg_d186;                                                                 
            taps_x_fir_reg(186)           <= fir_reg_d186(186) *  taps(186);                                                 
            taps_x_fir_reg_accu(186)      <= taps_x_fir_reg(186) + taps_x_fir_reg_accu(185);                                    
            taps_x_fir_reg_accu_en(186)   <= taps_x_fir_reg_accu_en(185);                                  
                                                                                                         
            fir_reg_d188 <= fir_reg_d187;                                                                 
            taps_x_fir_reg(187)           <= fir_reg_d187(187) *  taps(187);                                                 
            taps_x_fir_reg_accu(187)      <= taps_x_fir_reg(187) + taps_x_fir_reg_accu(186);                                    
            taps_x_fir_reg_accu_en(187)   <= taps_x_fir_reg_accu_en(186);                                  
                                                                                                         
            fir_reg_d189 <= fir_reg_d188;                                                                 
            taps_x_fir_reg(188)           <= fir_reg_d188(188) *  taps(188);                                                 
            taps_x_fir_reg_accu(188)      <= taps_x_fir_reg(188) + taps_x_fir_reg_accu(187);                                    
            taps_x_fir_reg_accu_en(188)   <= taps_x_fir_reg_accu_en(187);                                  
                                                                                                         
            fir_reg_d190 <= fir_reg_d189;                                                                 
            taps_x_fir_reg(189)           <= fir_reg_d189(189) *  taps(189);                                                 
            taps_x_fir_reg_accu(189)      <= taps_x_fir_reg(189) + taps_x_fir_reg_accu(188);                                    
            taps_x_fir_reg_accu_en(189)   <= taps_x_fir_reg_accu_en(188);                                  
                                                                                                         
            fir_reg_d191 <= fir_reg_d190;                                                                 
            taps_x_fir_reg(190)           <= fir_reg_d190(190) *  taps(190);                                                 
            taps_x_fir_reg_accu(190)      <= taps_x_fir_reg(190) + taps_x_fir_reg_accu(189);                                    
            taps_x_fir_reg_accu_en(190)   <= taps_x_fir_reg_accu_en(189);                                  
                                                                                                         
            fir_reg_d192 <= fir_reg_d191;                                                                 
            taps_x_fir_reg(191)           <= fir_reg_d191(191) *  taps(191);                                                 
            taps_x_fir_reg_accu(191)      <= taps_x_fir_reg(191) + taps_x_fir_reg_accu(190);                                    
            taps_x_fir_reg_accu_en(191)   <= taps_x_fir_reg_accu_en(190);                                  
                                                                                                         
            fir_reg_d193 <= fir_reg_d192;                                                                 
            taps_x_fir_reg(192)           <= fir_reg_d192(192) *  taps(192);                                                 
            taps_x_fir_reg_accu(192)      <= taps_x_fir_reg(192) + taps_x_fir_reg_accu(191);                                    
            taps_x_fir_reg_accu_en(192)   <= taps_x_fir_reg_accu_en(191);                                  
                                                                                                         
            fir_reg_d194 <= fir_reg_d193;                                                                 
            taps_x_fir_reg(193)           <= fir_reg_d193(193) *  taps(193);                                                 
            taps_x_fir_reg_accu(193)      <= taps_x_fir_reg(193) + taps_x_fir_reg_accu(192);                                    
            taps_x_fir_reg_accu_en(193)   <= taps_x_fir_reg_accu_en(192);                                  
                                                                                                         
            fir_reg_d195 <= fir_reg_d194;                                                                 
            taps_x_fir_reg(194)           <= fir_reg_d194(194) *  taps(194);                                                 
            taps_x_fir_reg_accu(194)      <= taps_x_fir_reg(194) + taps_x_fir_reg_accu(193);                                    
            taps_x_fir_reg_accu_en(194)   <= taps_x_fir_reg_accu_en(193);                                  
                                                                                                         
            fir_reg_d196 <= fir_reg_d195;                                                                 
            taps_x_fir_reg(195)           <= fir_reg_d195(195) *  taps(195);                                                 
            taps_x_fir_reg_accu(195)      <= taps_x_fir_reg(195) + taps_x_fir_reg_accu(194);                                    
            taps_x_fir_reg_accu_en(195)   <= taps_x_fir_reg_accu_en(194);                                  
                                                                                                         
            fir_reg_d197 <= fir_reg_d196;                                                                 
            taps_x_fir_reg(196)           <= fir_reg_d196(196) *  taps(196);                                                 
            taps_x_fir_reg_accu(196)      <= taps_x_fir_reg(196) + taps_x_fir_reg_accu(195);                                    
            taps_x_fir_reg_accu_en(196)   <= taps_x_fir_reg_accu_en(195);                                  
                                                                                                         
            fir_reg_d198 <= fir_reg_d197;                                                                 
            taps_x_fir_reg(197)           <= fir_reg_d197(197) *  taps(197);                                                 
            taps_x_fir_reg_accu(197)      <= taps_x_fir_reg(197) + taps_x_fir_reg_accu(196);                                    
            taps_x_fir_reg_accu_en(197)   <= taps_x_fir_reg_accu_en(196);                                  
                                                                                                         
            fir_reg_d199 <= fir_reg_d198;                                                                 
            taps_x_fir_reg(198)           <= fir_reg_d198(198) *  taps(198);                                                 
            taps_x_fir_reg_accu(198)      <= taps_x_fir_reg(198) + taps_x_fir_reg_accu(197);                                    
            taps_x_fir_reg_accu_en(198)   <= taps_x_fir_reg_accu_en(197);                                  
                                                                                                         
            fir_reg_d200 <= fir_reg_d199;                                                                 
            taps_x_fir_reg(199)           <= fir_reg_d199(199) *  taps(199);                                                 
            taps_x_fir_reg_accu(199)      <= taps_x_fir_reg(199) + taps_x_fir_reg_accu(198);                                    
            taps_x_fir_reg_accu_en(199)   <= taps_x_fir_reg_accu_en(198);                                  
                                                                                                         
            fir_reg_d201 <= fir_reg_d200;                                                                 
            taps_x_fir_reg(200)           <= fir_reg_d200(200) *  taps(200);                                                 
            taps_x_fir_reg_accu(200)      <= taps_x_fir_reg(200) + taps_x_fir_reg_accu(199);                                    
            taps_x_fir_reg_accu_en(200)   <= taps_x_fir_reg_accu_en(199);                                  
                                                                                                         
            fir_reg_d202 <= fir_reg_d201;                                                                 
            taps_x_fir_reg(201)           <= fir_reg_d201(201) *  taps(201);                                                 
            taps_x_fir_reg_accu(201)      <= taps_x_fir_reg(201) + taps_x_fir_reg_accu(200);                                    
            taps_x_fir_reg_accu_en(201)   <= taps_x_fir_reg_accu_en(200);                                  
                                                                                                         
            fir_reg_d203 <= fir_reg_d202;                                                                 
            taps_x_fir_reg(202)           <= fir_reg_d202(202) *  taps(202);                                                 
            taps_x_fir_reg_accu(202)      <= taps_x_fir_reg(202) + taps_x_fir_reg_accu(201);                                    
            taps_x_fir_reg_accu_en(202)   <= taps_x_fir_reg_accu_en(201);                                  
                                                                                                         
            fir_reg_d204 <= fir_reg_d203;                                                                 
            taps_x_fir_reg(203)           <= fir_reg_d203(203) *  taps(203);                                                 
            taps_x_fir_reg_accu(203)      <= taps_x_fir_reg(203) + taps_x_fir_reg_accu(202);                                    
            taps_x_fir_reg_accu_en(203)   <= taps_x_fir_reg_accu_en(202);                                  
                                                                                                         
            fir_reg_d205 <= fir_reg_d204;                                                                 
            taps_x_fir_reg(204)           <= fir_reg_d204(204) *  taps(204);                                                 
            taps_x_fir_reg_accu(204)      <= taps_x_fir_reg(204) + taps_x_fir_reg_accu(203);                                    
            taps_x_fir_reg_accu_en(204)   <= taps_x_fir_reg_accu_en(203);                                  
                                                                                                         
            fir_reg_d206 <= fir_reg_d205;                                                                 
            taps_x_fir_reg(205)           <= fir_reg_d205(205) *  taps(205);                                                 
            taps_x_fir_reg_accu(205)      <= taps_x_fir_reg(205) + taps_x_fir_reg_accu(204);                                    
            taps_x_fir_reg_accu_en(205)   <= taps_x_fir_reg_accu_en(204);                                  
                                                                                                         
            fir_reg_d207 <= fir_reg_d206;                                                                 
            taps_x_fir_reg(206)           <= fir_reg_d206(206) *  taps(206);                                                 
            taps_x_fir_reg_accu(206)      <= taps_x_fir_reg(206) + taps_x_fir_reg_accu(205);                                    
            taps_x_fir_reg_accu_en(206)   <= taps_x_fir_reg_accu_en(205);                                  
                                                                                                         
            fir_reg_d208 <= fir_reg_d207;                                                                 
            taps_x_fir_reg(207)           <= fir_reg_d207(207) *  taps(207);                                                 
            taps_x_fir_reg_accu(207)      <= taps_x_fir_reg(207) + taps_x_fir_reg_accu(206);                                    
            taps_x_fir_reg_accu_en(207)   <= taps_x_fir_reg_accu_en(206);                                  
                                                                                                         
            fir_reg_d209 <= fir_reg_d208;                                                                 
            taps_x_fir_reg(208)           <= fir_reg_d208(208) *  taps(208);                                                 
            taps_x_fir_reg_accu(208)      <= taps_x_fir_reg(208) + taps_x_fir_reg_accu(207);                                    
            taps_x_fir_reg_accu_en(208)   <= taps_x_fir_reg_accu_en(207);                                  
                                                                                                         
            fir_reg_d210 <= fir_reg_d209;                                                                 
            taps_x_fir_reg(209)           <= fir_reg_d209(209) *  taps(209);                                                 
            taps_x_fir_reg_accu(209)      <= taps_x_fir_reg(209) + taps_x_fir_reg_accu(208);                                    
            taps_x_fir_reg_accu_en(209)   <= taps_x_fir_reg_accu_en(208);                                  
                                                                                                         
            fir_reg_d211 <= fir_reg_d210;                                                                 
            taps_x_fir_reg(210)           <= fir_reg_d210(210) *  taps(210);                                                 
            taps_x_fir_reg_accu(210)      <= taps_x_fir_reg(210) + taps_x_fir_reg_accu(209);                                    
            taps_x_fir_reg_accu_en(210)   <= taps_x_fir_reg_accu_en(209);                                  
                                                                                                         
            fir_reg_d212 <= fir_reg_d211;                                                                 
            taps_x_fir_reg(211)           <= fir_reg_d211(211) *  taps(211);                                                 
            taps_x_fir_reg_accu(211)      <= taps_x_fir_reg(211) + taps_x_fir_reg_accu(210);                                    
            taps_x_fir_reg_accu_en(211)   <= taps_x_fir_reg_accu_en(210);                                  
                                                                                                         
            fir_reg_d213 <= fir_reg_d212;                                                                 
            taps_x_fir_reg(212)           <= fir_reg_d212(212) *  taps(212);                                                 
            taps_x_fir_reg_accu(212)      <= taps_x_fir_reg(212) + taps_x_fir_reg_accu(211);                                    
            taps_x_fir_reg_accu_en(212)   <= taps_x_fir_reg_accu_en(211);                                  
                                                                                                         
            fir_reg_d214 <= fir_reg_d213;                                                                 
            taps_x_fir_reg(213)           <= fir_reg_d213(213) *  taps(213);                                                 
            taps_x_fir_reg_accu(213)      <= taps_x_fir_reg(213) + taps_x_fir_reg_accu(212);                                    
            taps_x_fir_reg_accu_en(213)   <= taps_x_fir_reg_accu_en(212);                                  
                                                                                                         
            fir_reg_d215 <= fir_reg_d214;                                                                 
            taps_x_fir_reg(214)           <= fir_reg_d214(214) *  taps(214);                                                 
            taps_x_fir_reg_accu(214)      <= taps_x_fir_reg(214) + taps_x_fir_reg_accu(213);                                    
            taps_x_fir_reg_accu_en(214)   <= taps_x_fir_reg_accu_en(213);                                  
                                                                                                         
            fir_reg_d216 <= fir_reg_d215;                                                                 
            taps_x_fir_reg(215)           <= fir_reg_d215(215) *  taps(215);                                                 
            taps_x_fir_reg_accu(215)      <= taps_x_fir_reg(215) + taps_x_fir_reg_accu(214);                                    
            taps_x_fir_reg_accu_en(215)   <= taps_x_fir_reg_accu_en(214);                                  
                                                                                                         
            fir_reg_d217 <= fir_reg_d216;                                                                 
            taps_x_fir_reg(216)           <= fir_reg_d216(216) *  taps(216);                                                 
            taps_x_fir_reg_accu(216)      <= taps_x_fir_reg(216) + taps_x_fir_reg_accu(215);                                    
            taps_x_fir_reg_accu_en(216)   <= taps_x_fir_reg_accu_en(215);                                  
                                                                                                         
            fir_reg_d218 <= fir_reg_d217;                                                                 
            taps_x_fir_reg(217)           <= fir_reg_d217(217) *  taps(217);                                                 
            taps_x_fir_reg_accu(217)      <= taps_x_fir_reg(217) + taps_x_fir_reg_accu(216);                                    
            taps_x_fir_reg_accu_en(217)   <= taps_x_fir_reg_accu_en(216);                                  
                                                                                                         
            fir_reg_d219 <= fir_reg_d218;                                                                 
            taps_x_fir_reg(218)           <= fir_reg_d218(218) *  taps(218);                                                 
            taps_x_fir_reg_accu(218)      <= taps_x_fir_reg(218) + taps_x_fir_reg_accu(217);                                    
            taps_x_fir_reg_accu_en(218)   <= taps_x_fir_reg_accu_en(217);                                  
                                                                                                         
            fir_reg_d220 <= fir_reg_d219;                                                                 
            taps_x_fir_reg(219)           <= fir_reg_d219(219) *  taps(219);                                                 
            taps_x_fir_reg_accu(219)      <= taps_x_fir_reg(219) + taps_x_fir_reg_accu(218);                                    
            taps_x_fir_reg_accu_en(219)   <= taps_x_fir_reg_accu_en(218);                                  
                                                                                                         
            fir_reg_d221 <= fir_reg_d220;                                                                 
            taps_x_fir_reg(220)           <= fir_reg_d220(220) *  taps(220);                                                 
            taps_x_fir_reg_accu(220)      <= taps_x_fir_reg(220) + taps_x_fir_reg_accu(219);                                    
            taps_x_fir_reg_accu_en(220)   <= taps_x_fir_reg_accu_en(219);                                  
                                                                                                         
            fir_reg_d222 <= fir_reg_d221;                                                                 
            taps_x_fir_reg(221)           <= fir_reg_d221(221) *  taps(221);                                                 
            taps_x_fir_reg_accu(221)      <= taps_x_fir_reg(221) + taps_x_fir_reg_accu(220);                                    
            taps_x_fir_reg_accu_en(221)   <= taps_x_fir_reg_accu_en(220);                                  
                                                                                                         
            fir_reg_d223 <= fir_reg_d222;                                                                 
            taps_x_fir_reg(222)           <= fir_reg_d222(222) *  taps(222);                                                 
            taps_x_fir_reg_accu(222)      <= taps_x_fir_reg(222) + taps_x_fir_reg_accu(221);                                    
            taps_x_fir_reg_accu_en(222)   <= taps_x_fir_reg_accu_en(221);                                  
                                                                                                         
            fir_reg_d224 <= fir_reg_d223;                                                                 
            taps_x_fir_reg(223)           <= fir_reg_d223(223) *  taps(223);                                                 
            taps_x_fir_reg_accu(223)      <= taps_x_fir_reg(223) + taps_x_fir_reg_accu(222);                                    
            taps_x_fir_reg_accu_en(223)   <= taps_x_fir_reg_accu_en(222);                                  
                                                                                                         
            fir_reg_d225 <= fir_reg_d224;                                                                 
            taps_x_fir_reg(224)           <= fir_reg_d224(224) *  taps(224);                                                 
            taps_x_fir_reg_accu(224)      <= taps_x_fir_reg(224) + taps_x_fir_reg_accu(223);                                    
            taps_x_fir_reg_accu_en(224)   <= taps_x_fir_reg_accu_en(223);                                  
                                                                                                         
            fir_reg_d226 <= fir_reg_d225;                                                                 
            taps_x_fir_reg(225)           <= fir_reg_d225(225) *  taps(225);                                                 
            taps_x_fir_reg_accu(225)      <= taps_x_fir_reg(225) + taps_x_fir_reg_accu(224);                                    
            taps_x_fir_reg_accu_en(225)   <= taps_x_fir_reg_accu_en(224);                                  
                                                                                                         
            fir_reg_d227 <= fir_reg_d226;                                                                 
            taps_x_fir_reg(226)           <= fir_reg_d226(226) *  taps(226);                                                 
            taps_x_fir_reg_accu(226)      <= taps_x_fir_reg(226) + taps_x_fir_reg_accu(225);                                    
            taps_x_fir_reg_accu_en(226)   <= taps_x_fir_reg_accu_en(225);                                  
                                                                                                         
            fir_reg_d228 <= fir_reg_d227;                                                                 
            taps_x_fir_reg(227)           <= fir_reg_d227(227) *  taps(227);                                                 
            taps_x_fir_reg_accu(227)      <= taps_x_fir_reg(227) + taps_x_fir_reg_accu(226);                                    
            taps_x_fir_reg_accu_en(227)   <= taps_x_fir_reg_accu_en(226);                                  
                                                                                                         
            fir_reg_d229 <= fir_reg_d228;                                                                 
            taps_x_fir_reg(228)           <= fir_reg_d228(228) *  taps(228);                                                 
            taps_x_fir_reg_accu(228)      <= taps_x_fir_reg(228) + taps_x_fir_reg_accu(227);                                    
            taps_x_fir_reg_accu_en(228)   <= taps_x_fir_reg_accu_en(227);                                  
                                                                                                         
            fir_reg_d230 <= fir_reg_d229;                                                                 
            taps_x_fir_reg(229)           <= fir_reg_d229(229) *  taps(229);                                                 
            taps_x_fir_reg_accu(229)      <= taps_x_fir_reg(229) + taps_x_fir_reg_accu(228);                                    
            taps_x_fir_reg_accu_en(229)   <= taps_x_fir_reg_accu_en(228);                                  
                                                                                                         
            fir_reg_d231 <= fir_reg_d230;                                                                 
            taps_x_fir_reg(230)           <= fir_reg_d230(230) *  taps(230);                                                 
            taps_x_fir_reg_accu(230)      <= taps_x_fir_reg(230) + taps_x_fir_reg_accu(229);                                    
            taps_x_fir_reg_accu_en(230)   <= taps_x_fir_reg_accu_en(229);                                  
                                                                                                         
            fir_reg_d232 <= fir_reg_d231;                                                                 
            taps_x_fir_reg(231)           <= fir_reg_d231(231) *  taps(231);                                                 
            taps_x_fir_reg_accu(231)      <= taps_x_fir_reg(231) + taps_x_fir_reg_accu(230);                                    
            taps_x_fir_reg_accu_en(231)   <= taps_x_fir_reg_accu_en(230);                                  
                                                                                                         
            fir_reg_d233 <= fir_reg_d232;                                                                 
            taps_x_fir_reg(232)           <= fir_reg_d232(232) *  taps(232);                                                 
            taps_x_fir_reg_accu(232)      <= taps_x_fir_reg(232) + taps_x_fir_reg_accu(231);                                    
            taps_x_fir_reg_accu_en(232)   <= taps_x_fir_reg_accu_en(231);                                  
                                                                                                         
            fir_reg_d234 <= fir_reg_d233;                                                                 
            taps_x_fir_reg(233)           <= fir_reg_d233(233) *  taps(233);                                                 
            taps_x_fir_reg_accu(233)      <= taps_x_fir_reg(233) + taps_x_fir_reg_accu(232);                                    
            taps_x_fir_reg_accu_en(233)   <= taps_x_fir_reg_accu_en(232);                                  
                                                                                                         
            fir_reg_d235 <= fir_reg_d234;                                                                 
            taps_x_fir_reg(234)           <= fir_reg_d234(234) *  taps(234);                                                 
            taps_x_fir_reg_accu(234)      <= taps_x_fir_reg(234) + taps_x_fir_reg_accu(233);                                    
            taps_x_fir_reg_accu_en(234)   <= taps_x_fir_reg_accu_en(233);                                  
                                                                                                         
            fir_reg_d236 <= fir_reg_d235;                                                                 
            taps_x_fir_reg(235)           <= fir_reg_d235(235) *  taps(235);                                                 
            taps_x_fir_reg_accu(235)      <= taps_x_fir_reg(235) + taps_x_fir_reg_accu(234);                                    
            taps_x_fir_reg_accu_en(235)   <= taps_x_fir_reg_accu_en(234);                                  
                                                                                                         
            fir_reg_d237 <= fir_reg_d236;                                                                 
            taps_x_fir_reg(236)           <= fir_reg_d236(236) *  taps(236);                                                 
            taps_x_fir_reg_accu(236)      <= taps_x_fir_reg(236) + taps_x_fir_reg_accu(235);                                    
            taps_x_fir_reg_accu_en(236)   <= taps_x_fir_reg_accu_en(235);                                  
                                                                                                         
            fir_reg_d238 <= fir_reg_d237;                                                                 
            taps_x_fir_reg(237)           <= fir_reg_d237(237) *  taps(237);                                                 
            taps_x_fir_reg_accu(237)      <= taps_x_fir_reg(237) + taps_x_fir_reg_accu(236);                                    
            taps_x_fir_reg_accu_en(237)   <= taps_x_fir_reg_accu_en(236);                                  
                                                                                                         
            fir_reg_d239 <= fir_reg_d238;                                                                 
            taps_x_fir_reg(238)           <= fir_reg_d238(238) *  taps(238);                                                 
            taps_x_fir_reg_accu(238)      <= taps_x_fir_reg(238) + taps_x_fir_reg_accu(237);                                    
            taps_x_fir_reg_accu_en(238)   <= taps_x_fir_reg_accu_en(237);                                  
                                                                                                         
            fir_reg_d240 <= fir_reg_d239;                                                                 
            taps_x_fir_reg(239)           <= fir_reg_d239(239) *  taps(239);                                                 
            taps_x_fir_reg_accu(239)      <= taps_x_fir_reg(239) + taps_x_fir_reg_accu(238);                                    
            taps_x_fir_reg_accu_en(239)   <= taps_x_fir_reg_accu_en(238);                                  
                                                                                                         
            fir_reg_d241 <= fir_reg_d240;                                                                 
            taps_x_fir_reg(240)           <= fir_reg_d240(240) *  taps(240);                                                 
            taps_x_fir_reg_accu(240)      <= taps_x_fir_reg(240) + taps_x_fir_reg_accu(239);                                    
            taps_x_fir_reg_accu_en(240)   <= taps_x_fir_reg_accu_en(239);                                  
                                                                                                         
            fir_reg_d242 <= fir_reg_d241;                                                                 
            taps_x_fir_reg(241)           <= fir_reg_d241(241) *  taps(241);                                                 
            taps_x_fir_reg_accu(241)      <= taps_x_fir_reg(241) + taps_x_fir_reg_accu(240);                                    
            taps_x_fir_reg_accu_en(241)   <= taps_x_fir_reg_accu_en(240);                                  
                                                                                                         
            fir_reg_d243 <= fir_reg_d242;                                                                 
            taps_x_fir_reg(242)           <= fir_reg_d242(242) *  taps(242);                                                 
            taps_x_fir_reg_accu(242)      <= taps_x_fir_reg(242) + taps_x_fir_reg_accu(241);                                    
            taps_x_fir_reg_accu_en(242)   <= taps_x_fir_reg_accu_en(241);                                  
                                                                                                         
            fir_reg_d244 <= fir_reg_d243;                                                                 
            taps_x_fir_reg(243)           <= fir_reg_d243(243) *  taps(243);                                                 
            taps_x_fir_reg_accu(243)      <= taps_x_fir_reg(243) + taps_x_fir_reg_accu(242);                                    
            taps_x_fir_reg_accu_en(243)   <= taps_x_fir_reg_accu_en(242);                                  
                                                                                                         
            fir_reg_d245 <= fir_reg_d244;                                                                 
            taps_x_fir_reg(244)           <= fir_reg_d244(244) *  taps(244);                                                 
            taps_x_fir_reg_accu(244)      <= taps_x_fir_reg(244) + taps_x_fir_reg_accu(243);                                    
            taps_x_fir_reg_accu_en(244)   <= taps_x_fir_reg_accu_en(243);                                  
                                                                                                         
            fir_reg_d246 <= fir_reg_d245;                                                                 
            taps_x_fir_reg(245)           <= fir_reg_d245(245) *  taps(245);                                                 
            taps_x_fir_reg_accu(245)      <= taps_x_fir_reg(245) + taps_x_fir_reg_accu(244);                                    
            taps_x_fir_reg_accu_en(245)   <= taps_x_fir_reg_accu_en(244);                                  
                                                                                                         
            fir_reg_d247 <= fir_reg_d246;                                                                 
            taps_x_fir_reg(246)           <= fir_reg_d246(246) *  taps(246);                                                 
            taps_x_fir_reg_accu(246)      <= taps_x_fir_reg(246) + taps_x_fir_reg_accu(245);                                    
            taps_x_fir_reg_accu_en(246)   <= taps_x_fir_reg_accu_en(245);                                  
                                                                                                         
            fir_reg_d248 <= fir_reg_d247;                                                                 
            taps_x_fir_reg(247)           <= fir_reg_d247(247) *  taps(247);                                                 
            taps_x_fir_reg_accu(247)      <= taps_x_fir_reg(247) + taps_x_fir_reg_accu(246);                                    
            taps_x_fir_reg_accu_en(247)   <= taps_x_fir_reg_accu_en(246);                                  
                                                                                                         
            fir_reg_d249 <= fir_reg_d248;                                                                 
            taps_x_fir_reg(248)           <= fir_reg_d248(248) *  taps(248);                                                 
            taps_x_fir_reg_accu(248)      <= taps_x_fir_reg(248) + taps_x_fir_reg_accu(247);                                    
            taps_x_fir_reg_accu_en(248)   <= taps_x_fir_reg_accu_en(247);                                  
                                                                                                         
            fir_reg_d250 <= fir_reg_d249;                                                                 
            taps_x_fir_reg(249)           <= fir_reg_d249(249) *  taps(249);                                                 
            taps_x_fir_reg_accu(249)      <= taps_x_fir_reg(249) + taps_x_fir_reg_accu(248);                                    
            taps_x_fir_reg_accu_en(249)   <= taps_x_fir_reg_accu_en(248);                                  
                                                                                                         
            fir_reg_d251 <= fir_reg_d250;                                                                 
            taps_x_fir_reg(250)           <= fir_reg_d250(250) *  taps(250);                                                 
            taps_x_fir_reg_accu(250)      <= taps_x_fir_reg(250) + taps_x_fir_reg_accu(249);                                    
            taps_x_fir_reg_accu_en(250)   <= taps_x_fir_reg_accu_en(249);                                  
                                                                                                         
            fir_reg_d252 <= fir_reg_d251;                                                                 
            taps_x_fir_reg(251)           <= fir_reg_d251(251) *  taps(251);                                                 
            taps_x_fir_reg_accu(251)      <= taps_x_fir_reg(251) + taps_x_fir_reg_accu(250);                                    
            taps_x_fir_reg_accu_en(251)   <= taps_x_fir_reg_accu_en(250);                                  
                                                                                                         
            fir_reg_d253 <= fir_reg_d252;                                                                 
            taps_x_fir_reg(252)           <= fir_reg_d252(252) *  taps(252);                                                 
            taps_x_fir_reg_accu(252)      <= taps_x_fir_reg(252) + taps_x_fir_reg_accu(251);                                    
            taps_x_fir_reg_accu_en(252)   <= taps_x_fir_reg_accu_en(251);                                  
                                                                                                         
            fir_reg_d254 <= fir_reg_d253;                                                                 
            taps_x_fir_reg(253)           <= fir_reg_d253(253) *  taps(253);                                                 
            taps_x_fir_reg_accu(253)      <= taps_x_fir_reg(253) + taps_x_fir_reg_accu(252);                                    
            taps_x_fir_reg_accu_en(253)   <= taps_x_fir_reg_accu_en(252);                                  
                                                                                                         
            fir_reg_d255 <= fir_reg_d254;                                                                 
            taps_x_fir_reg(254)           <= fir_reg_d254(254) *  taps(254);                                                 
            taps_x_fir_reg_accu(254)      <= taps_x_fir_reg(254) + taps_x_fir_reg_accu(253);                                    
            taps_x_fir_reg_accu_en(254)   <= taps_x_fir_reg_accu_en(253);                                  
                                                                                                         
            fir_reg_d256 <= fir_reg_d255;                                                                 
            taps_x_fir_reg(255)           <= fir_reg_d255(255) *  taps(255);                                                 
            taps_x_fir_reg_accu(255)      <= taps_x_fir_reg(255) + taps_x_fir_reg_accu(254);                                    
            taps_x_fir_reg_accu_en(255)   <= taps_x_fir_reg_accu_en(254);                                  
                                                                                                         
            fir_reg_d257 <= fir_reg_d256;                                                                 
            taps_x_fir_reg(256)           <= fir_reg_d256(256) *  taps(256);                                                 
            taps_x_fir_reg_accu(256)      <= taps_x_fir_reg(256) + taps_x_fir_reg_accu(255);                                    
            taps_x_fir_reg_accu_en(256)   <= taps_x_fir_reg_accu_en(255);                                  
                                                                                                         
            fir_reg_d258 <= fir_reg_d257;                                                                 
            taps_x_fir_reg(257)           <= fir_reg_d257(257) *  taps(257);                                                 
            taps_x_fir_reg_accu(257)      <= taps_x_fir_reg(257) + taps_x_fir_reg_accu(256);                                    
            taps_x_fir_reg_accu_en(257)   <= taps_x_fir_reg_accu_en(256);                                  
                                                                                                         
            fir_reg_d259 <= fir_reg_d258;                                                                 
            taps_x_fir_reg(258)           <= fir_reg_d258(258) *  taps(258);                                                 
            taps_x_fir_reg_accu(258)      <= taps_x_fir_reg(258) + taps_x_fir_reg_accu(257);                                    
            taps_x_fir_reg_accu_en(258)   <= taps_x_fir_reg_accu_en(257);                                  
                                                                                                         
            fir_reg_d260 <= fir_reg_d259;                                                                 
            taps_x_fir_reg(259)           <= fir_reg_d259(259) *  taps(259);                                                 
            taps_x_fir_reg_accu(259)      <= taps_x_fir_reg(259) + taps_x_fir_reg_accu(258);                                    
            taps_x_fir_reg_accu_en(259)   <= taps_x_fir_reg_accu_en(258);                                  
                                                                                                         
            fir_reg_d261 <= fir_reg_d260;                                                                 
            taps_x_fir_reg(260)           <= fir_reg_d260(260) *  taps(260);                                                 
            taps_x_fir_reg_accu(260)      <= taps_x_fir_reg(260) + taps_x_fir_reg_accu(259);                                    
            taps_x_fir_reg_accu_en(260)   <= taps_x_fir_reg_accu_en(259);                                  
                                                                                                         
            fir_reg_d262 <= fir_reg_d261;                                                                 
            taps_x_fir_reg(261)           <= fir_reg_d261(261) *  taps(261);                                                 
            taps_x_fir_reg_accu(261)      <= taps_x_fir_reg(261) + taps_x_fir_reg_accu(260);                                    
            taps_x_fir_reg_accu_en(261)   <= taps_x_fir_reg_accu_en(260);                                  
                                                                                                         
            fir_reg_d263 <= fir_reg_d262;                                                                 
            taps_x_fir_reg(262)           <= fir_reg_d262(262) *  taps(262);                                                 
            taps_x_fir_reg_accu(262)      <= taps_x_fir_reg(262) + taps_x_fir_reg_accu(261);                                    
            taps_x_fir_reg_accu_en(262)   <= taps_x_fir_reg_accu_en(261);                                  
                                                                                                         
            fir_reg_d264 <= fir_reg_d263;                                                                 
            taps_x_fir_reg(263)           <= fir_reg_d263(263) *  taps(263);                                                 
            taps_x_fir_reg_accu(263)      <= taps_x_fir_reg(263) + taps_x_fir_reg_accu(262);                                    
            taps_x_fir_reg_accu_en(263)   <= taps_x_fir_reg_accu_en(262);                                  
                                                                                                         
            fir_reg_d265 <= fir_reg_d264;                                                                 
            taps_x_fir_reg(264)           <= fir_reg_d264(264) *  taps(264);                                                 
            taps_x_fir_reg_accu(264)      <= taps_x_fir_reg(264) + taps_x_fir_reg_accu(263);                                    
            taps_x_fir_reg_accu_en(264)   <= taps_x_fir_reg_accu_en(263);                                  
                                                                                                         
            fir_reg_d266 <= fir_reg_d265;                                                                 
            taps_x_fir_reg(265)           <= fir_reg_d265(265) *  taps(265);                                                 
            taps_x_fir_reg_accu(265)      <= taps_x_fir_reg(265) + taps_x_fir_reg_accu(264);                                    
            taps_x_fir_reg_accu_en(265)   <= taps_x_fir_reg_accu_en(264);                                  
                                                                                                         
            fir_reg_d267 <= fir_reg_d266;                                                                 
            taps_x_fir_reg(266)           <= fir_reg_d266(266) *  taps(266);                                                 
            taps_x_fir_reg_accu(266)      <= taps_x_fir_reg(266) + taps_x_fir_reg_accu(265);                                    
            taps_x_fir_reg_accu_en(266)   <= taps_x_fir_reg_accu_en(265);                                  
                                                                                                         
            fir_reg_d268 <= fir_reg_d267;                                                                 
            taps_x_fir_reg(267)           <= fir_reg_d267(267) *  taps(267);                                                 
            taps_x_fir_reg_accu(267)      <= taps_x_fir_reg(267) + taps_x_fir_reg_accu(266);                                    
            taps_x_fir_reg_accu_en(267)   <= taps_x_fir_reg_accu_en(266);                                  
                                                                                                         
            fir_reg_d269 <= fir_reg_d268;                                                                 
            taps_x_fir_reg(268)           <= fir_reg_d268(268) *  taps(268);                                                 
            taps_x_fir_reg_accu(268)      <= taps_x_fir_reg(268) + taps_x_fir_reg_accu(267);                                    
            taps_x_fir_reg_accu_en(268)   <= taps_x_fir_reg_accu_en(267);                                  
                                                                                                         
            fir_reg_d270 <= fir_reg_d269;                                                                 
            taps_x_fir_reg(269)           <= fir_reg_d269(269) *  taps(269);                                                 
            taps_x_fir_reg_accu(269)      <= taps_x_fir_reg(269) + taps_x_fir_reg_accu(268);                                    
            taps_x_fir_reg_accu_en(269)   <= taps_x_fir_reg_accu_en(268);                                  
                                                                                                         
            fir_reg_d271 <= fir_reg_d270;                                                                 
            taps_x_fir_reg(270)           <= fir_reg_d270(270) *  taps(270);                                                 
            taps_x_fir_reg_accu(270)      <= taps_x_fir_reg(270) + taps_x_fir_reg_accu(269);                                    
            taps_x_fir_reg_accu_en(270)   <= taps_x_fir_reg_accu_en(269);                                  
                                                                                                         
            fir_reg_d272 <= fir_reg_d271;                                                                 
            taps_x_fir_reg(271)           <= fir_reg_d271(271) *  taps(271);                                                 
            taps_x_fir_reg_accu(271)      <= taps_x_fir_reg(271) + taps_x_fir_reg_accu(270);                                    
            taps_x_fir_reg_accu_en(271)   <= taps_x_fir_reg_accu_en(270);                                  
                                                                                                         
            fir_reg_d273 <= fir_reg_d272;                                                                 
            taps_x_fir_reg(272)           <= fir_reg_d272(272) *  taps(272);                                                 
            taps_x_fir_reg_accu(272)      <= taps_x_fir_reg(272) + taps_x_fir_reg_accu(271);                                    
            taps_x_fir_reg_accu_en(272)   <= taps_x_fir_reg_accu_en(271);                                  
                                                                                                         
            fir_reg_d274 <= fir_reg_d273;                                                                 
            taps_x_fir_reg(273)           <= fir_reg_d273(273) *  taps(273);                                                 
            taps_x_fir_reg_accu(273)      <= taps_x_fir_reg(273) + taps_x_fir_reg_accu(272);                                    
            taps_x_fir_reg_accu_en(273)   <= taps_x_fir_reg_accu_en(272);                                  
                                                                                                         
            fir_reg_d275 <= fir_reg_d274;                                                                 
            taps_x_fir_reg(274)           <= fir_reg_d274(274) *  taps(274);                                                 
            taps_x_fir_reg_accu(274)      <= taps_x_fir_reg(274) + taps_x_fir_reg_accu(273);                                    
            taps_x_fir_reg_accu_en(274)   <= taps_x_fir_reg_accu_en(273);                                  
                                                                                                         
            fir_reg_d276 <= fir_reg_d275;                                                                 
            taps_x_fir_reg(275)           <= fir_reg_d275(275) *  taps(275);                                                 
            taps_x_fir_reg_accu(275)      <= taps_x_fir_reg(275) + taps_x_fir_reg_accu(274);                                    
            taps_x_fir_reg_accu_en(275)   <= taps_x_fir_reg_accu_en(274);                                  
                                                                                                         
            fir_reg_d277 <= fir_reg_d276;                                                                 
            taps_x_fir_reg(276)           <= fir_reg_d276(276) *  taps(276);                                                 
            taps_x_fir_reg_accu(276)      <= taps_x_fir_reg(276) + taps_x_fir_reg_accu(275);                                    
            taps_x_fir_reg_accu_en(276)   <= taps_x_fir_reg_accu_en(275);                                  
                                                                                                         
            fir_reg_d278 <= fir_reg_d277;                                                                 
            taps_x_fir_reg(277)           <= fir_reg_d277(277) *  taps(277);                                                 
            taps_x_fir_reg_accu(277)      <= taps_x_fir_reg(277) + taps_x_fir_reg_accu(276);                                    
            taps_x_fir_reg_accu_en(277)   <= taps_x_fir_reg_accu_en(276);                                  
                                                                                                         
            fir_reg_d279 <= fir_reg_d278;                                                                 
            taps_x_fir_reg(278)           <= fir_reg_d278(278) *  taps(278);                                                 
            taps_x_fir_reg_accu(278)      <= taps_x_fir_reg(278) + taps_x_fir_reg_accu(277);                                    
            taps_x_fir_reg_accu_en(278)   <= taps_x_fir_reg_accu_en(277);                                  
                                                                                                         
            fir_reg_d280 <= fir_reg_d279;                                                                 
            taps_x_fir_reg(279)           <= fir_reg_d279(279) *  taps(279);                                                 
            taps_x_fir_reg_accu(279)      <= taps_x_fir_reg(279) + taps_x_fir_reg_accu(278);                                    
            taps_x_fir_reg_accu_en(279)   <= taps_x_fir_reg_accu_en(278);                                  
                                                                                                         
            fir_reg_d281 <= fir_reg_d280;                                                                 
            taps_x_fir_reg(280)           <= fir_reg_d280(280) *  taps(280);                                                 
            taps_x_fir_reg_accu(280)      <= taps_x_fir_reg(280) + taps_x_fir_reg_accu(279);                                    
            taps_x_fir_reg_accu_en(280)   <= taps_x_fir_reg_accu_en(279);                                  
                                                                                                         
            fir_reg_d282 <= fir_reg_d281;                                                                 
            taps_x_fir_reg(281)           <= fir_reg_d281(281) *  taps(281);                                                 
            taps_x_fir_reg_accu(281)      <= taps_x_fir_reg(281) + taps_x_fir_reg_accu(280);                                    
            taps_x_fir_reg_accu_en(281)   <= taps_x_fir_reg_accu_en(280);                                  
                                                                                                         
            fir_reg_d283 <= fir_reg_d282;                                                                 
            taps_x_fir_reg(282)           <= fir_reg_d282(282) *  taps(282);                                                 
            taps_x_fir_reg_accu(282)      <= taps_x_fir_reg(282) + taps_x_fir_reg_accu(281);                                    
            taps_x_fir_reg_accu_en(282)   <= taps_x_fir_reg_accu_en(281);                                  
                                                                                                         
            fir_reg_d284 <= fir_reg_d283;                                                                 
            taps_x_fir_reg(283)           <= fir_reg_d283(283) *  taps(283);                                                 
            taps_x_fir_reg_accu(283)      <= taps_x_fir_reg(283) + taps_x_fir_reg_accu(282);                                    
            taps_x_fir_reg_accu_en(283)   <= taps_x_fir_reg_accu_en(282);                                  
                                                                                                         
            fir_reg_d285 <= fir_reg_d284;                                                                 
            taps_x_fir_reg(284)           <= fir_reg_d284(284) *  taps(284);                                                 
            taps_x_fir_reg_accu(284)      <= taps_x_fir_reg(284) + taps_x_fir_reg_accu(283);                                    
            taps_x_fir_reg_accu_en(284)   <= taps_x_fir_reg_accu_en(283);                                  
                                                                                                         
            fir_reg_d286 <= fir_reg_d285;                                                                 
            taps_x_fir_reg(285)           <= fir_reg_d285(285) *  taps(285);                                                 
            taps_x_fir_reg_accu(285)      <= taps_x_fir_reg(285) + taps_x_fir_reg_accu(284);                                    
            taps_x_fir_reg_accu_en(285)   <= taps_x_fir_reg_accu_en(284);                                  
                                                                                                         
            fir_reg_d287 <= fir_reg_d286;                                                                 
            taps_x_fir_reg(286)           <= fir_reg_d286(286) *  taps(286);                                                 
            taps_x_fir_reg_accu(286)      <= taps_x_fir_reg(286) + taps_x_fir_reg_accu(285);                                    
            taps_x_fir_reg_accu_en(286)   <= taps_x_fir_reg_accu_en(285);                                  
                                                                                                         
            fir_reg_d288 <= fir_reg_d287;                                                                 
            taps_x_fir_reg(287)           <= fir_reg_d287(287) *  taps(287);                                                 
            taps_x_fir_reg_accu(287)      <= taps_x_fir_reg(287) + taps_x_fir_reg_accu(286);                                    
            taps_x_fir_reg_accu_en(287)   <= taps_x_fir_reg_accu_en(286);                                  
                                                                                                         
            fir_reg_d289 <= fir_reg_d288;                                                                 
            taps_x_fir_reg(288)           <= fir_reg_d288(288) *  taps(288);                                                 
            taps_x_fir_reg_accu(288)      <= taps_x_fir_reg(288) + taps_x_fir_reg_accu(287);                                    
            taps_x_fir_reg_accu_en(288)   <= taps_x_fir_reg_accu_en(287);                                  
                                                                                                         
            fir_reg_d290 <= fir_reg_d289;                                                                 
            taps_x_fir_reg(289)           <= fir_reg_d289(289) *  taps(289);                                                 
            taps_x_fir_reg_accu(289)      <= taps_x_fir_reg(289) + taps_x_fir_reg_accu(288);                                    
            taps_x_fir_reg_accu_en(289)   <= taps_x_fir_reg_accu_en(288);                                  
                                                                                                         
            fir_reg_d291 <= fir_reg_d290;                                                                 
            taps_x_fir_reg(290)           <= fir_reg_d290(290) *  taps(290);                                                 
            taps_x_fir_reg_accu(290)      <= taps_x_fir_reg(290) + taps_x_fir_reg_accu(289);                                    
            taps_x_fir_reg_accu_en(290)   <= taps_x_fir_reg_accu_en(289);                                  
                                                                                                         
            fir_reg_d292 <= fir_reg_d291;                                                                 
            taps_x_fir_reg(291)           <= fir_reg_d291(291) *  taps(291);                                                 
            taps_x_fir_reg_accu(291)      <= taps_x_fir_reg(291) + taps_x_fir_reg_accu(290);                                    
            taps_x_fir_reg_accu_en(291)   <= taps_x_fir_reg_accu_en(290);                                  
                                                                                                         
            fir_reg_d293 <= fir_reg_d292;                                                                 
            taps_x_fir_reg(292)           <= fir_reg_d292(292) *  taps(292);                                                 
            taps_x_fir_reg_accu(292)      <= taps_x_fir_reg(292) + taps_x_fir_reg_accu(291);                                    
            taps_x_fir_reg_accu_en(292)   <= taps_x_fir_reg_accu_en(291);                                  
                                                                                                         
            fir_reg_d294 <= fir_reg_d293;                                                                 
            taps_x_fir_reg(293)           <= fir_reg_d293(293) *  taps(293);                                                 
            taps_x_fir_reg_accu(293)      <= taps_x_fir_reg(293) + taps_x_fir_reg_accu(292);                                    
            taps_x_fir_reg_accu_en(293)   <= taps_x_fir_reg_accu_en(292);                                  
                                                                                                         
            fir_reg_d295 <= fir_reg_d294;                                                                 
            taps_x_fir_reg(294)           <= fir_reg_d294(294) *  taps(294);                                                 
            taps_x_fir_reg_accu(294)      <= taps_x_fir_reg(294) + taps_x_fir_reg_accu(293);                                    
            taps_x_fir_reg_accu_en(294)   <= taps_x_fir_reg_accu_en(293);                                  
                                                                                                         
            fir_reg_d296 <= fir_reg_d295;                                                                 
            taps_x_fir_reg(295)           <= fir_reg_d295(295) *  taps(295);                                                 
            taps_x_fir_reg_accu(295)      <= taps_x_fir_reg(295) + taps_x_fir_reg_accu(294);                                    
            taps_x_fir_reg_accu_en(295)   <= taps_x_fir_reg_accu_en(294);                                  
                                                                                                         
            fir_reg_d297 <= fir_reg_d296;                                                                 
            taps_x_fir_reg(296)           <= fir_reg_d296(296) *  taps(296);                                                 
            taps_x_fir_reg_accu(296)      <= taps_x_fir_reg(296) + taps_x_fir_reg_accu(295);                                    
            taps_x_fir_reg_accu_en(296)   <= taps_x_fir_reg_accu_en(295);                                  
                                                                                                         
            fir_reg_d298 <= fir_reg_d297;                                                                 
            taps_x_fir_reg(297)           <= fir_reg_d297(297) *  taps(297);                                                 
            taps_x_fir_reg_accu(297)      <= taps_x_fir_reg(297) + taps_x_fir_reg_accu(296);                                    
            taps_x_fir_reg_accu_en(297)   <= taps_x_fir_reg_accu_en(296);                                  
                                                                                                         
            fir_reg_d299 <= fir_reg_d298;                                                                 
            taps_x_fir_reg(298)           <= fir_reg_d298(298) *  taps(298);                                                 
            taps_x_fir_reg_accu(298)      <= taps_x_fir_reg(298) + taps_x_fir_reg_accu(297);                                    
            taps_x_fir_reg_accu_en(298)   <= taps_x_fir_reg_accu_en(297);                                  
                                                                                                         
            fir_reg_d300 <= fir_reg_d299;                                                                 
            taps_x_fir_reg(299)           <= fir_reg_d299(299) *  taps(299);                                                 
            taps_x_fir_reg_accu(299)      <= taps_x_fir_reg(299) + taps_x_fir_reg_accu(298);                                    
            taps_x_fir_reg_accu_en(299)   <= taps_x_fir_reg_accu_en(298);                                  
                                                                                                         
            fir_reg_d301 <= fir_reg_d300;                                                                 
            taps_x_fir_reg(300)           <= fir_reg_d300(300) *  taps(300);                                                 
            taps_x_fir_reg_accu(300)      <= taps_x_fir_reg(300) + taps_x_fir_reg_accu(299);                                    
            taps_x_fir_reg_accu_en(300)   <= taps_x_fir_reg_accu_en(299);                                  
                                                                                                         
            fir_reg_d302 <= fir_reg_d301;                                                                 
            taps_x_fir_reg(301)           <= fir_reg_d301(301) *  taps(301);                                                 
            taps_x_fir_reg_accu(301)      <= taps_x_fir_reg(301) + taps_x_fir_reg_accu(300);                                    
            taps_x_fir_reg_accu_en(301)   <= taps_x_fir_reg_accu_en(300);                                  
                                                                                                         
            fir_reg_d303 <= fir_reg_d302;                                                                 
            taps_x_fir_reg(302)           <= fir_reg_d302(302) *  taps(302);                                                 
            taps_x_fir_reg_accu(302)      <= taps_x_fir_reg(302) + taps_x_fir_reg_accu(301);                                    
            taps_x_fir_reg_accu_en(302)   <= taps_x_fir_reg_accu_en(301);                                  
                                                                                                         
            fir_reg_d304 <= fir_reg_d303;                                                                 
            taps_x_fir_reg(303)           <= fir_reg_d303(303) *  taps(303);                                                 
            taps_x_fir_reg_accu(303)      <= taps_x_fir_reg(303) + taps_x_fir_reg_accu(302);                                    
            taps_x_fir_reg_accu_en(303)   <= taps_x_fir_reg_accu_en(302);                                  
                                                                                                         
            fir_reg_d305 <= fir_reg_d304;                                                                 
            taps_x_fir_reg(304)           <= fir_reg_d304(304) *  taps(304);                                                 
            taps_x_fir_reg_accu(304)      <= taps_x_fir_reg(304) + taps_x_fir_reg_accu(303);                                    
            taps_x_fir_reg_accu_en(304)   <= taps_x_fir_reg_accu_en(303);                                  
                                                                                                         
            fir_reg_d306 <= fir_reg_d305;                                                                 
            taps_x_fir_reg(305)           <= fir_reg_d305(305) *  taps(305);                                                 
            taps_x_fir_reg_accu(305)      <= taps_x_fir_reg(305) + taps_x_fir_reg_accu(304);                                    
            taps_x_fir_reg_accu_en(305)   <= taps_x_fir_reg_accu_en(304);                                  
                                                                                                         
            fir_reg_d307 <= fir_reg_d306;                                                                 
            taps_x_fir_reg(306)           <= fir_reg_d306(306) *  taps(306);                                                 
            taps_x_fir_reg_accu(306)      <= taps_x_fir_reg(306) + taps_x_fir_reg_accu(305);                                    
            taps_x_fir_reg_accu_en(306)   <= taps_x_fir_reg_accu_en(305);                                  
                                                                                                         
            fir_reg_d308 <= fir_reg_d307;                                                                 
            taps_x_fir_reg(307)           <= fir_reg_d307(307) *  taps(307);                                                 
            taps_x_fir_reg_accu(307)      <= taps_x_fir_reg(307) + taps_x_fir_reg_accu(306);                                    
            taps_x_fir_reg_accu_en(307)   <= taps_x_fir_reg_accu_en(306);                                  
                                                                                                         
            fir_reg_d309 <= fir_reg_d308;                                                                 
            taps_x_fir_reg(308)           <= fir_reg_d308(308) *  taps(308);                                                 
            taps_x_fir_reg_accu(308)      <= taps_x_fir_reg(308) + taps_x_fir_reg_accu(307);                                    
            taps_x_fir_reg_accu_en(308)   <= taps_x_fir_reg_accu_en(307);                                  
                                                                                                         
            fir_reg_d310 <= fir_reg_d309;                                                                 
            taps_x_fir_reg(309)           <= fir_reg_d309(309) *  taps(309);                                                 
            taps_x_fir_reg_accu(309)      <= taps_x_fir_reg(309) + taps_x_fir_reg_accu(308);                                    
            taps_x_fir_reg_accu_en(309)   <= taps_x_fir_reg_accu_en(308);                                  
                                                                                                         
            fir_reg_d311 <= fir_reg_d310;                                                                 
            taps_x_fir_reg(310)           <= fir_reg_d310(310) *  taps(310);                                                 
            taps_x_fir_reg_accu(310)      <= taps_x_fir_reg(310) + taps_x_fir_reg_accu(309);                                    
            taps_x_fir_reg_accu_en(310)   <= taps_x_fir_reg_accu_en(309);                                  
                                                                                                         
            fir_reg_d312 <= fir_reg_d311;                                                                 
            taps_x_fir_reg(311)           <= fir_reg_d311(311) *  taps(311);                                                 
            taps_x_fir_reg_accu(311)      <= taps_x_fir_reg(311) + taps_x_fir_reg_accu(310);                                    
            taps_x_fir_reg_accu_en(311)   <= taps_x_fir_reg_accu_en(310);                                  
                                                                                                         
            fir_reg_d313 <= fir_reg_d312;                                                                 
            taps_x_fir_reg(312)           <= fir_reg_d312(312) *  taps(312);                                                 
            taps_x_fir_reg_accu(312)      <= taps_x_fir_reg(312) + taps_x_fir_reg_accu(311);                                    
            taps_x_fir_reg_accu_en(312)   <= taps_x_fir_reg_accu_en(311);                                  
                                                                                                         
            fir_reg_d314 <= fir_reg_d313;                                                                 
            taps_x_fir_reg(313)           <= fir_reg_d313(313) *  taps(313);                                                 
            taps_x_fir_reg_accu(313)      <= taps_x_fir_reg(313) + taps_x_fir_reg_accu(312);                                    
            taps_x_fir_reg_accu_en(313)   <= taps_x_fir_reg_accu_en(312);                                  
                                                                                                         
            fir_reg_d315 <= fir_reg_d314;                                                                 
            taps_x_fir_reg(314)           <= fir_reg_d314(314) *  taps(314);                                                 
            taps_x_fir_reg_accu(314)      <= taps_x_fir_reg(314) + taps_x_fir_reg_accu(313);                                    
            taps_x_fir_reg_accu_en(314)   <= taps_x_fir_reg_accu_en(313);                                  
                                                                                                         
            fir_reg_d316 <= fir_reg_d315;                                                                 
            taps_x_fir_reg(315)           <= fir_reg_d315(315) *  taps(315);                                                 
            taps_x_fir_reg_accu(315)      <= taps_x_fir_reg(315) + taps_x_fir_reg_accu(314);                                    
            taps_x_fir_reg_accu_en(315)   <= taps_x_fir_reg_accu_en(314);                                  
                                                                                                         
            fir_reg_d317 <= fir_reg_d316;                                                                 
            taps_x_fir_reg(316)           <= fir_reg_d316(316) *  taps(316);                                                 
            taps_x_fir_reg_accu(316)      <= taps_x_fir_reg(316) + taps_x_fir_reg_accu(315);                                    
            taps_x_fir_reg_accu_en(316)   <= taps_x_fir_reg_accu_en(315);                                  
                                                                                                         
            fir_reg_d318 <= fir_reg_d317;                                                                 
            taps_x_fir_reg(317)           <= fir_reg_d317(317) *  taps(317);                                                 
            taps_x_fir_reg_accu(317)      <= taps_x_fir_reg(317) + taps_x_fir_reg_accu(316);                                    
            taps_x_fir_reg_accu_en(317)   <= taps_x_fir_reg_accu_en(316);                                  
                                                                                                         
            fir_reg_d319 <= fir_reg_d318;                                                                 
            taps_x_fir_reg(318)           <= fir_reg_d318(318) *  taps(318);                                                 
            taps_x_fir_reg_accu(318)      <= taps_x_fir_reg(318) + taps_x_fir_reg_accu(317);                                    
            taps_x_fir_reg_accu_en(318)   <= taps_x_fir_reg_accu_en(317);                                  
                                                                                                         
            fir_reg_d320 <= fir_reg_d319;                                                                 
            taps_x_fir_reg(319)           <= fir_reg_d319(319) *  taps(319);                                                 
            taps_x_fir_reg_accu(319)      <= taps_x_fir_reg(319) + taps_x_fir_reg_accu(318);                                    
            taps_x_fir_reg_accu_en(319)   <= taps_x_fir_reg_accu_en(318);                                  
                                                                                                         
            fir_reg_d321 <= fir_reg_d320;                                                                 
            taps_x_fir_reg(320)           <= fir_reg_d320(320) *  taps(320);                                                 
            taps_x_fir_reg_accu(320)      <= taps_x_fir_reg(320) + taps_x_fir_reg_accu(319);                                    
            taps_x_fir_reg_accu_en(320)   <= taps_x_fir_reg_accu_en(319);                                  
                                                                                                         
            fir_reg_d322 <= fir_reg_d321;                                                                 
            taps_x_fir_reg(321)           <= fir_reg_d321(321) *  taps(321);                                                 
            taps_x_fir_reg_accu(321)      <= taps_x_fir_reg(321) + taps_x_fir_reg_accu(320);                                    
            taps_x_fir_reg_accu_en(321)   <= taps_x_fir_reg_accu_en(320);                                  
                                                                                                         
            fir_reg_d323 <= fir_reg_d322;                                                                 
            taps_x_fir_reg(322)           <= fir_reg_d322(322) *  taps(322);                                                 
            taps_x_fir_reg_accu(322)      <= taps_x_fir_reg(322) + taps_x_fir_reg_accu(321);                                    
            taps_x_fir_reg_accu_en(322)   <= taps_x_fir_reg_accu_en(321);                                  
                                                                                                         
            fir_reg_d324 <= fir_reg_d323;                                                                 
            taps_x_fir_reg(323)           <= fir_reg_d323(323) *  taps(323);                                                 
            taps_x_fir_reg_accu(323)      <= taps_x_fir_reg(323) + taps_x_fir_reg_accu(322);                                    
            taps_x_fir_reg_accu_en(323)   <= taps_x_fir_reg_accu_en(322);                                  
                                                                                                         
            fir_reg_d325 <= fir_reg_d324;                                                                 
            taps_x_fir_reg(324)           <= fir_reg_d324(324) *  taps(324);                                                 
            taps_x_fir_reg_accu(324)      <= taps_x_fir_reg(324) + taps_x_fir_reg_accu(323);                                    
            taps_x_fir_reg_accu_en(324)   <= taps_x_fir_reg_accu_en(323);                                  
                                                                                                         
            fir_reg_d326 <= fir_reg_d325;                                                                 
            taps_x_fir_reg(325)           <= fir_reg_d325(325) *  taps(325);                                                 
            taps_x_fir_reg_accu(325)      <= taps_x_fir_reg(325) + taps_x_fir_reg_accu(324);                                    
            taps_x_fir_reg_accu_en(325)   <= taps_x_fir_reg_accu_en(324);                                  
                                                                                                         
            fir_reg_d327 <= fir_reg_d326;                                                                 
            taps_x_fir_reg(326)           <= fir_reg_d326(326) *  taps(326);                                                 
            taps_x_fir_reg_accu(326)      <= taps_x_fir_reg(326) + taps_x_fir_reg_accu(325);                                    
            taps_x_fir_reg_accu_en(326)   <= taps_x_fir_reg_accu_en(325);                                  
                                                                                                         
            fir_reg_d328 <= fir_reg_d327;                                                                 
            taps_x_fir_reg(327)           <= fir_reg_d327(327) *  taps(327);                                                 
            taps_x_fir_reg_accu(327)      <= taps_x_fir_reg(327) + taps_x_fir_reg_accu(326);                                    
            taps_x_fir_reg_accu_en(327)   <= taps_x_fir_reg_accu_en(326);                                  
                                                                                                         
            fir_reg_d329 <= fir_reg_d328;                                                                 
            taps_x_fir_reg(328)           <= fir_reg_d328(328) *  taps(328);                                                 
            taps_x_fir_reg_accu(328)      <= taps_x_fir_reg(328) + taps_x_fir_reg_accu(327);                                    
            taps_x_fir_reg_accu_en(328)   <= taps_x_fir_reg_accu_en(327);                                  
                                                                                                         
            fir_reg_d330 <= fir_reg_d329;                                                                 
            taps_x_fir_reg(329)           <= fir_reg_d329(329) *  taps(329);                                                 
            taps_x_fir_reg_accu(329)      <= taps_x_fir_reg(329) + taps_x_fir_reg_accu(328);                                    
            taps_x_fir_reg_accu_en(329)   <= taps_x_fir_reg_accu_en(328);                                  
                                                                                                         
            fir_reg_d331 <= fir_reg_d330;                                                                 
            taps_x_fir_reg(330)           <= fir_reg_d330(330) *  taps(330);                                                 
            taps_x_fir_reg_accu(330)      <= taps_x_fir_reg(330) + taps_x_fir_reg_accu(329);                                    
            taps_x_fir_reg_accu_en(330)   <= taps_x_fir_reg_accu_en(329);                                  
                                                                                                         
            fir_reg_d332 <= fir_reg_d331;                                                                 
            taps_x_fir_reg(331)           <= fir_reg_d331(331) *  taps(331);                                                 
            taps_x_fir_reg_accu(331)      <= taps_x_fir_reg(331) + taps_x_fir_reg_accu(330);                                    
            taps_x_fir_reg_accu_en(331)   <= taps_x_fir_reg_accu_en(330);                                  
                                                                                                         
            fir_reg_d333 <= fir_reg_d332;                                                                 
            taps_x_fir_reg(332)           <= fir_reg_d332(332) *  taps(332);                                                 
            taps_x_fir_reg_accu(332)      <= taps_x_fir_reg(332) + taps_x_fir_reg_accu(331);                                    
            taps_x_fir_reg_accu_en(332)   <= taps_x_fir_reg_accu_en(331);                                  
                                                                                                         
            fir_reg_d334 <= fir_reg_d333;                                                                 
            taps_x_fir_reg(333)           <= fir_reg_d333(333) *  taps(333);                                                 
            taps_x_fir_reg_accu(333)      <= taps_x_fir_reg(333) + taps_x_fir_reg_accu(332);                                    
            taps_x_fir_reg_accu_en(333)   <= taps_x_fir_reg_accu_en(332);                                  
                                                                                                         
            fir_reg_d335 <= fir_reg_d334;                                                                 
            taps_x_fir_reg(334)           <= fir_reg_d334(334) *  taps(334);                                                 
            taps_x_fir_reg_accu(334)      <= taps_x_fir_reg(334) + taps_x_fir_reg_accu(333);                                    
            taps_x_fir_reg_accu_en(334)   <= taps_x_fir_reg_accu_en(333);                                  
                                                                                                         
            fir_reg_d336 <= fir_reg_d335;                                                                 
            taps_x_fir_reg(335)           <= fir_reg_d335(335) *  taps(335);                                                 
            taps_x_fir_reg_accu(335)      <= taps_x_fir_reg(335) + taps_x_fir_reg_accu(334);                                    
            taps_x_fir_reg_accu_en(335)   <= taps_x_fir_reg_accu_en(334);                                  
                                                                                                         
            fir_reg_d337 <= fir_reg_d336;                                                                 
            taps_x_fir_reg(336)           <= fir_reg_d336(336) *  taps(336);                                                 
            taps_x_fir_reg_accu(336)      <= taps_x_fir_reg(336) + taps_x_fir_reg_accu(335);                                    
            taps_x_fir_reg_accu_en(336)   <= taps_x_fir_reg_accu_en(335);                                  
                                                                                                         
            fir_reg_d338 <= fir_reg_d337;                                                                 
            taps_x_fir_reg(337)           <= fir_reg_d337(337) *  taps(337);                                                 
            taps_x_fir_reg_accu(337)      <= taps_x_fir_reg(337) + taps_x_fir_reg_accu(336);                                    
            taps_x_fir_reg_accu_en(337)   <= taps_x_fir_reg_accu_en(336);                                  
                                                                                                         
            fir_reg_d339 <= fir_reg_d338;                                                                 
            taps_x_fir_reg(338)           <= fir_reg_d338(338) *  taps(338);                                                 
            taps_x_fir_reg_accu(338)      <= taps_x_fir_reg(338) + taps_x_fir_reg_accu(337);                                    
            taps_x_fir_reg_accu_en(338)   <= taps_x_fir_reg_accu_en(337);                                  
                                                                                                         
            fir_reg_d340 <= fir_reg_d339;                                                                 
            taps_x_fir_reg(339)           <= fir_reg_d339(339) *  taps(339);                                                 
            taps_x_fir_reg_accu(339)      <= taps_x_fir_reg(339) + taps_x_fir_reg_accu(338);                                    
            taps_x_fir_reg_accu_en(339)   <= taps_x_fir_reg_accu_en(338);                                  
                                                                                                         
            fir_reg_d341 <= fir_reg_d340;                                                                 
            taps_x_fir_reg(340)           <= fir_reg_d340(340) *  taps(340);                                                 
            taps_x_fir_reg_accu(340)      <= taps_x_fir_reg(340) + taps_x_fir_reg_accu(339);                                    
            taps_x_fir_reg_accu_en(340)   <= taps_x_fir_reg_accu_en(339);                                  
                                                                                                         
            fir_reg_d342 <= fir_reg_d341;                                                                 
            taps_x_fir_reg(341)           <= fir_reg_d341(341) *  taps(341);                                                 
            taps_x_fir_reg_accu(341)      <= taps_x_fir_reg(341) + taps_x_fir_reg_accu(340);                                    
            taps_x_fir_reg_accu_en(341)   <= taps_x_fir_reg_accu_en(340);                                  
                                                                                                         
                                                                                                         
            v_round := '0' & taps_x_fir_reg_accu(341)(15);                                                     
            data_out_prepare <= std_logic_vector(taps_x_fir_reg_accu(341)(27 downto 16) + v_round);                                                                         
            data_out_prepare_en <= taps_x_fir_reg_accu_en(341);--;                                                    

                                                                                                         
       end if;                                                                                           
                                                                                                         
    end process;                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
 data_out     <= data_out_prepare;                                                                       
 data_out_en  <= data_out_prepare_en;                                                                    
                                                                                                         
                                                                                                         
                                                                                                         
 taps(0) <= to_signed(2,14);
 taps(1) <= to_signed(2,14);
 taps(2) <= to_signed(2,14);
 taps(3) <= to_signed(2,14);
 taps(4) <= to_signed(1,14);
 taps(5) <= to_signed(0,14);
 taps(6) <= to_signed(0,14);
 taps(7) <= to_signed(-1,14);
 taps(8) <= to_signed(-2,14);
 taps(9) <= to_signed(-2,14);
 taps(10) <= to_signed(-2,14);
 taps(11) <= to_signed(-2,14);
 taps(12) <= to_signed(-2,14);
 taps(13) <= to_signed(-1,14);
 taps(14) <= to_signed(0,14);
 taps(15) <= to_signed(1,14);
 taps(16) <= to_signed(2,14);
 taps(17) <= to_signed(3,14);
 taps(18) <= to_signed(3,14);
 taps(19) <= to_signed(3,14);
 taps(20) <= to_signed(3,14);
 taps(21) <= to_signed(2,14);
 taps(22) <= to_signed(1,14);
 taps(23) <= to_signed(0,14);
 taps(24) <= to_signed(-1,14);
 taps(25) <= to_signed(-3,14);
 taps(26) <= to_signed(-4,14);
 taps(27) <= to_signed(-5,14);
 taps(28) <= to_signed(-5,14);
 taps(29) <= to_signed(-4,14);
 taps(30) <= to_signed(-3,14);
 taps(31) <= to_signed(-1,14);
 taps(32) <= to_signed(1,14);
 taps(33) <= to_signed(3,14);
 taps(34) <= to_signed(4,14);
 taps(35) <= to_signed(5,14);
 taps(36) <= to_signed(6,14);
 taps(37) <= to_signed(6,14);
 taps(38) <= to_signed(5,14);
 taps(39) <= to_signed(3,14);
 taps(40) <= to_signed(1,14);
 taps(41) <= to_signed(-2,14);
 taps(42) <= to_signed(-4,14);
 taps(43) <= to_signed(-5,14);
 taps(44) <= to_signed(-7,14);
 taps(45) <= to_signed(-7,14);
 taps(46) <= to_signed(-6,14);
 taps(47) <= to_signed(-5,14);
 taps(48) <= to_signed(-2,14);
 taps(49) <= to_signed(0,14);
 taps(50) <= to_signed(2,14);
 taps(51) <= to_signed(4,14);
 taps(52) <= to_signed(6,14);
 taps(53) <= to_signed(6,14);
 taps(54) <= to_signed(6,14);
 taps(55) <= to_signed(5,14);
 taps(56) <= to_signed(3,14);
 taps(57) <= to_signed(1,14);
 taps(58) <= to_signed(-1,14);
 taps(59) <= to_signed(-2,14);
 taps(60) <= to_signed(-4,14);
 taps(61) <= to_signed(-4,14);
 taps(62) <= to_signed(-4,14);
 taps(63) <= to_signed(-3,14);
 taps(64) <= to_signed(-2,14);
 taps(65) <= to_signed(-1,14);
 taps(66) <= to_signed(0,14);
 taps(67) <= to_signed(0,14);
 taps(68) <= to_signed(0,14);
 taps(69) <= to_signed(-1,14);
 taps(70) <= to_signed(-2,14);
 taps(71) <= to_signed(-3,14);
 taps(72) <= to_signed(-3,14);
 taps(73) <= to_signed(-3,14);
 taps(74) <= to_signed(-2,14);
 taps(75) <= to_signed(0,14);
 taps(76) <= to_signed(3,14);
 taps(77) <= to_signed(7,14);
 taps(78) <= to_signed(10,14);
 taps(79) <= to_signed(13,14);
 taps(80) <= to_signed(15,14);
 taps(81) <= to_signed(14,14);
 taps(82) <= to_signed(11,14);
 taps(83) <= to_signed(5,14);
 taps(84) <= to_signed(-2,14);
 taps(85) <= to_signed(-11,14);
 taps(86) <= to_signed(-20,14);
 taps(87) <= to_signed(-28,14);
 taps(88) <= to_signed(-33,14);
 taps(89) <= to_signed(-34,14);
 taps(90) <= to_signed(-30,14);
 taps(91) <= to_signed(-20,14);
 taps(92) <= to_signed(-6,14);
 taps(93) <= to_signed(10,14);
 taps(94) <= to_signed(28,14);
 taps(95) <= to_signed(45,14);
 taps(96) <= to_signed(57,14);
 taps(97) <= to_signed(63,14);
 taps(98) <= to_signed(61,14);
 taps(99) <= to_signed(49,14);
 taps(100) <= to_signed(29,14);
 taps(101) <= to_signed(2,14);
 taps(102) <= to_signed(-28,14);
 taps(103) <= to_signed(-59,14);
 taps(104) <= to_signed(-84,14);
 taps(105) <= to_signed(-101,14);
 taps(106) <= to_signed(-106,14);
 taps(107) <= to_signed(-96,14);
 taps(108) <= to_signed(-71,14);
 taps(109) <= to_signed(-34,14);
 taps(110) <= to_signed(12,14);
 taps(111) <= to_signed(61,14);
 taps(112) <= to_signed(108,14);
 taps(113) <= to_signed(144,14);
 taps(114) <= to_signed(164,14);
 taps(115) <= to_signed(163,14);
 taps(116) <= to_signed(139,14);
 taps(117) <= to_signed(94,14);
 taps(118) <= to_signed(31,14);
 taps(119) <= to_signed(-43,14);
 taps(120) <= to_signed(-118,14);
 taps(121) <= to_signed(-184,14);
 taps(122) <= to_signed(-231,14);
 taps(123) <= to_signed(-251,14);
 taps(124) <= to_signed(-238,14);
 taps(125) <= to_signed(-191,14);
 taps(126) <= to_signed(-113,14);
 taps(127) <= to_signed(-12,14);
 taps(128) <= to_signed(100,14);
 taps(129) <= to_signed(209,14);
 taps(130) <= to_signed(300,14);
 taps(131) <= to_signed(357,14);
 taps(132) <= to_signed(371,14);
 taps(133) <= to_signed(336,14);
 taps(134) <= to_signed(250,14);
 taps(135) <= to_signed(122,14);
 taps(136) <= to_signed(-35,14);
 taps(137) <= to_signed(-202,14);
 taps(138) <= to_signed(-358,14);
 taps(139) <= to_signed(-480,14);
 taps(140) <= to_signed(-548,14);
 taps(141) <= to_signed(-547,14);
 taps(142) <= to_signed(-470,14);
 taps(143) <= to_signed(-321,14);
 taps(144) <= to_signed(-112,14);
 taps(145) <= to_signed(135,14);
 taps(146) <= to_signed(390,14);
 taps(147) <= to_signed(619,14);
 taps(148) <= to_signed(788,14);
 taps(149) <= to_signed(868,14);
 taps(150) <= to_signed(837,14);
 taps(151) <= to_signed(685,14);
 taps(152) <= to_signed(419,14);
 taps(153) <= to_signed(58,14);
 taps(154) <= to_signed(-362,14);
 taps(155) <= to_signed(-792,14);
 taps(156) <= to_signed(-1177,14);
 taps(157) <= to_signed(-1458,14);
 taps(158) <= to_signed(-1580,14);
 taps(159) <= to_signed(-1500,14);
 taps(160) <= to_signed(-1186,14);
 taps(161) <= to_signed(-630,14);
 taps(162) <= to_signed(155,14);
 taps(163) <= to_signed(1135,14);
 taps(164) <= to_signed(2253,14);
 taps(165) <= to_signed(3437,14);
 taps(166) <= to_signed(4604,14);
 taps(167) <= to_signed(5669,14);
 taps(168) <= to_signed(6550,14);
 taps(169) <= to_signed(7179,14);
 taps(170) <= to_signed(7507,14);
 taps(171) <= to_signed(7507,14);
 taps(172) <= to_signed(7179,14);
 taps(173) <= to_signed(6550,14);
 taps(174) <= to_signed(5669,14);
 taps(175) <= to_signed(4604,14);
 taps(176) <= to_signed(3437,14);
 taps(177) <= to_signed(2253,14);
 taps(178) <= to_signed(1135,14);
 taps(179) <= to_signed(155,14);
 taps(180) <= to_signed(-630,14);
 taps(181) <= to_signed(-1186,14);
 taps(182) <= to_signed(-1500,14);
 taps(183) <= to_signed(-1580,14);
 taps(184) <= to_signed(-1458,14);
 taps(185) <= to_signed(-1177,14);
 taps(186) <= to_signed(-792,14);
 taps(187) <= to_signed(-362,14);
 taps(188) <= to_signed(58,14);
 taps(189) <= to_signed(419,14);
 taps(190) <= to_signed(685,14);
 taps(191) <= to_signed(837,14);
 taps(192) <= to_signed(868,14);
 taps(193) <= to_signed(788,14);
 taps(194) <= to_signed(619,14);
 taps(195) <= to_signed(390,14);
 taps(196) <= to_signed(135,14);
 taps(197) <= to_signed(-112,14);
 taps(198) <= to_signed(-321,14);
 taps(199) <= to_signed(-470,14);
 taps(200) <= to_signed(-547,14);
 taps(201) <= to_signed(-548,14);
 taps(202) <= to_signed(-480,14);
 taps(203) <= to_signed(-358,14);
 taps(204) <= to_signed(-202,14);
 taps(205) <= to_signed(-35,14);
 taps(206) <= to_signed(122,14);
 taps(207) <= to_signed(250,14);
 taps(208) <= to_signed(336,14);
 taps(209) <= to_signed(371,14);
 taps(210) <= to_signed(357,14);
 taps(211) <= to_signed(300,14);
 taps(212) <= to_signed(209,14);
 taps(213) <= to_signed(100,14);
 taps(214) <= to_signed(-12,14);
 taps(215) <= to_signed(-113,14);
 taps(216) <= to_signed(-191,14);
 taps(217) <= to_signed(-238,14);
 taps(218) <= to_signed(-251,14);
 taps(219) <= to_signed(-231,14);
 taps(220) <= to_signed(-184,14);
 taps(221) <= to_signed(-118,14);
 taps(222) <= to_signed(-43,14);
 taps(223) <= to_signed(31,14);
 taps(224) <= to_signed(94,14);
 taps(225) <= to_signed(139,14);
 taps(226) <= to_signed(163,14);
 taps(227) <= to_signed(164,14);
 taps(228) <= to_signed(144,14);
 taps(229) <= to_signed(108,14);
 taps(230) <= to_signed(61,14);
 taps(231) <= to_signed(12,14);
 taps(232) <= to_signed(-34,14);
 taps(233) <= to_signed(-71,14);
 taps(234) <= to_signed(-96,14);
 taps(235) <= to_signed(-106,14);
 taps(236) <= to_signed(-101,14);
 taps(237) <= to_signed(-84,14);
 taps(238) <= to_signed(-59,14);
 taps(239) <= to_signed(-28,14);
 taps(240) <= to_signed(2,14);
 taps(241) <= to_signed(29,14);
 taps(242) <= to_signed(49,14);
 taps(243) <= to_signed(61,14);
 taps(244) <= to_signed(63,14);
 taps(245) <= to_signed(57,14);
 taps(246) <= to_signed(45,14);
 taps(247) <= to_signed(28,14);
 taps(248) <= to_signed(10,14);
 taps(249) <= to_signed(-6,14);
 taps(250) <= to_signed(-20,14);
 taps(251) <= to_signed(-30,14);
 taps(252) <= to_signed(-34,14);
 taps(253) <= to_signed(-33,14);
 taps(254) <= to_signed(-28,14);
 taps(255) <= to_signed(-20,14);
 taps(256) <= to_signed(-11,14);
 taps(257) <= to_signed(-2,14);
 taps(258) <= to_signed(5,14);
 taps(259) <= to_signed(11,14);
 taps(260) <= to_signed(14,14);
 taps(261) <= to_signed(15,14);
 taps(262) <= to_signed(13,14);
 taps(263) <= to_signed(10,14);
 taps(264) <= to_signed(7,14);
 taps(265) <= to_signed(3,14);
 taps(266) <= to_signed(0,14);
 taps(267) <= to_signed(-2,14);
 taps(268) <= to_signed(-3,14);
 taps(269) <= to_signed(-3,14);
 taps(270) <= to_signed(-3,14);
 taps(271) <= to_signed(-2,14);
 taps(272) <= to_signed(-1,14);
 taps(273) <= to_signed(0,14);
 taps(274) <= to_signed(0,14);
 taps(275) <= to_signed(0,14);
 taps(276) <= to_signed(-1,14);
 taps(277) <= to_signed(-2,14);
 taps(278) <= to_signed(-3,14);
 taps(279) <= to_signed(-4,14);
 taps(280) <= to_signed(-4,14);
 taps(281) <= to_signed(-4,14);
 taps(282) <= to_signed(-2,14);
 taps(283) <= to_signed(-1,14);
 taps(284) <= to_signed(1,14);
 taps(285) <= to_signed(3,14);
 taps(286) <= to_signed(5,14);
 taps(287) <= to_signed(6,14);
 taps(288) <= to_signed(6,14);
 taps(289) <= to_signed(6,14);
 taps(290) <= to_signed(4,14);
 taps(291) <= to_signed(2,14);
 taps(292) <= to_signed(0,14);
 taps(293) <= to_signed(-2,14);
 taps(294) <= to_signed(-5,14);
 taps(295) <= to_signed(-6,14);
 taps(296) <= to_signed(-7,14);
 taps(297) <= to_signed(-7,14);
 taps(298) <= to_signed(-5,14);
 taps(299) <= to_signed(-4,14);
 taps(300) <= to_signed(-2,14);
 taps(301) <= to_signed(1,14);
 taps(302) <= to_signed(3,14);
 taps(303) <= to_signed(5,14);
 taps(304) <= to_signed(6,14);
 taps(305) <= to_signed(6,14);
 taps(306) <= to_signed(5,14);
 taps(307) <= to_signed(4,14);
 taps(308) <= to_signed(3,14);
 taps(309) <= to_signed(1,14);
 taps(310) <= to_signed(-1,14);
 taps(311) <= to_signed(-3,14);
 taps(312) <= to_signed(-4,14);
 taps(313) <= to_signed(-5,14);
 taps(314) <= to_signed(-5,14);
 taps(315) <= to_signed(-4,14);
 taps(316) <= to_signed(-3,14);
 taps(317) <= to_signed(-1,14);
 taps(318) <= to_signed(0,14);
 taps(319) <= to_signed(1,14);
 taps(320) <= to_signed(2,14);
 taps(321) <= to_signed(3,14);
 taps(322) <= to_signed(3,14);
 taps(323) <= to_signed(3,14);
 taps(324) <= to_signed(3,14);
 taps(325) <= to_signed(2,14);
 taps(326) <= to_signed(1,14);
 taps(327) <= to_signed(0,14);
 taps(328) <= to_signed(-1,14);
 taps(329) <= to_signed(-2,14);
 taps(330) <= to_signed(-2,14);
 taps(331) <= to_signed(-2,14);
 taps(332) <= to_signed(-2,14);
 taps(333) <= to_signed(-2,14);
 taps(334) <= to_signed(-1,14);
 taps(335) <= to_signed(0,14);
 taps(336) <= to_signed(0,14);
 taps(337) <= to_signed(1,14);
 taps(338) <= to_signed(2,14);
 taps(339) <= to_signed(2,14);
 taps(340) <= to_signed(2,14);
 taps(341) <= to_signed(2,14);
                                                                                                         
                                                                                                         
                                                                                                         
 end rtl;                                                                                                

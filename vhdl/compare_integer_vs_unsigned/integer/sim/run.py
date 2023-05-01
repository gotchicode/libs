"""                                  
Run                                  
---                                  
Demonstrates the VUnit run library.                                  
"""                                  
                                  
from pathlib import Path                                  
from vunit import VUnit                                  
                                  
ROOT = Path(__file__).parent / "../"                                  
                                  
VU = VUnit.from_argv()                                  
                                  
LIB = VU.add_library("lib")                                  
LIB.add_source_files( ROOT / "src" / "*.vhd")                                  
LIB.add_source_files( ROOT /"tb" / "*.vhd")                                  
                                  
VU.set_sim_option('modelsim.init_files.after_load', [str(ROOT / 'sim' / 'wave.do')])

VU.main()                                  

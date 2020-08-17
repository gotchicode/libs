function out=modu_bps(modu)

if strcmp(modu,'BPSK')        bps=1; end;
if strcmp(modu,'QPSK')        bps=2; end;
if strcmp(modu,'16-QAM')      bps=4; end;
if strcmp(modu,'64-QAM')      bps=6; end;
if strcmp(modu,'256-QAM')     bps=8; end;
if strcmp(modu,'1024-QAM')    bps=10; end;
if strcmp(modu,'4096-QAM')    bps=12; end;
if strcmp(modu,'16384-QAM')   bps=14; end;

out = bps;


end;

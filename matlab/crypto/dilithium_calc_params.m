clear;
close;
clc;

%Select the mode
DILITHIUM_MODE = 5; %2 or 3 or 5


SEEDBYTES = 32
CRHBYTES = 64
N = 256
Q = 8380417
D = 13
ROOT_OF_UNITY = 1753

if DILITHIUM_MODE == 2
    K = 4
    L = 4
    ETA = 2
    TAU = 39
    BETA = 78
    GAMMA1 = (1 * 2^17)
    GAMMA2 = ((Q-1)/88)
    OMEGA = 80
end;

if DILITHIUM_MODE == 3
    K = 6
    L = 5
    ETA = 4
    TAU = 49
    BETA = 196
    GAMMA1 = (1 * 2^19)
    GAMMA2 = ((Q-1)/32)
    OMEGA = 55
end;

if DILITHIUM_MODE == 5
    K = 8
    L = 7
    ETA = 2
    TAU = 60
    BETA = 120
    GAMMA1 = (1 * 2^19)
    GAMMA2 = ((Q-1)/32)
    OMEGA = 75
end;

POLYT1_PACKEDBYTES  = 320
POLYT0_PACKEDBYTES  = 416
POLYVECH_PACKEDBYTES = (OMEGA + K)

if GAMMA1 == (1 * 2^17)
    POLYZ_PACKEDBYTES  = 576
end;
if GAMMA1 == (1 * 2^19)
    POLYZ_PACKEDBYTES =  640
end;

if GAMMA2 == (Q-1)/88
    POLYW1_PACKEDBYTES = 192
end;
if GAMMA2 == (Q-1)/32
    POLYW1_PACKEDBYTES = 128
end;

if ETA == 2
    POLYETA_PACKEDBYTES = 96
end;
if ETA == 4
    POLYETA_PACKEDBYTES = 128
end;

printf("------------------------------\n");
DILITHIUM_MODE
CRYPTO_PUBLICKEYBYTES = (SEEDBYTES + K*POLYT1_PACKEDBYTES)
CRYPTO_SECRETKEYBYTES = (3*SEEDBYTES 
                               + L*POLYETA_PACKEDBYTES 
                               + K*POLYETA_PACKEDBYTES 
                               + K*POLYT0_PACKEDBYTES)
CRYPTO_BYTES = (SEEDBYTES + L*POLYZ_PACKEDBYTES + POLYVECH_PACKEDBYTES)


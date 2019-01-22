#ifndef FRAME_H__
#define FRAME_H__

#include<stdint.h>

/*bitmask*/
#define AND_MASK 0x00ff //before bitmask
#define S_RR 0x80
#define S_REJ 0x90
#define U_SABME 0xf6
#define U_UA 198
/*crc*/
#define POLYNOMIAL 0x04C11DB7
#define INITIAL_REMAINDER 0xFFFFFFFF
#define FINAL_XOR_VALUE 0xFFFFFFFF

typedef unsigned long width;

#define WIDTH (8*sizeof(width))
#define TOPBIT (1<<(WIDTH -1))
/*Destination address and Source address*/
typedef unsigned char addr_t;

/*Data and Padding*/
typedef struct DatanPadding{
    uint8_t dsap;
    uint8_t ssap;
    uint16_t control;
    char info[496];  //Max 496 Bytes
}dapa_t;

/*LLC Format*/
typedef struct fFrame{
    addr_t dst_mac[6];
    addr_t src_mac[6];
    uint16_t pduleng; // Length PDU
    dapa_t dapa;
    uint32_t crc;
}frame_t;

#endif

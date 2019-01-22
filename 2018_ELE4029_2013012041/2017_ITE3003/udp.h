#ifndef FRAME_H__
#define FRAME_H__

#include<stdint.h>

/*bitmask*/
#define AND_MASK 0x00ff //before bitmask
#define S_RR 0x0001
#define S_REJ 0x0009
#define U_SABME 0x006f
#define U_UA 0x0063
#define U_DISC 0x0043

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

#include <stdio.h>
#include <string.h>
#include <platform.h>
#include "main.h"


out port               p_rstn  = WIFI_MISO;
out port               p_dc = WIFI_WIRQ;

void HAL_PORT_RST_CLR(void){
    printf("HAL_PORT_RST_CLR\n");
    p_rstn <: 0;
};

void HAL_PORT_RST_SET(void){
    printf("HAL_PORT_RST_SET\n");
    p_rstn <: 1;
};

void HAL_PORT_DC_CLR(void){
    #define CLR 0 //if D/CX is low, the transmission byte is interpreted as a command byte.
    p_dc <: CLR;
    // printf("HAL_PORT_DC: %d\n", CLR);
};
void HAL_PORT_DC_SET(void){
    p_dc <: !CLR; //if D/CX is high, the transmission byte is stored in the display data RAM (memory write command), or command register as parameter.
    // printf("HAL_PORT_DC: %d\n", !CLR);
};


//Do nothing as lib_spi handles these for us
void HAL_PORT_SELECT(void){
    //printf("HAL_PORT_SELECT\n");
};
void HAL_PORT_DESELECT(void){
    // printf("HAL_PORT_DESELECT\n");
};


void HAL_Delay(int delay){
    printf("HAL_Delay %d ms\n", delay);
    delay_milliseconds(delay);
};

// #define hal_printf(...) printf(__VA_ARGS__)
// void hal_handler(client interface spi_master_if i_spi){
//     // i_spi.begin_transaction(0, SPI_SPEED_KHZ, SPI_MODE);
//     // for(;;){
//     //     uint8_t a = 0x55;
//     //     i_spi.transfer8(a);
//     // }
//     while(1){
//         if(spi_tx_count){
//             hal_printf("SPI TX %d bytes: ", spi_tx_count);
//             i_spi.begin_transaction(0, SPI_SPEED_KHZ, SPI_MODE);
//             for(int i = 0; i < spi_tx_count; i++){
//                 i_spi.transfer8(spi_tx_data[i]);
//                 hal_printf("0x%x ", spi_tx_data[i]);
//             }
//             i_spi.end_transaction(0);
//             hal_printf("\n");
//             unsafe{*spi_tx_count_ptr = 0;}
//         }
//         else{
//             delay_microseconds(POLL_TIME_US);
//         }
//     }
// };


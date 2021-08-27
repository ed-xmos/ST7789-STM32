#include <stdio.h>
#include <string.h>
#include <platform.h>
#include <spi.h>
#include "main.h"


out port               p_sclk  = WIFI_CLK;
out port               p_ss = WIFI_CS_N;
// in buffered port:32    p_miso  = WIFI_MISO;
port                   p_mosi  = WIFI_MOSI;
out port               p_rstn  = WIFI_MISO;
out port               p_dc = WIFI_WIRQ;

// out buffered port:32   p_sclk  = WIFI_CLK;
// out port               p_ss[1] = {WIFI_CS_N};
// // in buffered port:32    p_miso  = WIFI_MISO;
// out buffered port:32   p_mosi  = WIFI_MOSI;
// out port               p_rstn  = WIFI_MISO;
// out port               p_dc = WIFI_WIRQ;
// clock clk0 = on tile[0]: XS1_CLKBLK_1;
// // clock clk1 = on tile[0]: XS1_CLKBLK_2;

// #define SPI_SPEED_KHZ 1000
// #define POLL_TIME_US 1
// #define SPI_MODE SPI_MODE_1 //1 and 3 are sample on rising edge

// //Shared memory flags
// #define MAX_SPI_TX_SIZE 256
// uint8_t spi_tx_data[MAX_SPI_TX_SIZE];
// uint16_t spi_tx_count = 0;

// unsafe{
//     volatile uint8_t * unsafe spi_tx_data_ptr = spi_tx_data;
//     volatile uint16_t * unsafe spi_tx_count_ptr = &spi_tx_count;
// }

void HAL_PORT_RST_CLR(void){
    printf("HAL_PORT_RST_CLR\n");
    p_rstn <: 0;
    p_sclk <: 1; //ensure this is in a good state at init
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

// HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size, uint32_t Timeout){
//     unsafe{
//         while(*spi_tx_count_ptr){
//             // printf(".");
//             delay_microseconds(POLL_TIME_US);
//         }
//         memcpy(spi_tx_data_ptr, pData, Size);
//         *spi_tx_count_ptr = Size;

//         //block until done
//         while(*spi_tx_count_ptr){
//             delay_microseconds(POLL_TIME_US);
//         }

//     }
//     return 0;
// };

#define BB_SPI_HALF_CLOCK_TICKS 0

HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size, uint32_t Timeout){
    for(int b=0; b<Size;b++){
        unsigned tx_byte = pData[b];
        // printf("SPI Tx: 0x%x\n", tx_byte);
        for(int i=0; i<8; i++){
            unsigned bit = (tx_byte << i) & 0x80 ? 1 : 0;
            // printf("bit: %d\n", bit);
            p_mosi <: bit;
            p_sclk <: 0;
            delay_ticks(BB_SPI_HALF_CLOCK_TICKS);    
            p_sclk <: 1;
            delay_ticks(BB_SPI_HALF_CLOCK_TICKS);
        }
    }
    return 0;
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

void hal_task(void){
    interface spi_master_if i_spi[1];
    printf("hal_task\n");
    par{
        // spi_master(i_spi, 1, p_sclk, p_mosi, null, p_ss, 1, clk0);
        // hal_handler(i_spi[0]);
    }
    printf("hal_task_complete\n");
}

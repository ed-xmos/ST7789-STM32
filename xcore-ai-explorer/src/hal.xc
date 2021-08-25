#include <stdio.h>
#include <string.h>
#include <platform.h>
#include <spi.h>
#include "main.h"


out buffered port:32   p_sclk  = WIFI_CLK;
out port               p_ss[1] = {WIFI_CS_N};
in buffered port:32    p_miso  = WIFI_MISO;
out buffered port:32   p_mosi  = WIFI_MOSI;
out port               p_rstn  = WIFI_WUP_RST_N;
out port               p_dc = WIFI_WIRQ;
clock clk0 = on tile[0]: XS1_CLKBLK_1;
// clock clk1 = on tile[0]: XS1_CLKBLK_2;

#define SPI_SPEED_KHZ 100
#define POLL_TIME_US 10

//Shared memory flags
#define MAX_SPI_TX_SIZE 256
uint8_t spi_tx_data[MAX_SPI_TX_SIZE];
uint16_t spi_tx_count = 0;

unsafe{
    uint8_t * unsafe spi_tx_data_ptr = spi_tx_data;
    uint16_t * unsafe spi_tx_count_ptr = &spi_tx_count;
}

void HAL_PORT_RST_CLR(void){
    printf("HAL_PORT_RST_CLR\n");
};

void HAL_PORT_RST_SER(void){
    printf("HAL_PORT_RST_SER\n");
};

void HAL_PORT_DC_CLR(void){
    p_dc <: 0;
    printf("HAL_PORT_DC_CLR\n");
};
void HAL_PORT_DC_SET(void){
    p_dc <: 1;
    printf("HAL_PORT_DC_SET\n");
};


//Do nothing as lib_spi handles these for us
void HAL_PORT_SELECT(void){
    //printf("HAL_PORT_SELECT\n");
};
void HAL_PORT_DESELECT(void){
    // printf("HAL_PORT_DESELECT\n");
};

HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size, uint32_t Timeout){
    unsafe{
        while(*spi_tx_count_ptr){
            printf(".");
            delay_microseconds(POLL_TIME_US);
        }
        memcpy(spi_tx_data_ptr, pData, Size);
        *spi_tx_count_ptr = Size;

        //block for now

    }
    return 0;
};

void HAL_Delay(int delay){
    printf("HAL_Delay %d ms\n", delay);
    delay_milliseconds(delay);
};

void hal_handler(client interface spi_master_if i_spi){
    while(1){
        if(spi_tx_count){
            printf("SPI TX %d bytes\n", spi_tx_count);
            i_spi.begin_transaction(0, SPI_SPEED_KHZ, SPI_MODE_2);
            for(int i = 0; i < spi_tx_count; i++){
                i_spi.transfer8(spi_tx_data[i]);
            }
            i_spi.end_transaction(0);
            spi_tx_count = 0;
        }
        else{
            delay_microseconds(POLL_TIME_US);
        }
    }
};

void hal_task(void){
    interface spi_master_if i_spi[1];
    par{
        spi_master(i_spi, 1, p_sclk, p_mosi, p_miso, p_ss, 1, clk0);
        hal_handler(i_spi[0]);
    }
    printf("hal_task\n");
}

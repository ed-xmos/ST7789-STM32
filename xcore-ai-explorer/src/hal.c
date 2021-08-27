#include <stdio.h>
#include <string.h>
#include <platform.h>
#include "spi.h"
#include "main.h"
#include <xcore/clock.h>
#include <xcore/port.h>
#include <xcore/assert.h>


// SPI interface ports
port_t p_ss[1] = {XS1_PORT_1E};
port_t p_sclk = WIFI_CLK;
port_t p_mosi = WIFI_MOSI;
port_t p_miso = XS1_PORT_1F; //E and F are unused
xclock_t cb   = XS1_CLKBLK_1;


spi_master_device_t spi_dev;
spi_master_t spi_ctx;


void HAL_INIT(void){
    printf("HAL_INIT\n");

    spi_master_init(&spi_ctx, cb, p_ss[0], p_sclk, p_mosi, p_miso);


    static int cpol = 1;
    static int cpha = 1;

    spi_master_device_init(&spi_dev, &spi_ctx,
        0,
        cpol, cpha,
        spi_master_source_clock_ref,
        0,
        spi_master_sample_delay_0,
        0, 0 ,0 ,0 );

    spi_master_start_transaction(&spi_dev);


}


HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size, uint32_t Timeout){

    printf("Size: %d\n", Size);
    // spi_master_start_transaction(&spi_dev);
    spi_master_transfer(&spi_dev, pData, NULL, Size);
    // spi_master_end_transaction(&spi_dev);


    return 0;
};


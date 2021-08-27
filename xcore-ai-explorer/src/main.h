#ifndef __MAIN_H
#define __MAIN_H

#include <stdint.h>
#include <stddef.h>

#define ST7789_RST_Clr() HAL_PORT_RST_CLR()
#define ST7789_RST_Set() HAL_PORT_RST_SET()

#define ST7789_DC_Clr() HAL_PORT_DC_CLR()
#define ST7789_DC_Set() HAL_PORT_DC_SET()

#define ST7789_Select() HAL_PORT_SELECT()
#define ST7789_UnSelect() HAL_PORT_DESELECT()

#define HAL_MAX_DELAY 100 //no idea what units

void HAL_PORT_RST_CLR(void);
void HAL_PORT_RST_SET(void);
void HAL_PORT_DC_CLR(void);
void HAL_PORT_DC_SET(void);
void HAL_PORT_SELECT(void);
void HAL_PORT_DESELECT(void);

typedef int HAL_StatusTypeDef;
typedef struct SPI_HandleTypeDef{
    int a;
}SPI_HandleTypeDef;

HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size, uint32_t Timeout);
void HAL_Delay(int delay);
void hal_task(void);

#endif
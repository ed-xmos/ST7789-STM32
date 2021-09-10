#include <stdio.h>
#include <platform.h>
extern "C"{
 #include "st7789.h"
}
#include "monty1.h"
#include "monty2.h"

SPI_HandleTypeDef hspi1;

void app(void){
    printf("hello world!\n");
    HAL_INIT();
    ST7789_Init();
    printf("ST7789_Init complete\n");

    while(1){
        ST7789_DrawImage(0, 0, 240, 240, monty1_frame_0);
        HAL_Delay(2000);
        ST7789_DrawImage(0, 0, 240, 240, monty2_frame_0);
        HAL_Delay(2000);
    }
    while (1)
    {
        ST7789_Test();
    }
}

int main(void){
    
    par{
        on tile[0]:{
            par{
                app();
            }
        }
    }
    return 0;
}
#include <stdio.h>
#include <platform.h>
extern "C"{
 #include "st7789.h"
}


SPI_HandleTypeDef hspi1;

void app(void){
    printf("hello world!\n");
    HAL_INIT();
    ST7789_Init();
    printf("ST7789_Init complete\n");
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
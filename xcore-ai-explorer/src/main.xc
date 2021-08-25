#include <stdio.h>
#include <platform.h>
extern "C"{
 #include "st7789.h"
}


SPI_HandleTypeDef hspi1;

void app(void){
    printf("hello world!\n");
    ST7789_Init();
}

int main(void){
    
    par{
        on tile[0]:{
            par{
                app();
                hal_task();
            }
        }
    }
    return 0;
}
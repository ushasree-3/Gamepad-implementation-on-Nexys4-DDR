`ifndef GAME_PARAMETERS_V
`define GAME_PARAMETERS_V

//States 
parameter Start_state =2'b00;
parameter Play_state = 2'b01;
parameter End_state = 2'b10;

// VRAM frame buffers (read-write)
parameter SCREEN_WIDTH = 640;
parameter SCREEN_HEIGHT = 480;
parameter VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
parameter VRAM_A_WIDTH = 19;    // no. of bits to represent vram depth
parameter VRAM_D_WIDTH = 12;   // colour bits per pixel

`endif 


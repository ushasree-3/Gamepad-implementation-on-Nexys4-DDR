`include "game_parameters.v"

module end_screen(
    input wire clk,            
    input wire reset,          
    input wire active,
    input wire [9:0] x,
    input wire [8:0] y,       
    output reg [3:0] VGA_R,     
    output reg [3:0] VGA_G,     
    output reg [3:0] VGA_B
    );
    
    reg [9:0] car1_x;  // x position of car 1
    reg [9:0] car2_x; //  x position of car 2
    reg [8:0] car_y;    // Y position of both cars
    
    initial car1_x = 290;
    initial car2_x = 331;   
    initial car_y = 296 + 102;
        
    // Sprite data and palette memories for red car   
    wire [VRAM_D_WIDTH-1:0] dataout_red_car; // sprite data out    
    reg [11:0] red_car_palette [0:63];
                 
    initial begin
    $display("Loading red car palette.");
    $readmemh("red_car_palette.mem", red_car_palette);
    end
    
    wire red_car_enable;      // Enable signal for red car sprite drawing
       
    // Instantiate red car sprite module   
    red_car red_car_inst2(
      .CLK(clk),
      .RST(reset),
      .x(x),                 
      .y(y),       
      .red_car_x(car1_x),   
      .red_car_y(car_y),   
      .red_car_data_out(dataout_red_car),  
      .red_car_enable(red_car_enable)  
    );
       
    // Sprite data and palette memories for blue car  
    wire [VRAM_D_WIDTH-1:0] dataout_blue_car; // sprite data out    
    reg [11:0] blue_car_palette [0:63];
                
    initial begin
    $display("Loading blue car palette.");
    $readmemh("blue_car_palette.mem", blue_car_palette);
    end
    
    wire blue_car_enable;      // Enable signal for red car sprite drawing
       
   // Instantiate blue car sprite module 
    blue_car blue_car_inst2(
     .CLK(clk),
     .RST(reset),
     .x(x),                 
     .y(y),       
     .blue_car_x(car2_x),   
     .blue_car_y(car_y),   
     .blue_car_data_out(dataout_blue_car),  
     .blue_car_enable(blue_car_enable)  
    );
    
    reg [9:0] end_sprite_x;   
    reg [8:0] end_sprite_y;   
        
    initial end_sprite_x = 10'd183;
    initial end_sprite_y = 9'd170;
    
    // Sprite data and palette memories for c   
    wire [VRAM_D_WIDTH-1:0] dataout_end_sprite;     
    reg [11:0] end_sprite_palette [0:63];
                 
    initial begin
    $display("Loading end_sprite palette.");
    $readmemh("end_palette.mem", end_sprite_palette);
    end
    
    wire end_sprite_enable;      // Enable signal for end_sprite drawing
       
    // Instantiate end_sprite module   
    end_sprite end_sprite_inst1(
      .CLK(clk),
      .RST(reset),
      .x(x),                 
      .y(y),       
      .end_sprite_x(end_sprite_x),   
      .end_sprite_y(end_sprite_y),   
      .end_sprite_data_out(dataout_end_sprite),  
      .end_sprite_enable(end_sprite_enable)  
    ); 
      
    // VGA output generation logic 
    always @ (posedge clk) begin
       if (reset) begin
            VGA_R <= 4'b0000;
            VGA_G <= 4'b0000;
            VGA_B <= 4'b0000;               
       end else if (active) begin
        if (end_sprite_enable) begin
             VGA_R <= end_sprite_palette[dataout_end_sprite][11:8];
             VGA_G <= end_sprite_palette[dataout_end_sprite][7:4];
             VGA_B <= end_sprite_palette[dataout_end_sprite][3:0];
        end else if ((x >= 239-2 && x <= 239+2) || (x >= 279-1 && x <= 279+1) || (x >= 319-2 && x <= 319+2) || (x >= 359-1 && x <= 359+1) || (x >= 399-2 && x <= 399+2)) begin
              VGA_R <= 4'b0111;
              VGA_G <= 4'b1000;
              VGA_B <= 4'b1101; // blue colour for roads
        end else if (red_car_enable) begin
              VGA_R <= red_car_palette[dataout_red_car][11:8];
              VGA_G <= red_car_palette[dataout_red_car][7:4];
              VGA_B <= red_car_palette[dataout_red_car][3:0]; // Red car
        end else if (blue_car_enable) begin
              VGA_R <= blue_car_palette[dataout_blue_car][11:8];
              VGA_G <= blue_car_palette[dataout_blue_car][7:4];
              VGA_B <= blue_car_palette[dataout_blue_car][3:0]; // blue car
        end else begin
              VGA_R <= 4'b0010; 
              VGA_G <= 4'b0011;
              VGA_B <= 4'b0111; // Blue colour for remaining area
        end        
      end else begin
             VGA_R <= 4'b0000;
             VGA_G <= 4'b0000;
             VGA_B <= 4'b0000; // not active region - black   
      end
    end
 endmodule

 
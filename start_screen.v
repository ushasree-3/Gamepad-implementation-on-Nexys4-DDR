`include "game_parameters.v"

module start_screen(
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
    red_car red_car_inst1(
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
    blue_car blue_car_inst1(
     .CLK(clk),
     .RST(reset),
     .x(x),                 
     .y(y),       
     .blue_car_x(car2_x),   
     .blue_car_y(car_y),   
     .blue_car_data_out(dataout_blue_car),  
     .blue_car_enable(blue_car_enable)  
    );

    reg [9:0] red_square_x;   
    reg [8:0] red_square_y;   
    
    initial red_square_x = 10'd299;
    initial red_square_y = 9'd25;
    
    // Sprite data and palette memories for red square
    wire [VRAM_D_WIDTH-1:0] dataout_red_square; // sprite data out    
    reg [11:0] red_square_palette [0:63];
               
    initial begin
    $display("Loading red square palette.");
    $readmemh("red_square_palette.mem", red_square_palette);
    end
    
    wire red_square_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate red square sprite module
    red_square red_square_inst1(
        .CLK(clk),
        .RST(reset),
        .x(x),                 
        .y(y),       
        .red_square_x(red_square_x - 7),   
        .red_square_y(red_square_y),   
        .red_square_data_out(dataout_red_square),  
        .red_square_enable(red_square_enable)  
    );
    
    reg [9:0] red_circle_x;   
    reg [8:0] red_circle_y;   
    
    initial red_circle_x = 10'd259;
    initial red_circle_y = 9'd320;
    
    // Sprite data and palette memories for red circle
    wire [VRAM_D_WIDTH-1:0] dataout_red_circle; // sprite data out    
    reg [11:0] red_circle_palette [0:63];
               
    initial begin
    $display("Loading red circle palette.");
    $readmemh("red_circle_palette.mem", red_circle_palette);
    end
    
    wire red_circle_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate red circle sprite module
    red_circle red_circle_inst1(
        .CLK(clk),
        .RST(reset),
        .x(x),                 
        .y(y),       
        .red_circle_x(red_circle_x),   
        .red_circle_y(red_circle_y),   
        .red_circle_data_out(dataout_red_circle),  
        .red_circle_enable(red_circle_enable)  
    );
    
    reg [9:0] blue_square_x;   
    reg [8:0] blue_square_y;   
    
    initial blue_square_x = 10'd378;
    initial blue_square_y = 9'd320;
        
    // Sprite data and palette memories for blue square
    wire [VRAM_D_WIDTH-1:0] dataout_blue_square; // sprite data out    
    reg [11:0] blue_square_palette [0:63];
               
    initial begin
    $display("Loading blue square palette.");
    $readmemh("blue_square_palette.mem", blue_square_palette);
    end
    
    wire blue_square_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate blue square sprite module
    blue_square blue_square_inst1(
        .CLK(clk),
        .RST(reset),
        .x(x),                 
        .y(y),       
        .blue_square_x(blue_square_x - 7),   
        .blue_square_y(blue_square_y),   
        .blue_square_data_out(dataout_blue_square),  
        .blue_square_enable(blue_square_enable)  
    );

    reg [9:0] blue_circle_x;   
    reg [8:0] blue_circle_y;   
    
    initial blue_circle_x = 10'd339;
    initial blue_circle_y = 9'd100;
        
    // Sprite data and palette memories for blue circle
    wire [VRAM_D_WIDTH-1:0] dataout_blue_circle; // sprite data out    
    reg [11:0] blue_circle_palette [0:63];
               
    initial begin
    $display("Loading blue circle palette.");
    $readmemh("blue_circle_palette.mem", blue_circle_palette);
    end
    
    wire blue_circle_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate blue circle sprite module
    blue_circle blue_circle_inst1(
        .CLK(clk),
        .RST(reset),
        .x(x),                 
        .y(y),       
        .blue_circle_x(blue_circle_x),   
        .blue_circle_y(blue_circle_y),   
        .blue_circle_data_out(dataout_blue_circle),  
        .blue_circle_enable(blue_circle_enable)  
    ); 
    
    reg [9:0] cars_x;   
    reg [8:0] cars_y;   
        
    initial cars_x = 10'd183;
    initial cars_y = 9'd170;
    
    // Sprite data and palette memories for 2_cars   
    wire [VRAM_D_WIDTH-1:0] dataout_cars;     
    reg [11:0] cars_palette [0:63];
                 
    initial begin
    $display("Loading cars palette.");
    $readmemh("2_cars_palette.mem", cars_palette);
    end
    
    wire cars_enable;      // Enable signal for 2_cars sprite drawing
       
    // Instantiate 2_cars sprite module   
    cars cars_inst1(
      .CLK(clk),
      .RST(reset),
      .x(x),                 
      .y(y),       
      .cars_x(cars_x),   
      .cars_y(cars_y),   
      .cars_data_out(dataout_cars),  
      .cars_enable(cars_enable)  
    ); 
      
    // VGA output generation logic 
    always @ (posedge clk) begin
       if (reset) begin
            VGA_R <= 4'b0000;
            VGA_G <= 4'b0000;
            VGA_B <= 4'b0000;               
       end else if (active) begin
        if (cars_enable) begin
              VGA_R <= cars_palette[dataout_cars][11:8];
              VGA_G <= cars_palette[dataout_cars][7:4];
              VGA_B <= cars_palette[dataout_cars][3:0];
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
        end else if (red_square_enable) begin
              VGA_R <= red_square_palette[dataout_red_square][11:8];
              VGA_G <= red_square_palette[dataout_red_square][7:4];
              VGA_B <= red_square_palette[dataout_red_square][3:0]; // Red square for car1
        end else if (blue_square_enable) begin  
              VGA_R <= blue_square_palette[dataout_blue_square][11:8];
              VGA_G <= blue_square_palette[dataout_blue_square][7:4];
              VGA_B <= blue_square_palette[dataout_blue_square][3:0]; // blue square for car2
        end else if (red_circle_enable) begin 
              VGA_R <= red_circle_palette[dataout_red_circle][11:8];
              VGA_G <= red_circle_palette[dataout_red_circle][7:4];
              VGA_B <= red_circle_palette[dataout_red_circle][3:0]; // red circle for car1
        end else if (blue_circle_enable) begin
              VGA_R <= blue_circle_palette[dataout_blue_circle][11:8];
              VGA_G <= blue_circle_palette[dataout_blue_circle][7:4];
              VGA_B <= blue_circle_palette[dataout_blue_circle][3:0]; // blue circle for car2
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

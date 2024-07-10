`include "game_parameters.v"

module game(
    input wire CLK,            // 100 MHz
    input wire RST,            // System reset
    input wire pix_stb1,
    input wire active,
    input wire [9:0] x,
    input wire [8:0] y,
    input wire [1:0] switch_b, // switches for car path
    input wire on_off,         // for obstacle generation  
    input wire start_game,     // start game  (to Play State)
    input wire reset_game,     // reset game  (to Start State)
    output wire end_game,
    output reg [3:0] VGA_R,     
    output reg [3:0] VGA_G,     
    output reg [3:0] VGA_B,
    output wire [0:6] seg,      // 7 segment display segment pattern
    output wire [3:0] digit 
);
    wire [9:0] car1_x;  // x position of car 1
    wire [9:0] car2_x; //  x position of car 2
    reg [8:0] car_y;    // Y position of both cars
    
    initial car_y = 296 + 102;
    
    wire object_generated, object_is_square, path, object_is_square2, path2;
    
    wire [9:0] object_x;   // X-coordinate of the object
    wire [8:0] object_y;   // Y-coordinate of the object
    wire [9:0] object_x2;  
    wire [2:0] rand;
    wire score; 
           
    randomo randomo_ (.clk(pix_stb1),.random(rand));
    
    object_generator obj_gen (
        .pix_stb1(pix_stb1),
        .RST(RST || ~on_off),
        .active(active),
        .rand(rand),
        .end_game(end_game),
        .object_x(object_x),
        .object_x2(object_x2),
        .object_y(object_y),
        .object_generated(object_generated),
        .object_is_square(object_is_square),
        .object_is_square2(object_is_square2),
        .path(path),
        .path2(path2)
    );
        
    collision_detector col_detect (
        .clk(CLK),
        .rst(RST || ~on_off),
        .car1_x(car1_x),
        .car2_x(car2_x),
        .car_y(car_y),
        .object_is_square(object_is_square),
        .object_is_square2(object_is_square2),
        .object_x(object_x),
        .object_x2(object_x2),
        .object_y(object_y),
        .score(score),
        .end_game(end_game)
    );
               
    // Sprite data and palette memories for red square
    wire [VRAM_D_WIDTH-1:0] dataout_red_square; // sprite data out    
    reg [11:0] red_square_palette [0:63];
               
    initial begin
    $display("Loading red square palette.");
    $readmemh("red_square_palette.mem", red_square_palette);
    end

    wire red_square_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate red square sprite module
    red_square red_square_inst(
        .CLK(CLK),
        .RST(RST),
        .x(x),                 
        .y(y),       
        .red_square_x(object_x - 7),   
        .red_square_y(object_y - 7),   
        .red_square_data_out(dataout_red_square),  
        .red_square_enable(red_square_enable)  
    );
    
    // Sprite data and palette memories for red circle
    wire [VRAM_D_WIDTH-1:0] dataout_red_circle; // sprite data out    
    reg [11:0] red_circle_palette [0:63];
               
    initial begin
    $display("Loading red circle palette.");
    $readmemh("red_circle_palette.mem", red_circle_palette);
    end

    wire red_circle_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate red circle sprite module
    red_circle red_circle_inst(
        .CLK(CLK),
        .RST(RST),
        .x(x),                 
        .y(y),       
        .red_circle_x(object_x),   
        .red_circle_y(object_y),   
        .red_circle_data_out(dataout_red_circle),  
        .red_circle_enable(red_circle_enable)  
    );
    
    // Sprite data and palette memories for blue square
    wire [VRAM_D_WIDTH-1:0] dataout_blue_square; // sprite data out    
    reg [11:0] blue_square_palette [0:63];
               
    initial begin
    $display("Loading blue square palette.");
    $readmemh("blue_square_palette.mem", blue_square_palette);
    end

    wire blue_square_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate blue square sprite module
    blue_square blue_square_inst(
        .CLK(CLK),
        .RST(RST),
        .x(x),                 
        .y(y),       
        .blue_square_x(object_x2 - 7),   
        .blue_square_y(object_y - 7),   
        .blue_square_data_out(dataout_blue_square),  
        .blue_square_enable(blue_square_enable)  
    );
    
    // Sprite data and palette memories for blue circle
    wire [VRAM_D_WIDTH-1:0] dataout_blue_circle; // sprite data out    
    reg [11:0] blue_circle_palette [0:63];
               
    initial begin
    $display("Loading blue circle palette.");
    $readmemh("blue_circle_palette.mem", blue_circle_palette);
    end

    wire blue_circle_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate blue circle sprite module
    blue_circle blue_circle_inst(
        .CLK(CLK),
        .RST(RST),
        .x(x),                 
        .y(y),       
        .blue_circle_x(object_x2),   
        .blue_circle_y(object_y),   
        .blue_circle_data_out(dataout_blue_circle),  
        .blue_circle_enable(blue_circle_enable)  
    );
    
    // Sprite data and palette memories for red car   
    wire [VRAM_D_WIDTH-1:0] dataout_red_car; // sprite data out    
    reg [11:0] red_car_palette [0:63];
                  
    initial begin
    $display("Loading red car palette.");
    $readmemh("red_car_palette.mem", red_car_palette);
    end

    wire red_car_enable;      // Enable signal for red car sprite drawing
    
    // Instantiate red car sprite module   
    red_car red_car_inst(
       .CLK(CLK),
       .RST(RST),
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
    blue_car blue_car_inst(
      .CLK(CLK),
      .RST(RST),
      .x(x),                 
      .y(y),       
      .blue_car_x(car2_x),   
      .blue_car_y(car_y),   
      .blue_car_data_out(dataout_blue_car),  
      .blue_car_enable(blue_car_enable)  
    );
           
    // VGA output generation logic 
    always @ (posedge CLK) begin
        if (RST) begin
            VGA_R <= 4'b0000;
            VGA_G <= 4'b0000;
            VGA_B <= 4'b0000;               
        end else if (active) begin
          // Roads, cars and objects
          if ((x >= 239-2 && x <= 239+2) || (x >= 279-1 && x <= 279+1) || (x >= 319-2 && x <= 319+2) || (x >= 359-1 && x <= 359+1) || (x >= 399-2 && x <= 399+2)) begin
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
          end else if (object_generated && object_is_square && red_square_enable) begin
              VGA_R <= red_square_palette[dataout_red_square][11:8];
              VGA_G <= red_square_palette[dataout_red_square][7:4];
              VGA_B <= red_square_palette[dataout_red_square][3:0]; // Red square for car1
          end else if (object_generated && object_is_square2 && blue_square_enable) begin  
              VGA_R <= blue_square_palette[dataout_blue_square][11:8];
              VGA_G <= blue_square_palette[dataout_blue_square][7:4];
              VGA_B <= blue_square_palette[dataout_blue_square][3:0]; // blue square for car2
          end else if (object_generated && ~object_is_square && red_circle_enable) begin 
              VGA_R <= red_circle_palette[dataout_red_circle][11:8];
              VGA_G <= red_circle_palette[dataout_red_circle][7:4];
              VGA_B <= red_circle_palette[dataout_red_circle][3:0]; // red circle for car1
          end else if (object_generated && ~object_is_square2 && blue_circle_enable) begin
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
                     
    car_movement cm(
         .CLK(CLK),
         .RST(RST),
         .switch_b(switch_b),
         .car1_x(car1_x),
         .car2_x(car2_x)
     );           
     
     wire [3:0] w_1s, w_10s, w_100s, w_1000s;
     
     digits digs(.score(score), .reset(RST || ~on_off || start_game || reset_game), .ones(w_1s), 
                 .tens(w_10s), .hundreds(w_100s), .thousands(w_1000s));
     
     seg7_control seg7(.clk_100MHz(CLK), .reset(RST || ~on_off), .ones(w_1s), .tens(w_10s),
                       .hundreds(w_100s), .thousands(w_1000s), .seg(seg), .digit(digit));
endmodule

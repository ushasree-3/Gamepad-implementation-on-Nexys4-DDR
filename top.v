`default_nettype none
`include "game_parameters.v"

module top (
    input wire CLK,            // 100 MHz
    input wire RST,            // System reset
    input wire [1:0] switch_b, // switches for car path
    input wire on_off,         // for obstacle generation  
    input wire start_game,     // start game  (to Play State)
    input wire reset_game,     // reset game  (to Start State)
    output wire VGA_HS_O,      // Horizontal sync output
    output wire VGA_VS_O,      // Vertical sync output
    output reg [3:0] VGA_R,     
    output reg [3:0] VGA_G,     
    output reg [3:0] VGA_B,
    output wire [0:6] seg,      // 7 segment display segment pattern
    output wire [3:0] digit 
);
         
     wire [1:0] current_state,next_state;
     wire end_game;
     
     state_machine state_inst(
         .CLK(CLK),
         .RST(RST),
         .start_game(start_game),
         .reset_game(reset_game),
         .end_game(end_game),
         .current_state(current_state),
         .next_state(next_state)
     );
         
    // generating a 25 MHz pixel strobe and 
    reg [15:0] cnt;
    reg [16:0] cnt1;
    reg pix_stb;
    reg pix_stb1;
    
    always @(posedge CLK) begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
        {pix_stb1, cnt1} <= cnt1 + 17'b1;  // divide by 2^16
    end
    //
    
    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire active;   // high during active pixel drawing

    vga display (
        .i_clk(CLK), 
        .i_pix_stb(pix_stb),
        .i_rst(RST),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y),
        .o_active(active)
    );
                   
    wire [3:0] start_VGA_R, start_VGA_G, start_VGA_B;
    wire [3:0] end_VGA_R, end_VGA_G, end_VGA_B;
    wire [3:0] game_VGA_R, game_VGA_G, game_VGA_B;   
    
    start_screen start_inst(
        .clk(CLK),           
        .reset(RST),         
        .active(active),
        .x(x),
        .y(y),
        .VGA_R(start_VGA_R),     
        .VGA_G(start_VGA_G),     
        .VGA_B(start_VGA_B)
     );
     
     game game_inst(
        .CLK(CLK),         
        .RST(RST),            
        .pix_stb1(pix_stb1),
        .active(active),
        .x(x),
        .y(y),
        .switch_b(switch_b), 
        .on_off(on_off),         
        .start_game(start_game),    
        .reset_game(reset_game),     
        .end_game(end_game),     
        .VGA_R(game_VGA_R),     
        .VGA_G(game_VGA_G),     
        .VGA_B(game_VGA_B),
        .seg(seg),     
        .digit(digit) 
    );

    end_screen end_inst(
        .clk(CLK),            
        .reset(RST),          
        .active(active),
        .x(x),
        .y(y),
        .VGA_R(end_VGA_R),     
        .VGA_G(end_VGA_G),     
        .VGA_B(end_VGA_B)
     );   

    always @* begin
        case (current_state)
                Start_state: begin
                    VGA_R <= start_VGA_R;
                    VGA_G <= start_VGA_G;
                    VGA_B <= start_VGA_B;   
 
                end
                Play_state: begin   
                    VGA_R <= game_VGA_R;
                    VGA_G <= game_VGA_G;
                    VGA_B <= game_VGA_B;   
                end
                End_state: begin 
                    VGA_R <= end_VGA_R;
                    VGA_G <= end_VGA_G;
                    VGA_B <= end_VGA_B; 
                end
                default: begin
                    VGA_R <= 4'b1111;
                    VGA_G <= 4'b1111;
                    VGA_B <= 4'b1111;
                end
         endcase
    end

endmodule

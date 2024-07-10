module end_sprite (
    input wire CLK,            // Clock
    input wire RST,            // Reset
    input wire [9:0] x,        // Current pixel x position
    input wire [8:0] y,        // Current pixel y position
    input wire [9:0] end_sprite_x, // Sprite x position
    input wire [8:0] end_sprite_y, // Sprite y position
    output reg [11:0] end_sprite_data_out,  // Sprite data output
    output reg end_sprite_enable   // Enable signal for sprite
);

    // Define the width and height of the sprite
    parameter END_WIDTH = 272;
    parameter END_HEIGHT = 138;

    // Register declarations for sprite pixel indices
    integer end_sprite_x_index;
    integer end_sprite_y_index;
    integer end_sprite_index;

    // Example: Initialize sprite data
    reg [11:0] end_sprite_data [0:END_WIDTH*END_HEIGHT-1]; // Example sprite data array

    initial begin
        $readmemh("end.mem", end_sprite_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            end_sprite_enable <= 0;
            end_sprite_data_out <= 0;
        end else begin
            if (x >= end_sprite_x && x < end_sprite_x + END_WIDTH &&
                y >= end_sprite_y && y < end_sprite_y + END_HEIGHT) begin
                // Enable sprite rendering within the sprite bounds
                end_sprite_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                end_sprite_x_index = x - end_sprite_x;
                end_sprite_y_index = y - end_sprite_y;
                end_sprite_index = end_sprite_y_index * END_WIDTH + end_sprite_x_index;

                // Fetch sprite pixel data
                end_sprite_data_out <= end_sprite_data[end_sprite_index];
            end else begin
                end_sprite_enable <= 0;
                end_sprite_data_out <= 0;
            end
        end
    end
endmodule
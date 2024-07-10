module sprite_module (
    input wire CLK,            // Clock
    input wire RST,            // Reset
    input wire [9:0] x,        // Current pixel x position
    input wire [8:0] y,        // Current pixel y position
    input wire [9:0] sprite_x, // Sprite x position
    input wire [8:0] sprite_y, // Sprite y position
    output reg [11:0] sprite_data_out,  // Sprite data output
    output reg sprite_enable   // Enable signal for sprite
);

    // Define the width and height of the sprite
    parameter SPRITE_WIDTH = 100;
    parameter SPRITE_HEIGHT = 75;

    // Register declarations for sprite pixel indices
    integer sprite_x_index;
    integer sprite_y_index;
    integer sprite_index;

    // Example: Initialize sprite data
    reg [11:0] sprite_data [0:SPRITE_WIDTH*SPRITE_HEIGHT-1]; // Example sprite data array

    initial begin
        $readmemh("end.mem", sprite_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            sprite_enable <= 0;
            sprite_data_out <= 0;
        end else begin
            if (x >= sprite_x && x < sprite_x + SPRITE_WIDTH &&
                y >= sprite_y && y < sprite_y + SPRITE_HEIGHT) begin
                // Enable sprite rendering within the sprite bounds
                sprite_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                sprite_x_index = x - sprite_x;
                sprite_y_index = y - sprite_y;
                sprite_index = sprite_y_index * SPRITE_WIDTH + sprite_x_index;

                // Fetch sprite pixel data
                sprite_data_out <= sprite_data[sprite_index];
            end else begin
                sprite_enable <= 0;
            end
        end
    end
endmodule
module blue_square (
    input wire CLK,                  // Clock
    input wire RST,                  // Reset
    input wire [9:0] x,              // Current pixel x position
    input wire [8:0] y,              // Current pixel y position
    input wire [9:0] blue_square_x,  // Sprite x position
    input wire [8:0] blue_square_y,  // Sprite y position
    output reg [11:0] blue_square_data_out,  // Sprite data output
    output reg blue_square_enable           // Enable signal for sprite
);

    // Define the width and height of the sprite (blue square)
    parameter BLUE_SQUARE_WIDTH = 14;
    parameter BLUE_SQUARE_HEIGHT = 14;

    // Register declarations for sprite pixel indices
    integer blue_square_x_index;
    integer blue_square_y_index;
    integer blue_square_index;

    // Example: Initialize sprite data for blue square
    reg [11:0] blue_square_data [0:BLUE_SQUARE_WIDTH*BLUE_SQUARE_HEIGHT-1];

    initial begin
            $readmemh("blue_square.mem", blue_square_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            blue_square_enable <= 0;
            blue_square_data_out <= 0;
        end else begin
            if (x >= blue_square_x && x < blue_square_x + BLUE_SQUARE_WIDTH &&
                y >= blue_square_y && y < blue_square_y + BLUE_SQUARE_HEIGHT) begin
                // Enable sprite rendering within the sprite bounds
                blue_square_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                blue_square_x_index = x - blue_square_x;
                blue_square_y_index = y - blue_square_y;
                blue_square_index = blue_square_y_index * BLUE_SQUARE_WIDTH + blue_square_x_index;

                // Fetch sprite pixel data
                blue_square_data_out <= blue_square_data[blue_square_index];
            end else begin
                blue_square_enable <= 0;
                blue_square_data_out <= 0;
            end
        end
    end
endmodule

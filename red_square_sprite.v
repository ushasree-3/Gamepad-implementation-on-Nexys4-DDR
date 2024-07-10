module red_square (
    input wire CLK,                  // Clock
    input wire RST,                  // Reset
    input wire [9:0] x,              // Current pixel x position
    input wire [8:0] y,              // Current pixel y position
    input wire [9:0] red_square_x,   // Sprite x position
    input wire [8:0] red_square_y,   // Sprite y position
    output reg [11:0] red_square_data_out,    // Sprite data output
    output reg red_square_enable               // Enable signal for sprite
);

    // Define the width and height of the sprite (red square)
    parameter RED_SQUARE_WIDTH = 14;
    parameter RED_SQUARE_HEIGHT = 14;

    // Register declarations for sprite pixel indices
    integer red_square_x_index;
    integer red_square_y_index;
    integer red_square_index;

    // Example: Initialize sprite data for red square
    reg [11:0] red_square_data [0:RED_SQUARE_WIDTH*RED_SQUARE_HEIGHT-1];

    initial begin
            $readmemh("red_square.mem", red_square_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            red_square_enable <= 0;
            red_square_data_out <= 0;
        end else begin
            if (x >= red_square_x && x < red_square_x + RED_SQUARE_WIDTH &&
                y >= red_square_y && y < red_square_y + RED_SQUARE_HEIGHT) begin
                // Enable sprite rendering within the sprite bounds
                red_square_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                red_square_x_index = x - red_square_x;
                red_square_y_index = y - red_square_y;
                red_square_index = red_square_y_index * RED_SQUARE_WIDTH + red_square_x_index;

                // Fetch sprite pixel data
                red_square_data_out <= red_square_data[red_square_index];
            end else begin
                red_square_enable <= 0;
                red_square_data_out <= 0;
            end
        end
    end
endmodule

module cars (
    input wire CLK,            // Clock
    input wire RST,            // Reset
    input wire [9:0] x,        // Current pixel x position
    input wire [8:0] y,        // Current pixel y position
    input wire [9:0] cars_x, // Sprite x position
    input wire [8:0] cars_y, // Sprite y position
    output reg [11:0] cars_data_out,  // Sprite data output
    output reg cars_enable   // Enable signal for sprite
);

    // Define the width and height of the sprite
    parameter CARS_WIDTH = 272;
    parameter CARS_HEIGHT = 138;

    // Register declarations for sprite pixel indices
    integer cars_x_index;
    integer cars_y_index;
    integer cars_index;

    // Example: Initialize sprite data
    reg [11:0] cars_data [0:CARS_WIDTH*CARS_HEIGHT-1]; // Example sprite data array

    initial begin
        $readmemh("2_cars.mem", cars_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            cars_enable <= 0;
            cars_data_out <= 0;
        end else begin
            if (x >= cars_x && x < cars_x + CARS_WIDTH &&
                y >= cars_y && y < cars_y + CARS_HEIGHT) begin
                // Enable sprite rendering within the sprite bounds
                cars_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                cars_x_index = x - cars_x;
                cars_y_index = y - cars_y;
                cars_index = cars_y_index * CARS_WIDTH + cars_x_index;

                // Fetch sprite pixel data
                cars_data_out <= cars_data[cars_index];
            end else begin
                cars_enable <= 0;
                cars_data_out <= 0;
            end
        end
    end
endmodule
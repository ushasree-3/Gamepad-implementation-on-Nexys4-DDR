module blue_car (
    input wire CLK,            // Clock
    input wire RST,            // Reset
    input wire [9:0] x,        // Current pixel x position
    input wire [8:0] y,        // Current pixel y position
    input wire [9:0] blue_car_x, // Sprite x position
    input wire [8:0] blue_car_y, // Sprite y position
    output reg [11:0] blue_car_data_out,  // Sprite data output
    output reg blue_car_enable   // Enable signal for sprite
);

    // Define the width and height of the sprite
    parameter BLUE_CAR_WIDTH = 17;
    parameter BLUE_CAR_HEIGHT = 34;

    // Register declarations for sprite pixel indices
    integer blue_car_x_index;
    integer blue_car_y_index;
    integer blue_car_index;

    // Example: Initialize sprite data
    reg [11:0] blue_car_data [0:BLUE_CAR_WIDTH*BLUE_CAR_HEIGHT-1]; // Example sprite data array

    initial begin
        $readmemh("blue_car.mem", blue_car_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            blue_car_enable <= 0;
            blue_car_data_out <= 0;
        end else begin
            if (x >= blue_car_x && x < blue_car_x + BLUE_CAR_WIDTH &&
                y >= blue_car_y && y < blue_car_y + BLUE_CAR_HEIGHT) begin
                // Enable sprite rendering within the sprite bounds
                blue_car_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                blue_car_x_index = x - blue_car_x;
                blue_car_y_index = y - blue_car_y;
                blue_car_index = blue_car_y_index * BLUE_CAR_WIDTH + blue_car_x_index;

                // Fetch sprite pixel data
                blue_car_data_out <= blue_car_data[blue_car_index];
            end else begin
                blue_car_enable <= 0;
                blue_car_data_out <= 0;
            end
        end
    end
endmodule
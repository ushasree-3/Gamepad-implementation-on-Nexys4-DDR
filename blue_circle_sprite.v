module blue_circle (
    input wire CLK,                  // Clock
    input wire RST,                  // Reset
    input wire [9:0] x,              // Current pixel x position
    input wire [8:0] y,              // Current pixel y position
    input wire [9:0] blue_circle_x,  // Sprite x position (center of circle)
    input wire [8:0] blue_circle_y,  // Sprite y position (center of circle)
    output reg [11:0] blue_circle_data_out, // Sprite data output
    output reg blue_circle_enable     // Enable signal for sprite
);

    // Define the radius of the circle
    parameter BLUE_CIRCLE_RADIUS = 8;

    // Register declarations for sprite pixel indices
    integer blue_circle_x_index;
    integer blue_circle_y_index;
    integer blue_circle_index;

    // Example: Initialize sprite data for blue circle
    reg [11:0] blue_circle_data [0:(2*BLUE_CIRCLE_RADIUS*2*BLUE_CIRCLE_RADIUS)-1];

    initial begin
        $readmemh("blue_circle.mem", blue_circle_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            blue_circle_enable <= 0;
            blue_circle_data_out <= 0;
        end else begin
            if ((x - blue_circle_x)*(x - blue_circle_x) + (y - blue_circle_y)*(y - blue_circle_y) <= BLUE_CIRCLE_RADIUS*BLUE_CIRCLE_RADIUS) begin
                // Enable sprite rendering within the circle bounds
                blue_circle_enable <= 1;

                // Calculate sprite pixel index based on x, y coordinates
                blue_circle_x_index = x - (blue_circle_x - BLUE_CIRCLE_RADIUS);
                blue_circle_y_index = y - (blue_circle_y - BLUE_CIRCLE_RADIUS);
                blue_circle_index = blue_circle_y_index * (2*BLUE_CIRCLE_RADIUS) + blue_circle_x_index;

                // Fetch sprite pixel data
                blue_circle_data_out <= blue_circle_data[blue_circle_index];
            end else begin
                blue_circle_enable <= 0;
                blue_circle_data_out <= 0;
            end
        end
    end
endmodule

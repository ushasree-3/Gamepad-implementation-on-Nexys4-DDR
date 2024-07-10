module red_circle (
    input wire CLK,                  // Clock
    input wire RST,                  // Reset
    input wire [9:0] x,              // Current pixel x position
    input wire [8:0] y,              // Current pixel y position
    input wire [9:0] red_circle_x,   // Sprite x position
    input wire [8:0] red_circle_y,   // Sprite y position
    output reg [11:0] red_circle_data_out,    // Sprite data output
    output reg red_circle_enable               // Enable signal for sprite
);

    // Define the radius of the red circle
    parameter RED_CIRCLE_RADIUS = 8; // Assuming a circle with a radius of 7 pixels

    // Register declarations for sprite pixel indices
    integer red_circle_x_index;
    integer red_circle_y_index;
    integer red_circle_index;

    // Example: Initialize sprite data for red circle
    reg [11:0] red_circle_data [0:(2*RED_CIRCLE_RADIUS*2*RED_CIRCLE_RADIUS)-1];

    initial begin
            $readmemh("red_circle.mem", red_circle_data); // Initialize with sprite data
    end

    // Sprite rendering logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            red_circle_enable <= 0;
            red_circle_data_out <= 0;
        end else begin
                if ((x - red_circle_x)*(x - red_circle_x) + (y - red_circle_y)*(y - red_circle_y) <= RED_CIRCLE_RADIUS*RED_CIRCLE_RADIUS) begin
                    // Enable sprite rendering within the circle bounds
                    red_circle_enable <= 1;
    
                    // Calculate sprite pixel index based on x, y coordinates
                    red_circle_x_index = x - (red_circle_x - RED_CIRCLE_RADIUS);
                    red_circle_y_index = y - (red_circle_y - RED_CIRCLE_RADIUS);
                    red_circle_index = red_circle_y_index * (2*RED_CIRCLE_RADIUS) +red_circle_x_index;

                // Fetch sprite pixel data
                red_circle_data_out <= red_circle_data[red_circle_index];
            end else begin
                red_circle_enable <= 0;
                red_circle_data_out <= 0;
            end
        end
    end
endmodule

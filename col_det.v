module collision_detector (
    input wire clk,
    input wire rst,
    input wire [9:0] car1_x,
    input wire [9:0] car2_x,
    input wire [8:0] car_y,
    input wire object_is_square,
    input wire object_is_square2,
    input wire [9:0] object_x,
    input wire [9:0] object_x2,
    input wire [8:0] object_y,
    output reg score,  
    output reg end_game
);

    always @(posedge clk or posedge rst) begin
        
        if (rst) begin
            score <= 0;
            end_game<=0;
        
        end else begin
            if ((object_is_square && object_y >= car_y && object_y <= car_y + 34 &&
                 (object_x - 6 >= car1_x && object_x + 6 <= car1_x + 17)) || (object_is_square2 && object_y >= car_y && object_y <= car_y + 34 &&
                 (object_x2 - 6 >= car2_x && object_x2 + 6 <= car2_x + 17)) || (~object_is_square && object_y >= car_y && object_y <= car_y + 34 &&
                 ~(object_x - 6 >= car1_x && object_x + 6 <= car1_x + 17)) || (~object_is_square2 && object_y >= car_y && object_y <= car_y + 34 &&
                 ~(object_x2 - 6 >= car2_x && object_x2 + 6 <= car2_x + 17))) begin
              // Collision case 
                score <= 0; 
                end_game <= 1;
                
            end else if (~object_is_square && object_y >= car_y && object_y <= car_y + 34 &&
                  (object_x - 6 >= car1_x && object_x + 6 <= car1_x + 17)) begin
                // Scoring case of car1
                  score <= 1; 
                  end_game <= 0;
                  
            end else if (~object_is_square2 && object_y >= car_y && object_y <= car_y + 34 &&
                   (object_x2 - 6 >= car2_x && object_x2 + 6 <= car2_x + 17)) begin
                   // Scoring case of car2
                   score <= 1; 
                   end_game <= 0;
            
            end else begin
                score <= 0;
                end_game <= 0;
            end
       end
    end
endmodule

module object_generator (
    input wire pix_stb1,
    input wire RST,
    input wire active,
    input wire [2:0] rand,
    input wire end_game,
    output reg [9:0] object_x,
    output reg [9:0] object_x2,
    output reg [8:0] object_y,
    output reg object_generated,
    output reg object_is_square,
    output reg object_is_square2,
    output reg path,
    output reg path2
);

   initial object_generated = 0;
   parameter OBJECT_SPEED = 1; // Speed of object movement
   reg [9:0] delay_counter;
   reg delay_done;
   
   always @(posedge pix_stb1 or posedge RST or posedge end_game) begin
     
         if (RST || end_game) begin
             object_generated <= 1'b0;
             delay_counter <= 0;
             delay_done <= 0;
             object_y <= 0;
             
         end else begin
         if (active && ~object_generated && ~delay_done) begin // delay of 2 seconds for first object generation 
             delay_counter <= delay_counter + 1;
             if (delay_counter == 500) begin
                delay_done <= 1;
             end
             else delay_done <= 0;
         end if (active && ~object_generated && delay_done|| (active && object_generated && object_y > 486)) begin //366
             // generates the object randomly and on different paths
             object_generated <= 1'b1;
             object_is_square <= rand[1];
             path <= rand[0];
             object_is_square2 <= rand[2];
             path2 <= rand[1];
             object_x <= path ? 10'd299:10'd259; 
             object_x2 <= path2 ? 10'd378:10'd339;
             object_y <= 9'd9; 
             delay_counter <= 0;
             delay_done <= 0;
         end else if (active && object_generated && object_y < 390) begin //288
             // increment the y position for object
             object_y <= object_y + OBJECT_SPEED;       
         end else if (active && object_generated && object_y >= 390) begin //288
            if (end_game) begin // Collision detected
              object_generated <= 1'b0; 
              delay_counter <= 0;
              delay_done <= 0; 
              object_y <= 0;        
            end else begin // No collision
              object_y <= object_y + OBJECT_SPEED; 
            end
            
         end else object_y <= object_y;
       end  
    end

endmodule


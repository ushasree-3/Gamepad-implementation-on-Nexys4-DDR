// Reference : https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/How%20to%20Control%207%20Segment%20Display%20on%20Basys%203

module digits(
    input wire score,
    input wire reset,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
    );
    
    // ones position of score
    always @(posedge score or posedge reset) begin
        if(reset)
            ones <= 0;
        else begin
            if(ones == 9)
                ones <= 0;
            else
                ones <= ones + 1;
        end
    end 
        
    // tens position of score       
    always @(posedge score or posedge reset) begin
        if(reset)
            tens <= 0;
        else begin
            if(ones == 9) begin
                if(tens == 9)
                    tens <= 0;
                else
                    tens <= tens + 1;
            end
        end
    end 
     
    // hundreds position of score              
    always @(posedge score or posedge reset) begin
        if(reset)
            hundreds <= 0;
        else begin
            if(tens == 9 && ones == 9) begin
                if(hundreds == 9)
                    hundreds <= 0;
                else
                    hundreds <= hundreds + 1;
            end
        end
    end 
    // thousands position of score                
    always @(posedge score or posedge reset) begin
        if(reset)
            thousands <= 0;
        else begin
            if(hundreds == 9 && tens == 9 && ones == 9) begin
                if(thousands == 9)
                    thousands <= 0;
                else
                    thousands <= thousands + 1;
            end
        end
     end
  
endmodule
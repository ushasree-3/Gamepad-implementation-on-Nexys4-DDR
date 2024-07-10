`include "game_parameters.v"

module state_machine (
    input wire CLK,
    input wire RST,
    input wire start_game,
    input wire reset_game,
    input wire end_game,
    output wire [1:0] current_state,
    output wire [1:0] next_state
);
    reg [1:0] state_reg, state_next;

    // State transition logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state_reg <= Start_state;
        end else begin
            state_reg <= state_next;
        end
    end

    always @(*) begin
        case (state_reg)
            Start_state: begin
                if (start_game) state_next = Play_state;
                else state_next = Start_state;
            end
            Play_state: begin
                if (end_game) state_next = End_state;
                else if (reset_game) state_next = Start_state;
                else state_next = Play_state;
            end
            End_state: begin
                if (reset_game) state_next = Start_state;
                else if (start_game) state_next = Play_state;
                else state_next = End_state;
            end
            default: state_next = Start_state;
        endcase
    end

    // Output current state
    assign current_state = state_reg;
    assign next_state = state_next;

endmodule

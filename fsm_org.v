
module fsm_snake_ladder(
  input clk,
  input rstn,
  input [2:0] dice,
  output reg [5:0] pos,
  output reg [2:0] state
);
  reg start;

  parameter [2:0] S_reset = 3'b000,
                  S_dice = 3'b001,
                  S_chk_ladder = 3'b010,
                  S_chk_snake = 3'b011,
                  S_win = 3'b100,
                  S_wait = 3'b101;

  parameter [5:0]
    s1_h = 6'd16, s1_t = 6'd2,
    s2_h = 6'd20, s2_t = 6'd5,
    s3_h = 6'd25, s3_t = 6'd12,
    s4_h = 6'd31, s4_t = 6'd20,
    s5_h = 6'd34, s5_t = 6'd22,
    l1_s = 6'd6, l1_e = 6'd18,
    l2_s = 6'd11, l2_e = 6'd14,
    l3_s = 6'd15, l3_e = 6'd22,
    l4_s = 6'd21, l4_e = 6'd28,
    l5_s = 6'd23, l5_e = 6'd35;

  reg [2:0] ns, ps;
  reg [13:0] wait_counter;  // 14-bit counter to create real time delay

  always @(posedge clk or negedge rstn) begin
    if (!rstn)
      ps <= S_reset;
    else
      ps <= ns;
  end

  always @(posedge clk or negedge rstn) begin
    if (!rstn)
      wait_counter <= 14'd0;  // Reset counter on reset
    else if (ps == S_wait && wait_counter < 14'd1000)
      wait_counter <= wait_counter + 1;
    else
      wait_counter <= 14'd0;  // Reset counter when the wait is over
  end

  always @(*) begin
    case (ps)
      S_reset: begin
        ns = S_wait;
        pos = 6'd1;
        start = 0;
        $display("Game Reset! Player Position: %d", pos);
      end

      S_dice: begin
        if (!start && dice == 3'd1) begin
          start = 1;
          pos = 6'd2;
          $display("Game Started! Rolled a 1. Player Position: %d", pos);
          ns = S_wait;
        end else if (!start && dice != 3'd1) begin
          $display("Waiting for a 1 to start. Rolled: %d", dice);
          ns = S_wait;
        end else begin
          if (pos + dice >= 6'd36) begin
            if (pos + dice == 6'd36) begin
              pos = 6'd36;
              $display("Player Wins! Reached position 36. Player Position: %d", pos);
              ns = S_win;
            end else begin
              $display("Overshot position! Cannot move further. Player Position: %d", pos);
              ns = S_wait;
            end
          end else begin
            pos = pos + dice;
            $display("Player Moved! Rolled: %d. New Position: %d", dice, pos);
            ns = S_chk_snake;
          end
        end
      end

      S_chk_snake: begin
        case (pos)
          s1_h: pos = s1_t;
          s2_h: pos = s2_t;
          s3_h: pos = s3_t;
          s4_h: pos = s4_t;
          s5_h: pos = s5_t;
          default: ns = S_chk_ladder;
        endcase
        if (pos == s1_t || pos == s2_t || pos == s3_t || pos == s4_t || pos == s5_t) begin
          $display("Snake! Player Moved Down. New Position: %d", pos);
        end
        ns = S_chk_ladder;
      end

      S_chk_ladder: begin
        case (pos)
          l1_s: pos = l1_e;
          l2_s: pos = l2_e;
          l3_s: pos = l3_e;
          l4_s: pos = l4_e;
          l5_s: pos = l5_e;
          default: ns = S_wait;
        endcase
        if (pos == l1_e || pos == l2_e || pos == l3_e || pos == l4_e || pos == l5_e) begin
          $display("Ladder! Player Moved Up. New Position: %d", pos);
        end
        ns = S_wait;
      end

      S_win: begin
        $display("Player Reached Position 36 and Won! Game Over.");
        ns = S_wait;
        ns = S_reset;
      end

      S_wait: begin
        if (wait_counter == 14'd1000) begin             //ideally 1000
          $display("2.5 seconds elapsed. Transitioning to next state.");
          ns = S_dice;
        end else begin
          ns = S_wait;
        end
      end

      default: ns = S_reset;
    endcase
  end
endmodule
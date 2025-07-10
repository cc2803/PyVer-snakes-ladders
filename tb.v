`timescale 1s/1ms


module tb_snake_ladder();
    reg clk, rstn;
    reg [2:0] dice;
    wire [5:0] pos;
    wire [2:0] state;

    integer file, r;
    reg [7:0] buffer [0:31]; // Buffer to read the file contents
    fsm_snake_ladder dut(
        .clk(clk),
        .rstn(rstn),
        .dice(dice),
        .pos(pos),
        .state(state)
    );

    // Clock generation
    initial begin
        clk = 0; rstn = 0; dice = 0;
        #5 rstn = 1;
        forever #5 clk = ~clk;
    end

    // Reading from the file during each clock cycle
    always @(posedge clk) begin
        file = $fopen("dice.txt", "r");
        if (file) begin
            r = $fscanf(file, "%d\n", dice);  // Read dice value from the file
            $fclose(file);                    // Close the file after reading
        end
    end

    always @(posedge clk) begin
        file = $fopen("player_state.txt", "w");
        if (file) begin
            $fwrite(file, "%d\n", pos);       //write position value to file in 2nd line
            $fclose(file);                    // Close the file after reading
        end
    end

    // FSM outputs display for debugging
    always @(posedge clk) begin
        $display("Current Dice: %d, Position: %d", dice, pos);
    end
endmodule
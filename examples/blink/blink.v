/* 
 * Binary counter displayed on LEDs.
 */

module top (
		input  clk,
		input  sw1,
		input  sw2,
		input  sw3,
		input  sw4,
		input  sw5,
		input  sw6,
		input  sw7,
		input  sw8,
		output led1,
		output led2,
		output led3,
		output led4,
		output led5,
		output led6,
		output led7,
		output led8,
	);

	localparam BITS = 8;
	localparam LOG2DELAY = 20;

	reg [BITS+LOG2DELAY-1:0] counter = 0;
	reg [BITS-1:0] outcnt;

	always @(posedge clk) begin
		counter <= counter + 1;
		outcnt <= counter >> LOG2DELAY;
	end

	assign {led1, led2, led3, led4, led5, led6, led7, led8} = outcnt;
endmodule

//
// Copyright (c) 2016-2020 SiFive, Inc. -- Proprietary and Confidential
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of SiFive, Inc. The intellectual and technical concepts
// contained herein are proprietary to SiFive, Inc. and may be covered
// by U.S. and Foreign Patents, patents in process, and are protected by
// trade secret or copyright law.
//
// This work may not be copied, modified, re-published, uploaded,
// executed, or distributed in any way, in any medium, whether in whole
// or in part, without prior written permission from SiFive, Inc.
//
// The copyright notice above does not evidence any actual or intended
// publication or disclosure of this source code, which includes
// information that is confidential and/or proprietary, and is a trade
// secret, of SiFive, Inc.
//
// Instance ID: b21cef66-00f3-44d5-a188-807f478b1270, 00000000-0000-0000-0000-000000000000, 00000000-0000-0000-0000-000000000000
module _EVAL_129(
  output  _EVAL,
  input   _EVAL_0,
  input   _EVAL_1,
  input   _EVAL_2
);
  reg  _EVAL_3;
  reg [31:0] _RAND_0;
  reg  _EVAL_4;
  reg [31:0] _RAND_1;
  reg  _EVAL_5;
  reg [31:0] _RAND_2;
  assign _EVAL = _EVAL_4;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _EVAL_3 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _EVAL_4 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _EVAL_5 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  if (_EVAL_0) begin
    _EVAL_3 = 1'h0;
  end
  if (_EVAL_0) begin
    _EVAL_4 = 1'h0;
  end
  if (_EVAL_0) begin
    _EVAL_5 = 1'h0;
  end
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge _EVAL_1 or posedge _EVAL_0) begin
    if (_EVAL_0) begin
      _EVAL_3 <= 1'h0;
    end else begin
      _EVAL_3 <= _EVAL_5;
    end
  end
  always @(posedge _EVAL_1 or posedge _EVAL_0) begin
    if (_EVAL_0) begin
      _EVAL_4 <= 1'h0;
    end else begin
      _EVAL_4 <= _EVAL_3;
    end
  end
  always @(posedge _EVAL_1 or posedge _EVAL_0) begin
    if (_EVAL_0) begin
      _EVAL_5 <= 1'h0;
    end else begin
      _EVAL_5 <= _EVAL_2;
    end
  end
endmodule

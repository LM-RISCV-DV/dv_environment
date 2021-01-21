// Copyright lowRISC contributors.
// Copyright 2018 ETH Zurich and University of Bologna, see also CREDITS.md.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Trace executed instructions in simulation
 *
 * This tracer takes execution information from the RISC-V Verification Interface (RVFI) and
 * produces a text file with a human-readable trace.
 *
 * All traced instructions are written to a log file. By default, the log file is named
 * trace_core_<HARTID>.log, with <HARTID> being the 8 digit hart ID of the core being traced.
 *
 * The file name base, defaulting to "trace_core" can be set using the "ibex_tracer_file_base"
 * plusarg passed to the simulation, e.g. "+ibex_tracer_file_base=ibex_my_trace". The exact syntax
 * of passing plusargs to a simulation depends on the simulator.
 *
 * The trace contains six columns, separated by tabs:
 * - The simulation time
 * - The clock cycle count since reset
 * - The program counter (PC)
 * - The instruction
 * - The decoded instruction in the same format as objdump, together with the accessed registers and
 *   read/written memory values. Jumps and branches show the target address.
 *   This column may be omitted if the instruction does not decode into a long form.
 * - Accessed registers and memory locations.
 *
 * Significant effort is spent to make the decoding produced by this tracer as similar as possible
 * to the one produced by objdump. This simplifies the correlation between the static program
 * information from the objdump-generated disassembly, and the runtime information from this tracer.
 */
module tracer (
  input logic        clk_i,
  input logic        rst_ni,

  input logic [31:0] hart_id_i,

  // RVFI as described at https://github.com/SymbioticEDA/riscv-formal/blob/master/docs/rvfi.md
  // The standard interface does not have _i/_o suffixes. For consistency with the standard the
  // signals in this module don't have the suffixes either.
/*
  input logic [63:0] rvfi_order,
  input logic        rvfi_trap,
  input logic        rvfi_halt,
  input logic        rvfi_intr,
  input logic [ 1:0] rvfi_mode,
*/
  input logic        rvfi_valid,
  input logic        rvfi_rd_wren,
  input logic [31:0] rvfi_insn,
  input logic [ 4:0] rvfi_rs1_addr,
  input logic [ 4:0] rvfi_rs2_addr,
  input logic [31:0] rvfi_rs1_rdata,
  input logic [31:0] rvfi_rs2_rdata,
  input logic [ 4:0] rvfi_rd_addr,
  input logic [31:0] rvfi_rd_wdata,
  input logic [31:0] rvfi_pc_rdata,
  input logic [31:0] rvfi_pc_wdata,
  input logic [31:0] rvfi_mem_addr,
  input logic [ 3:0] rvfi_mem_rmask,
  input logic [ 3:0] rvfi_mem_wmask,
  input logic [31:0] rvfi_mem_rdata,
  input logic [31:0] rvfi_mem_wdata,
  input logic [4:0]  rf_rd_addr,                
  input logic [31:0] rf_rd_wdata,
  input logic rf_rd_wren
);

  // These signals are part of RVFI, but not used in this module currently.
  // Keep them as part of the interface to change the tracer more easily in the future. Assigning
  // these signals to unused_* signals marks them explicitly as unused, an annotation picked up by
  // linters, including Verilator lint.

/*
  logic [63:0] unused_rvfi_order = rvfi_order;
  logic        unused_rvfi_trap = rvfi_trap;
  logic        unused_rvfi_halt = rvfi_halt;
  logic        unused_rvfi_intr = rvfi_intr;
  logic [ 1:0] unused_rvfi_mode = rvfi_mode;
*/

  import tracer_pkg::*;

  int          file_handle;
  int          file_handle_rf;
  string       file_name;
  string       file_name_rf;

  int unsigned cycle;
  string       decoded_str;
  logic        insn_is_compressed;

  // Data items accessed during this instruction
  localparam RS1 = (1 << 0);
  localparam RS2 = (1 << 1);
  localparam RS3 = (1 << 2);
  localparam RD  = (1 << 3);
  localparam MEM = (1 << 4);
  logic [4:0] data_accessed;

  always @(posedge clk_i) begin
  	if (rvfi_valid) begin
    	printbuffer_dumpline();
    end
  end  
  function automatic void printbuffer_dumpline();
    string rvfi_insn_str;

    if (file_handle == 32'h0) begin
      string file_name_base = "trace_core";
      $value$plusargs("tracer_file_base=%s", file_name_base);
      $sformat(file_name, "%s_%h.log", file_name_base, hart_id_i);

      $display("%m: Writing execution trace to %s", file_name);
      file_handle = $fopen(file_name, "w");
      $fwrite(file_handle, "\t\t\tTime\t\t\tCycle\t\tPC\t\tInsn\tDecoded instruction\tRegister contents\n");
    end

    $fwrite(file_handle,"%t\t %d  %h\t %h\t\t %s=0x%08x\t %s:0x%08x\t %s:0x%08x\t", $time,cycle,rvfi_pc_rdata, rvfi_insn, reg_addr_to_str(rvfi_rd_addr), rvfi_rd_wdata, reg_addr_to_str(rvfi_rs1_addr), rvfi_rs1_rdata, reg_addr_to_str(rvfi_rs2_addr), rvfi_rs2_rdata);
    $fwrite(file_handle, "\n");
  endfunction

  always @(posedge clk_i) begin
  	if (rf_rd_wren) begin
      print_dumpline_rf_wren();
    end
  end  
  function automatic void print_dumpline_rf_wren();

    if (file_handle_rf == 32'h0) begin
      string file_name_base_rf = "rf_wren_trace_core";
      $value$plusargs("tracer_file_base_rf_wrenx=%s", file_name_base_rf);
      $sformat(file_name_rf, "%s_%h.log", file_name_base_rf, hart_id_i);
      $display("%m: Writing execution trace to %s", file_name_rf);
      file_handle_rf = $fopen(file_name_rf, "w");
      $fwrite(file_handle_rf, "\t\t\tTime\t\t\tDestination Register (rd)\n");
    end

    $fwrite(file_handle_rf,"%t\t\t %s=0x%08x\t", $time, reg_addr_to_str(~rf_rd_addr), rvfi_rd_wdata);
    $fwrite(file_handle_rf, "\n");

  endfunction
  
  // Format register address with "x" prefix, left-aligned to a fixed width of 3 characters.
  function automatic string reg_addr_to_str(input logic [4:0] addr);
    if (addr < 10) begin
      return $sformatf(" x%0d", addr);
    end else begin
      return $sformatf("x%0d", addr);
    end
  endfunction


endmodule   

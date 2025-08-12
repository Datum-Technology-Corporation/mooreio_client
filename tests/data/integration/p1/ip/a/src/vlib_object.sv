`include "uvm_macros.svh"
import uvm_pkg::*;

class vlib_object extends uvm_object;
  `uvm_object_utils(vlib_object)
  function new(string name="");
    super.new(name);
  endfunction
endclass
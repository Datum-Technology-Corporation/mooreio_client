// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_REG_ADAPTER_SV__
`define __UVMA_MPB_REG_ADAPTER_SV__


/**
 * Object that converts between UVM's abstract register operations (uvm_reg_bus_op) and uvma_mpb_access_seq_item_c.
 * @ingroup uvma_mpb_reg
 */
class uvma_mpb_reg_adapter_c extends uvmx_reg_adapter_c #(
   .T_CFG     (uvma_mpb_cfg_c  ),
   .T_CNTXT   (uvma_mpb_cntxt_c),
   .T_SEQ_ITEM(uvma_mpb_access_seq_item_c)
);

   `uvm_object_utils(uvma_mpb_reg_adapter_c)

   /**
    * Sets byte-enabled support.
    */
   function new(string name="uvma_mpb_reg_adapter");
      super.new(name);
      supports_byte_enable = 0;
   endfunction

   /**
    * Converts from UVM register operation to Matrix Peripheral Bus (uvma_mpb_access_seq_item_c) Sequence Item.
    */
   virtual function void reg2seq(const ref uvm_reg_bus_op rw, uvm_reg_item reg_item, ref uvma_mpb_access_seq_item_c seq_item);
      // pragma uvmx reg_adapter_reg2seq begin
      seq_item.op = (rw.kind == UVM_READ) ? UVMA_MPB_OP_READ : UVMA_MPB_OP_WRITE;
      seq_item.address = rw.addr;
      seq_item.data    = rw.data;
      // pragma uvmx reg_adapter_reg2seq end
   endfunction

   /**
    * Converts from Matrix Peripheral Bus (uvma_mpb_access_seq_item_c) Sequence Item to UVM register operation.
    */
   virtual function void seq2reg(const ref uvma_mpb_access_seq_item_c seq_item, ref uvm_reg_bus_op rw);
      // pragma uvmx reg_adapter_seq2reg begin
      rw.kind = (seq_item.op == UVMA_MPB_OP_READ) ? UVM_READ : UVM_WRITE;
      rw.addr = seq_item.address;
      rw.data = seq_item.data;
      if (seq_item.has_error()) begin
         rw.status = UVM_NOT_OK;
      end
      else begin
         rw.status = UVM_IS_OK;
      end
      // pragma uvmx reg_adapter_seq2reg end
   endfunction

   // pragma uvmx reg_adapter_methods begin
   // pragma uvmx reg_adapter_methods end

endclass


`endif // __UVMA_MPB_REG_ADAPTER_SV__
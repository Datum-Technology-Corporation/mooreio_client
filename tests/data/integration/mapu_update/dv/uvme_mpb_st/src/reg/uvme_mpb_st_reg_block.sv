// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_REG_BLOCK_SV__
`define __UVME_MPB_ST_REG_BLOCK_SV__


/**
 * Mock 32-bit Register with only a single 32-bit Register Field.
 * @ingroup uvme_mpb_st_reg
 */
class uvme_mpb_st_full_reg_c extends uvmx_reg_c;

   rand uvmx_reg_field_c  full; ///< 32-bit wide Mock Register Field.


   `uvm_object_utils_begin(uvme_mpb_st_full_reg_c)
      `uvm_field_object(full, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_full_reg", int unsigned n_bits=32, int has_coverage=UVM_NO_COVERAGE);
      super.new(name, n_bits, has_coverage);
   endfunction

   /**
    * Creates and configures Register Fields.
    */
   virtual function void build();
      full = uvmx_reg_field_c::type_id::create("full");
      full.configure(
         .parent                 (this),
         .size                   (  32),
         .lsb_pos                (   0),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );endfunction

endclass


/**
 * Mock 32-bit Register with many Register fields of different sizes.  Some non-byte aligned.
 * @ingroup uvme_mpb_st_reg
 */
class uvme_mpb_st_split_reg_c extends uvmx_reg_c;

   rand uvmx_reg_field_c  abc; ///< 2 bytes
   rand uvmx_reg_field_c  def; ///< 1 bytes
   rand uvmx_reg_field_c  ghi; ///< 4 bits
   rand uvmx_reg_field_c  jkl; ///< 2 bits
   rand uvmx_reg_field_c  mno; ///< 1 bits
   rand uvmx_reg_field_c  pqr; ///< 1 bits


   `uvm_object_utils_begin(uvme_mpb_st_split_reg_c)
      `uvm_field_object(abc, UVM_DEFAULT)
      `uvm_field_object(def, UVM_DEFAULT)
      `uvm_field_object(ghi, UVM_DEFAULT)
      `uvm_field_object(jkl, UVM_DEFAULT)
      `uvm_field_object(mno, UVM_DEFAULT)
      `uvm_field_object(pqr, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_split_reg", int unsigned n_bits=32, int has_coverage=UVM_NO_COVERAGE);
      super.new(name, n_bits, has_coverage);
   endfunction

   /**
    * Creates and configures register fields.
    */
   virtual function void build();
      abc = uvmx_reg_field_c::type_id::create("abc");
      abc.configure(
         .parent                 (this),
         .size                   (  16),
         .lsb_pos                (   0),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );
      def = uvmx_reg_field_c::type_id::create("def");
      def.configure(
         .parent                 (this),
         .size                   (   8),
         .lsb_pos                (  16),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );
      ghi = uvmx_reg_field_c::type_id::create("ghi");
      ghi.configure(
         .parent                 (this),
         .size                   (   4),
         .lsb_pos                (  24),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );
      jkl = uvmx_reg_field_c::type_id::create("jkl");
      jkl.configure(
         .parent                 (this),
         .size                   (   2),
         .lsb_pos                (  28),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );
      mno = uvmx_reg_field_c::type_id::create("mno");
      mno.configure(
         .parent                 (this),
         .size                   (   1),
         .lsb_pos                (  30),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );
      pqr = uvmx_reg_field_c::type_id::create("pqr");
      pqr.configure(
         .parent                 (this),
         .size                   (   1),
         .lsb_pos                (  31),
         .access                 ("RW"),
         .volatile               (   0),
         .reset                  (   0),
         .has_reset              (   1),
         .is_rand                (   1),
         .individually_accessible(   0)
      );
   endfunction

endclass


/**
 * Mock 32-bit Register Block for testing uvma_mpb_reg_adapter_c.
 * @ingroup uvme_mpb_st_reg
 */
class uvme_mpb_st_reg_block_c extends uvmx_reg_block_c;

   rand uvme_mpb_st_full_reg_c   full ; ///< Full Register.
   rand uvme_mpb_st_split_reg_c  split; ///< Split Register.


   `uvm_object_utils_begin(uvme_mpb_st_reg_block_c)
      `uvm_field_object(full , UVM_DEFAULT)
      `uvm_field_object(split, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_reg_block", int has_coverage=UVM_NO_COVERAGE);
      super.new(name, has_coverage);
   endfunction

   /**
    * Creates Register(s).
    */
   virtual function void create_regs();
      full = uvme_mpb_st_full_reg_c::type_id::create("full");
      full.configure(this);
      full.build();
      split = uvme_mpb_st_split_reg_c::type_id::create("split");
      split.configure(this);
      split.build();
   endfunction

   /**
    * Creates address maps.
    */
   virtual function void create_maps();
      default_map = create_map(
         .name     ("default_map"),
         .base_addr(0),
         .n_bytes  (4),
         .endian   (UVM_LITTLE_ENDIAN)
      );
   endfunction

   /**
    * Adds Register(s) to Register map.
    */
   virtual function void add_regs_to_map();
      default_map.add_reg(
         .rg    (full),
         .offset(32'h00_00_00_00),
         .rights("RW")
      );
      default_map.add_reg(
         .rg    (split),
         .offset(32'h00_00_00_04),
         .rights("RW")
      );
   endfunction

endclass


`endif // _UVME_MPB_ST_REG_BLOCK_SV__
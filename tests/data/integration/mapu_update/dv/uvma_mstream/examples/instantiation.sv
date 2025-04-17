// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This file contains sample code that demonstrates how to add an instance of the Matrix Stream Interface UVM Agent to an example UVMx environment.
// NOTE: It is recommended to split up classes into separate files.


`ifndef __UVME_EXAMPLE_ENV_CFG_SV__
`define __UVME_EXAMPLE_ENV_CFG_SV__


/**
 * Object encapsulating all configuration information for uvme_example_env_c.
 */
class uvme_example_env_cfg_c extends uvmx_env_cfg_c;

   rand uvma_mstream_cfg_c  mstream_agent_cfg; ///< Handle to Matrix Stream Interface Agent configuration

   `uvm_object_utils_begin(uvme_example_env_cfg_c)
      `uvm_field_object(mstream_agent_cfg, UVM_DEFAULT)
   `uvm_object_utils_end

   constraint defaults_cons {
      soft mstream_agent_cfg.enabled == 1;
   }

   function new(uvm_component parent=null, string name="uvme_example_env_cfg");
      super.new(parent, name);
   endfunction

   virtual function void create_objects();
      mstream_agent_cfg = uvma_mstream_cfg_c::type_id::create("mstream_agent_cfg");
   endfunction

endclass


`endif // __UVME_EXAMPLE_ENV_CFG_SV__


`ifndef __UVME_EXAMPLE_ENV_CNTXT_SV__
`define __UVME_EXAMPLE_ENV_CNTXT_SV__


/**
 * Object encapsulating all state variables for uvme_example_env_c.
 */
class uvme_example_env_cntxt_c extends uvmx_env_cntxt_c;

   uvma_mstream_cntxt_c  mstream_agent_cntxt; ///< Handle to Matrix Stream Interface Agent context

   `uvm_object_utils_begin(uvme_example_env_cntxt_c)
      `uvm_field_object(mstream_agent_cntxt, UVM_DEFAULT)
   `uvm_object_utils_end

   function new(uvm_component parent=null, string name="uvme_example_env_cntxt");
      super.new(parent, name);
   endfunction

   virtual function void create_objects();
      mstream_agent_cntxt = uvma_mstream_cntxt_c::type_id::create("mstream_agent_cntxt");
   endfunction

endclass


`endif // __UVME_EXAMPLE_ENV_CNTXT_SV__


`ifndef __UVME_EXAMPLE_ENV_SV__
`define __UVME_EXAMPLE_ENV_SV__


/**
 * Component encapsulating the environment.
 */
class uvme_example_env_c extends uvmx_env_c #(
   .T_CFG      (uvme_example_env_cfg_c      ),
   .T_CNTXT    (uvme_example_env_cntxt_c    ),
   .T_SQR      (uvme_example_env_sqr_c      ),
   .T_PRD      (uvme_example_env_prd_c      ),
   .T_SB       (uvme_example_env_sb_c       ),
   .T_COV_MODEL(uvme_example_env_cov_model_c)
);

   uvma_mstream_agent_c  mstream_agent; ///< Matrix Stream Interface Agent instance.

   `uvm_component_utils(uvme_example_env_c)

   function new(uvm_component parent=null, string name="uvme_example_env");
      super.new(parent, name);
   endfunction

   virtual function void assign_cfg();
      uvm_config_db#(uvma_mstream_cfg_c)::set(this, "mstream_agent", "cfg", cfg.mstream_agent_cfg);
   endfunction

   virtual function void assign_cntxt();
      uvm_config_db#(uvma_mstream_cntxt_c)::set(this, "mstream_agent", "cntxt", cfg.mstream_agent_cntxt);
   endfunction

   virtual function void create_agents();
      mstream_agent = uvma_mstream_agent_c::type_id::create("mstream_agent", this);
   endfunction

endclass


`endif // __UVME_EXAMPLE_ENV_SV__
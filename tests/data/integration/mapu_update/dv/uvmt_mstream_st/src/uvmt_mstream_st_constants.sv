// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MSTREAM_ST_CONSTANTS_SV__
`define __UVMT_MSTREAM_ST_CONSTANTS_SV__


const int unsigned uvmt_mstream_st_default_sys_clk_frequency = 100000000; ///< Default System frequency ()
// pragma uvmx constants begin
const int unsigned uvmt_mstream_st_default_startup_timeout          =      10_000; ///< Default Heartbeat Monitor startup timeout in ns
const int unsigned uvmt_mstream_st_default_heartbeat_period         =       1_000; ///< Default Heartbeat Monitor period in ns
const int unsigned uvmt_mstream_st_default_heartbeat_refresh_period =       5_000; ///< Default Heartbeat Monitor refresh period in ns
const int unsigned uvmt_mstream_st_default_simulation_timeout       =  10_000_000; ///< Default Watchdog Timer simulation timeout in ns
// pragma uvmx constants end


`endif // __UVMT_MSTREAM_ST_CONSTANTS_SV__
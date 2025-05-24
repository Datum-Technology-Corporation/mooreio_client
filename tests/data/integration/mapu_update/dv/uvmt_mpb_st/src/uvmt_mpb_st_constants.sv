// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_CONSTANTS_SV__
`define __UVMT_MPB_ST_CONSTANTS_SV__


const int unsigned uvmt_mpb_st_default_clock_frequency = 100000000; ///< Default Clock frequency (100.0 MHZ)
const int unsigned uvmt_mpb_st_default_simulation_timeout = 10000000; ///< Default Watchdog Timer simulation timeout in ns
const int unsigned uvmt_mpb_st_default_startup_timeout = 10000; ///< Default Heartbeat Monitor startup timeout in ns
const int unsigned uvmt_mpb_st_default_heartbeat_period = 1000; ///< Default Heartbeat Monitor period in ns
const int unsigned uvmt_mpb_st_default_heartbeat_refresh_period = 5000; ///< Default Heartbeat Monitor refresh period in ns

// pragma uvmx constants begin
// pragma uvmx constants end



`endif // __UVMT_MPB_ST_CONSTANTS_SV__
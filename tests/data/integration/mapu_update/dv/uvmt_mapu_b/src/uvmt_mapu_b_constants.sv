// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_CONSTANTS_SV__
`define __UVMT_MAPU_B_CONSTANTS_SV__


const int unsigned uvmt_mapu_b_default_clk_frequency = 100000000; ///< Default Clock frequency ()
// pragma uvmx constants begin
const int unsigned uvmt_mapu_b_default_startup_timeout          =      10_000; ///< Default Heartbeat Monitor startup timeout in ns
const int unsigned uvmt_mapu_b_default_heartbeat_period         =       1_000; ///< Default Heartbeat Monitor period in ns
const int unsigned uvmt_mapu_b_default_heartbeat_refresh_period =       5_000; ///< Default Heartbeat Monitor refresh period in ns
const int unsigned uvmt_mapu_b_default_simulation_timeout       =  10_000_000; ///< Default Watchdog Timer simulation timeout in ns
// pragma uvmx constants end


`endif // __UVMT_MAPU_B_CONSTANTS_SV__
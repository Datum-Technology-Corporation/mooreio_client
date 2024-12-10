# Integer Matrix APU

![alt text](./docs/block_diagram.svg "Block Diagram")
 
![alt text](./docs/timing_diagram.svg "Timing Diagram")


This simplistic Matrix APU operates on integer 3x3 matrices loaded & output row-by-row.  Each member is an unsigned integer of
bit width controlled by the `DATA_WIDTH` parameter.  All operations take `3+3+1=7` cycles before the result matrix is output
row-by-row on the output data lines (`o_r0`-`o_r2`).

It is controlled by:
- enabled (`en`)
- operation (`op`):
  - ADD : `2'b0`
  - MULTIPLY : `2'b1`
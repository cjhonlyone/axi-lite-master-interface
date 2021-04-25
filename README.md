# axi-lite-master-interface
use verilog to config IP with axi-lite interface
┌───────────────┐        ┌───────────────┐
│               │        │               │
│               │        │               │
│         AXI-Lite──────►AXI-Lite        │
│          master config │slave          │
│               │  regs  │               │
│               │        │               │
│               │        │               │
│ axil_auto_cfg │        │ jesd204b_ip   │
│               │        │               │
│               │        │               │
│               │        │               │
└───────────────┘        └───────────────┘
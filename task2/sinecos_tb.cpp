#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vsinecos_gen.h"  // Changed to new module
#include "vbuddy.cpp"

#define MAX_SIM_CYC 1000000
#define ADDRESS_WIDTH 8
#define ROM_SZ 256

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  Vsinecos_gen* top = new Vsinecos_gen;  // New module
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("sinecos_gen.vcd");
 
  if (vbdOpen()!=1) return(-1);
  vbdHeader("L2T2: Sine+Cosine");
  vbdSetMode(1);

  top->clk = 1;
  top->rst = 0;
  top->en = 1;
  top->incr = 1;

  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    
    // Get phase offset from VBuddy rotary encoder
    top->phase_offset = vbdValue();
    
    // Plot both waveforms
    vbdPlot(int(top->dout1), 0, 255);  // First sine wave
    vbdPlot(int(top->dout2), 0, 255);  // Phase-shifted sine wave
    vbdCycle(simcyc);

    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);
  }

  vbdClose();
  tfp->close(); 
  exit(0);
}
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vsigdelay.h"
#include "vbuddy.h"

#define MAX_SIM_CYC 1000000
#define RAM_SZ 512

int main(int argc, char **argv, char **env) {
  int simcyc;
  int tick;

  Verilated::commandArgs(argc, argv);
  Vsigdelay* top = new Vsigdelay;
  
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("sigdelay.vcd");
 
  // Initialize Vbuddy and microphone
  if (vbdOpen() != 1) return(-1);
  vbdHeader("L2T3: Audio Delay");
  vbdInitMicIn(RAM_SZ);  // Initialize microphone buffer

  top->clk = 1;
  top->rst = 1;
  top->en = 1;
  top->offset = 0;

  for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++) {
    for (tick = 0; tick < 2; tick++) {
      tfp->dump(2 * simcyc + tick);
      top->clk = !top->clk;
      top->eval();
    }

    // Audio capture from Vbuddy microphone
    top->mic_signal = vbdMicValue();
    
    // Delay control from rotary encoder
    top->offset = vbdValue();
    
    // Release reset after a few cycles
    if (simcyc > 10) top->rst = 0;

    // Plot both original and delayed signals
    vbdPlot(int(top->mic_signal), 0, 255);        // Original audio
    vbdPlot(int(top->delayed_signal), 0, 255);    // Delayed audio
    vbdCycle(simcyc);

    // Exit on 'q' key press
    if ((Verilated::gotFinish()) || (vbdGetkey() == 'q')) 
      exit(0);
  }

  vbdClose();
  tfp->close();
  exit(0);
}

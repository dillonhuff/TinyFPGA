#include <iostream>
#include <ctime>
#include <cstdlib>

#include "Vconnect_box.h"
#include "verilated.h"

using namespace std;

int main(int argc, char** argv) {

  cout << "$$$$ Connect box tests pass" << endl;
  Vconnect_box* cb = new Vconnect_box();

  cb->clk = 0;

  cb->eval();

  cb->config_en = 1;
  cb->config_data = 1;
  cb->clk = 1;

  cb->eval();

  cb->clk = 0;

  cb->config_en = 0;
  cb->track0_in = 0;
  cb->track1_in = 1;
  cb->track2_in = 0;
  cb->track3_in = 1;

  cb->eval();

  assert(cb->block_out == 1);

  cb->track1_in = 0;

  cb->eval();

  assert(cb->block_out == 0);

  cb->config_en = 1;
  cb->config_data = 3;
  cb->clk = 1;

  cb->eval();

  cb->clk = 0;
  cb->config_en = 0;

  cb->track0_in = 0;
  cb->track1_in = 0;
  cb->track2_in = 0;
  cb->track3_in = 1;

  cb->eval();

  assert(cb->block_out == 1);
  
}

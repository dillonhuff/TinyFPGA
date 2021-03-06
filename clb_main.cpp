#include <iostream>
#include <ctime>
#include <cstdlib>

#include "Vclb.h"
#include "verilated.h"

using namespace std;

void test_and_out(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Vclb* top = new Vclb;

  top->clk = 0;

  top->eval();

  top->clk = 1;
  top->config_enable = 1;
  top->config_data = 0;

  top->eval();

  top->config_enable = 0;
  top->clk = 0;

  top->in0 = 1;
  top->in1 = 0;

  top->eval();

  assert(top->out == 0);

  top->in1 = 1;

  top->eval();

  assert(top->out == 1);

  top->final();
}

void test_or_out(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Vclb* top = new Vclb;

  top->clk = 0;

  top->eval();

  top->clk = 1;
  top->config_enable = 1;
  top->config_data = 1;

  top->eval();

  top->config_enable = 0;
  top->clk = 0;
  
  top->in0 = 1;
  top->in1 = 0;

  top->eval();

  assert(top->out == 1);

  top->in0 = 0;
  top->in1 = 0;

  top->eval();

  assert(top->out == 0);

  top->final();
}

void test_xor_out(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Vclb* top = new Vclb;

  top->clk = 0;

  top->eval();

  top->clk = 1;
  top->config_enable = 1;
  top->config_data = 2;

  top->eval();

  top->config_enable = 0;
  top->clk = 0;
  
  top->in0 = 1;
  top->in1 = 0;

  top->eval();

  assert(top->out == 1);

  top->in0 = 1;
  top->in1 = 1;

  top->eval();

  assert(top->out == 0);

  top->final();
}

void test_reg_out(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  Vclb* top = new Vclb;

  top->clk = 0;

  top->eval();

  top->clk = 1;
  top->config_enable = 1;
  top->config_data = 3;

  top->eval();

  top->config_enable = 0;
  top->clk = 0;

  top->eval();

  top->clk = 1;
  top->in0 = 1;
  top->in1 = 0;

  top->eval();

  assert(top->out == 1);

  top->in0 = 0;

  top->eval();

  assert(top->out == 1);

  top->clk = 0;
  top->eval();

  top->clk = 1;
  top->in0 = 0;

  top->eval();

  assert(top->out == 0);
}

int main(int argc, char** argv) {

  test_and_out(argc, argv);
  test_or_out(argc, argv);
  test_xor_out(argc, argv);
  test_reg_out(argc, argv);

  cout << "$$$$ clb tests pass" << endl;
}

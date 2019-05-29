#! /bin/bash

BRUNCH_DIR=YOUR_BRUNCH_DIR
SEAHORN_DIR=YOUR_SEAHORN_DIR


printf "\n#############\nRunning TeaDsa\n###############\n"
./run_all.sh results "$YOUR_SEAHORN_DIR/run/bin" $BRUNCH_DIR "true dsa"
printf "\n#############\nRunning PFS-SeaDsa\n###############\n"
./run_all.sh results "$YOUR_SEAHORN_DIR/run/bin" $BRUNCH_DIR "false dsa"
printf "\n#############\nRunning SeaDsa\n###############\n"
./run_all.sh results "$YOUR_SEAHORN_DIR/run/bin" $BRUNCH_DIR "false dsa true"
printf "\n#############\nRunning Sparse Flow-Sensitive\n###############\n"
./run_all.sh results "$YOUR_SEAHORN_DIR/run/bin" $BRUNCH_DIR "true sparse"
printf "\n#############\nRunning Wave-Diff\n###############\n"
./run_all.sh results "$YOUR_SEAHORN_DIR/run/bin" $BRUNCH_DIR "false wave-diff"
printf "\n#############\nRunning Wave-Diff (types) \n###############\n"
./run_all.sh results "$YOUR_SEAHORN_DIR/run/bin" $BRUNCH_DIR "true wave-diff"

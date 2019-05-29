#! /bin/bash

# E.g.: ./run_all.sh dsa-results ~/projects/build-seahorn/release-5/run/bin ~/projects/brunch "true dsa"

RESULTS_DIR="$1"
SEAHORN_DIR="$2"
BRUNCH_DIR="$3"
CONFIG="$4"

if [ "$RESULTS_DIR" = "" ]; then
	echo "Empty RESULTS_DIR, aborting"
	exit 1
elif [ "$BRUNCH_DIR" = "" ]; then
	echo "Empty BRUNCH_DIR, aborting"
	exit 2
elif [ "$SEAHORN_DIR" = "" ]; then
	echo "Empty SEAHORN_DIR, aborting"
	exit 3
elif [ "$CONFIG" = "" ]; then
	echo "Empty CONFIG, aborting"
	exit 4
fi

# Needed by run.sh
export SEAHORN_DIR

START_DIR="$(pwd)"
RESULTS="$(realpath $RESULTS_DIR)"
mkdir -p "$RESULTS"

NAMED_CONFIG=$(echo "$CONFIG" | sed 's/[[:space:]]\{1,\}/./g')
printf "Named config: %s\n" "$NAMED_CONFIG"

echo "Running on CASS"
CASS_DIR="$START_DIR/CASS"
cd "$CASS_DIR" && ../run.sh CASS_DDSim.llvm5.externalized.o0.g.bc $CONFIG > "$RESULTS/cass.$NAMED_CONFIG.out" 2>&1

echo "Running on htop"
HTOP_DIR="$START_DIR/htop"
cd "$HTOP_DIR" && ../run.sh htop.bc $CONFIG > "$RESULTS/htop.$NAMED_CONFIG.out" 2>&1

echo "Running on openSSL"
OPENSSL_DIR="$START_DIR/openssl"
cd "$OPENSSL_DIR" && ../run.sh openssl.bc $CONFIG > "$RESULTS/openssl.$NAMED_CONFIG.out" 2>&1

echo "Running on spec2k6"
SPEC_DIR="$START_DIR/spec2k6"
cd "$SPEC_DIR" && ../run.sh hmmer.bc $CONFIG > "$RESULTS/hmmer.$NAMED_CONFIG.out" 2>&1
cd "$SPEC_DIR" && ../run.sh h264ref.bc $CONFIG > "$RESULTS/h264ref.$NAMED_CONFIG.out" 2>&1

echo "Running on tmux"
TMUX_DIR="$START_DIR/tmux"
cd "$TMUX_DIR" && ../run.sh tmux.bc $CONFIG > "$RESULTS/tmux.$NAMED_CONFIG.out" 2>&1

echo "Running on sqlite"
SQLITE_DIR="$START_DIR/sqlite"
cd "$SQLITE_DIR" && ../run.sh sqlite3.bc $CONFIG > "$RESULTS/sqlite.$NAMED_CONFIG.out" 2>&1

echo "Running on webassembly"
WASM_DIR="$START_DIR/webassembly"
cd "$WASM_DIR" && ../run.sh wasm-dis.bc $CONFIG > "$RESULTS/wasm.dis.$NAMED_CONFIG.out" 2>&1
cd "$WASM_DIR" && ../run.sh wasm-as.bc $CONFIG > "$RESULTS/wasm.as.$NAMED_CONFIG.out" 2>&1
cd "$WASM_DIR" && ../run.sh wasm-opt.bc $CONFIG > "$RESULTS/wasm.opt.$NAMED_CONFIG.out" 2>&1

echo "Running on clang"
CLANG_DIR="$START_DIR/clang"
cd "$CLANG_DIR" && ../run.sh llvm-dis.bc $CONFIG > "$RESULTS/llvm.dis.$NAMED_CONFIG.out" 2>&1
cd "$CLANG_DIR" && ../run.sh llvm-as.bc $CONFIG > "$RESULTS/llvm.as.$NAMED_CONFIG.out" 2>&1
cd "$CLANG_DIR" && ../run.sh opt.bc $CONFIG > "$RESULTS/llvm.opt.$NAMED_CONFIG.out" 2>&1
#cd "$CLANG_DIR" && ../run.sh clang-9.bc true > "$RESULTS/clang.types.out" 2>&1

echo "Running on rippled"
RIPPLED_DIR="$START_DIR/ripple"
cd "$RIPPLED_DIR" && ../run.sh rippled.bc $CONFIG > "$RESULTS/rippled.$NAMED_CONFIG.out" 2>&1

echo "Scrabbing results"
cd "$START_DIR"
python "$BRUNCH_DIR/spacer/log_scrab.py" "$RESULTS" -o dsa_results.csv

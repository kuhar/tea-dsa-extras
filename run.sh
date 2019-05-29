#! /bin/bash

# Usage: SEAHONR_DIR=PATH_TO_SEAHORN ../run.sh BITCODE.bc TYPES:Bool [LLVM_DIR]
#  e.g.: SEAHORN_DIR=~/projects/build-seahorn/release-5/run/bin/ ../run.sh CASS_DDSim.llvm5.externalized.o0.g.bc true 2>&1 | tee log.types.out

START_TIME=$(date +%s%3N)
CURR_DATE_TIME="$(date +"%y/%m/%d-%H:%M:%S")"

START_DIR=`pwd`
echo "$@"

PTA=${3:-dsa}

printf "BITCODE:%s\nSEAHORN_DIR=%s\nPWD=%s\nPTA=%s\n\n\n" "$1" "$SEAHORN_DIR" "$START_DIR" "$PTA" 

NOOPT=${4:-false}

LLVM_DIR=${5:-"~/apps/clang-5.0/bin"}
SEA_DIR="$SEAHORN_DIR"

mkdir -p temps

BITCODE=`basename $1 .bc`

OPT_INV="$SEA_DIR/seaopt $1 -O1 -o ./temps/$BITCODE.n.bc"
echo "$OPT_INV"

if [ ! -f "./temps/$BITCODE.n.bc" ]; then
  $OPT_INV
  OPT_RES=$?
  if [[ "$OPT_RES" != 0 ]]; then
    printf "\nseaopt invocation failed!\n"
    exit 1
  fi
else
  printf "\nFile already exists, skipping seaopt invocation\n"
fi

FINAL_BITCODE_PATH="./temps/$BITCODE.n.pp.bc"
SEAPP_INV="$SEA_DIR/seapp ./temps/$BITCODE.n.bc -o $FINAL_BITCODE_PATH \
                          --lower-invoke \
                          --devirt-functions \
                          --unfold-loops-for-dsa=false \
                          --simplify-pointer-loops \
                          --horn-inline-constructors --horn-inline-allocators \
                          --log=extern.off \
                          --kill-vaarg=true \
                          --externalize-addr-taken-funcs=true \
                          --promote-bool-loads=true \
                          --lower-switch=false \
                          --externalize-function=.*AFA6string.*,_ZN3AFAplERKNS_6stringES2_,_ZN3AFAplEPKcRKNS_6stringE,_ZN3AFAplERKNS_6stringEPKc,_Z18to_standard_stringN3AFA6stringE,.*AFA3map.*,.*MDL_Tree.*,_Z14Initialize_Mapv,_ZN6google8protobuf*,_ZN5boost4asio6detail1*,_ZN5beast* \
                          --promote-assumptions=false \
                          --instnamer \
                          --strip-debug \
                          --verify-after-all=true --sea-verifier-noop --log=debug-verifier"
echo $SEAPP_INV

if [ ! -f "./temps/$BITCODE.n.pp.bc" ]; then
  $SEAPP_INV
  CPP_RES=$?
  if [[ "$CPP_RES" != 0 ]]; then
    printf "\nseapp invocation failed!\n"
    exit 2
  fi
else
  printf "\nFile exists, skipping seapp invocation\n"
fi

echo

SMC_INV="runsolver --rss-swap-limit 80000 \
              $SEA_DIR/seapp $FINAL_BITCODE_PATH -o ./temps/$BITCODE.n.pp.smc.bc \
                        --smc --sea-dsa-type-aware=$2  --smc-analyze-only \
                        --smc-check-threshold=400 \
                        --sea-dsa=butd-cs \
                        --smc-pta=$PTA \
			--sea-dsa-no-td-flow-sensitive-opt=$NOOPT \
			--sea-dsa-no-bu-flow-sensitive-opt=$NOOPT \
			--sea-dsa-no-td-copying-opt=$NOOPT \
                        --print-smc-summary \
                        --log=brunch --log=brunch-progress --log=dsa-progress.off \
                        --log=smc.off --log=dsa.off \
                        --log=alloc-sites.off"
echo $SMC_INV
echo

$SMC_INV

END_TIME=$(date +%s%3N)
ELAPSED=$(expr "$END_TIME" - "$START_TIME")
printf "BRUNCH_STAT TOTAL_TIME_SMC_MS %s\n" "$ELAPSED"
printf "BRUNCH_STAT ORIGINAL_BITCODE_NAME %s\n" "$BITCODE.bc"
ORIGINAL_SIZE="$(du -k $1 | cut -f1)"
printf "BRUNCH_STAT ORIGINAL_BITCODE_SIZE_KB %s\n" "$ORIGINAL_SIZE"

printf "BRUNCH_STAT FINAL_BITCODE_NAME %s\n" "$BITCODE.n.pp.bc"
FINAL_SIZE="$(du -k $FINAL_BITCODE_PATH | cut -f1)"
printf "BRUNCH_STAT FINAL_BITCODE_SIZE_KB %s\n" "$FINAL_SIZE"
printf "BRUNCH_STAT EXPERIMENT_TIME %s\n" "$CURR_DATE_TIME"

# tea-dsa-extras
TeaDsa Program Verification Benchmarks and Scripts.

This constains a fet of program verification benchmarks for detecting a calss (potentially) unsafe memory accessed,
called *field overflows*. A field overflow happens when a non-existent field of an object is accessed, such that the
memory access is past the allocated object's size.

The field overflow checker can be found at: https://github.com/seahorn/seahorn/blob/deep-dev-5.0/lib/Transforms/Instrumentation/SimpleMemoryCheck.cc.

## Dependencies
* SeaHorn: clone https://github.com/seahorn/seahorn/ branch `tea-dsa` and follow the compilation instructions.
* TeaDsa: cloned automatically during SeaHorn compilation.
* SVF: cloned automatically during SeaHorn compilation. Customized version avaialable at: https://github.com/kuhar/SVF.
* gllvm: available at: https://github.com/SRI-CSL/gllvm.
* runsolver: available at: https://www.cril.univ-artois.fr/~roussel/runsolver/.

## Respository structure

* Each top-level program directory contains a prebuilt benchmark bitcode file.
  Build instructions, when avaiable, are placed in a `build.txt` file in the same directory.
  The instructions use the gllvm project for compiling programs into a single bitcode file.
* The top-level directory contains a `run.sh` script for running the field overflow checker on an input bitcode.
  Note that upon the first run, the script performs a lightweight preprocessing on the input bitcode. The `run_all.sh` script can be used to run a single tool configuration over all the input bitcode files.
  The `benchmark.sh` script uses all the tool configurations (SeaDsa, PFS-SeaDsa, TeaDsa, SVF Wave Diff, and SVF Sparse)
  to run all the benchmarks.
* The `results` directory contains logs from execution of each benchmark.
  Additionally, all the results are summarized in the `results_*.csv` file.

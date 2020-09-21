# Overview

LM RISC-V DV is a verfication environment based on the verification environment of [ibex](ibex) core from lowRISC. This environment integrates a random assembly test generator from Google's RISCV-DV. This work is currently in progress. At present it supports:

- RTL Compilation
- Random Assembly Test Generation
- Test Compilation (Random, Directed)
- RTL Simulation
- ISS Simulation
- Post Comparison with ISS (Spike)
- URG Coverage Report Generation

## Directory Structure

```bash
├── cores
├── docs
├── google_riscv_dv
├── integrated_cores
├── integration_files
└── scripts
```

### [cores](./cores)/

This directory is a place holder which will contain the cores in their original source forms cloned from their sites. Currently, LM RISC-V DV has been setup and tested for SweRV EH-1 core from Western Digital. When the cores are cloned, they will be checked out to the most recent versions which have been tested in this environment.  

### [docs](./docs)/

This directory is dedicated for all the documentation related to directory structure and environment flow. It also contains documentation for tests which are generated for a specific core.

### [google_riscv_dv](./google_riscv_dv)/

Google's RISC-V DV is cloned from  into this repository. It contains the source for random assembly test generator written in SystemVerilog/UVM.

### [integrated_cores](./integrated_cores)/

After the cores and Google's RISC-V DV are cloned into their respective directories, the verification environemnt for the cores will be set up here with each core in its seperate directory.

### [integration files](./integration_files)/

This directory contains files which will be used in setting up the verification environment. It contains:

- Makefiles, python scripts, yaml files, linker files and core configuartion files
- Modified Google's RISC-V DV Files specific for cores
- Modified RTL and Testbench files related to cores

### scripts/

All the scripts for setting up the repository and core integration will be placed in this directory. At present, it contains two scripts.

- [core_integrate.sh](./scripts/core_integrate.sh)
- [toolchain_paths.sh](./scripts/toolchain_paths.sh)

## Pre-Requisites

Following are the requirements for running the test generator and environemnt.

- RISC-V GNU Toolchain
- Instruction Set Simulator or ISS (e.g. Spike, OVPsim etc)
- Python 3
- SV and UVM 1.2 Simulator

For manually building the `RISC-V GNU Toolchain`, visit the [riscv-gnu-toolchain](https://github.com/riscv/riscv-gnu-toolchain) repository on Github. Pre-built toolchains can be downloaded from [SiFive Software](https://www.sifive.com/software) Page. We are using `Spike ISS` for LM RISC-V DV. It can be manually built from the source which can be obtained from [riscv-isa-sim](https://github.com/riscv/riscv-isa-sim) repository. `Python 3.7` or above is recommended for the python scripts to work properly for test generation, compilation and simulation. According to Google's RISC-V Documentation, a number of `simulators` has been verified with the test generator including Synopsys VCS, Cadence Incisive/Xcelium, Mentor Questa, and Aldec Riviera-PRO.

## Setup

After the `RISC-V GNU toolchain` and `Spike` (or any other RISC-V ISS) are installed, their installation paths should be added to `~/.bashrc` file in `RISCV_PATH` and `SPIKE_PATH` (or path variable corresponding to installed ISS) variables respectively. Following is the sample of paths to be added on a ubuntu OS.

```bash
export RISCV_PATH = <path to>/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14
export SPIKE_PATH = <path to directory containing spike executable>
```

Their is a [toolchain_paths.sh](./scripts/toolchain_paths.sh) script in [scripts/](./scripts) directory. You need to `source` it after exporting the above paths in the `~/.bashrc` file as

```bash
source <path to toolchain_paths.sh>
```

## Integration of Core with Google's RISC-V DV

[core_integrate.sh](./scripts/core_integrate.sh) is a `bash` script placed in [scripts/](./scripts) directory which clones the cores and Google's RISC-V DV into appropriate folders as discussed in *directory structure* section. You just simply need to run the script through terminal.

```bash
./core_integrate.sh
```

Currently, only SweRV EH-1 has been integrated. It will thus set up the environment for the SweRV Eh-1 core only.

## Contribution

This is a work in progress. We'd like to accept your contributions to this project.

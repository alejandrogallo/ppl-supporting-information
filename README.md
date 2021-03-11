<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Introduction](#introduction)
- [Molecular geometries](#molecular-geometries)
- [Chemical reactions list](#chemical-reactions-list)
- [`PSI4` calculations output](#psi4-calculations-output)
- [Calculated energies](#calculated-energies)
    - [`PSI4`](#psi4)
    - [`TURBOMOLE`](#turbomole)
    - [`NWCHEM+CC4S`](#nwchemcc4s)

<!-- markdown-toc end -->

[![DOI](https://zenodo.org/badge/344758845.svg)](https://zenodo.org/badge/latestdoi/344758845)

# Introduction

This repository contains simulation results of molecular quantum
chemical calculation. These are CCSD(T) calculation obtained with
different quantum chemical program packages
([TURBOMOLE](https://www.turbomole.org/), [PSI4](https://psicode.org/),
[NWCHEM](https://nwchemgit.github.io/), cc4s).
Data is given for the aug-cc-pVXZ basis set family (AVXZ).

Note that for all calculations, the HF groundstate energy between
`TURBOMOLE`, `NWCHEM`, and `PSI4`
agree better than 1.5E-5 Hartree.


# Molecular geometries #

The employed molecular geometries can be found in
[this publication](https://doi.org/10.1063/1.3054300).
The list of studied systems can be found in the following file:

- `jcp_systems.dat`

# Chemical reactions list #

Lists of reactions analysed in the given publication

- `list.closedshell`
- `list.openshell`
- `list.atomization`
- `list.ip`
- `list.ea`

# `PSI4` calculations output #

The stdout of `PSI4` calculations for the given set of molecules is also included in this repository.
For techncical reasons two independent calculations were necessary for
the evaluation of the
PPL-contribution and for the conventional CCSD(T) calculation.
For the evaluation of the PPL-contribution the `PSI4`-code has been
modified (see [this publication](https://doi.org/10.1063/1.5110885)):

- `psi4_ppl_data/`
- `psi4_triples_data/`

# Calculated energies #

All extracted energy contributions of the individual molecules
for different basis sets from `PSI4`, `TURBOMOLE` (f12...), and
`NWCHEM+cc4s` are given in Hartree units.


## `PSI4` ##

HF, CCSD, MP2, PPL, REST, and (T) energy contributions are given.
Values are given for AVDZ-AV6Z, as well as the extrapolated values.

The data is found in the directory
- `psi4/`

## `TURBOMOLE` ##

Given is the CCSD and MP2 correlation energy, as well as the total CCSD energy
including HF.
Results are given for f12*, f12a, and f12b energies. 
In addition, the `PSI4` energies are also provided in these files:
[56]-extrapolated values are given for CCSD and MP2. 

(Total energy reads: HF@6z + [56]-ccsd)

- `f12dz_gamma1.0/`
- `f12tz_gamma1.0/`
- `f12qz_gamma1.0/`
- `f12dz_gamma1.4/`
- `f12tz_gamma1.4/`
- `f12qz_gamma1.4/`

## `NWCHEM+CC4S` ##

- HF orbitals are taken from `NwChem` and used for CCSD calculations using the code `cc4s`.
- The number of natural orbitals per occupied orbital is given in the first column.
- nwXz means that all possible virtual orbitals are used.
- The reference (Ref) is the [56] `PSI4` energy.
- Hartree Fock 6Z values are also provided, as taken from `PSI4`
- Hartree Fock QZ/5Z values are taken from `NwChem`
In `*_ppl` CCSD, PPL, MP2, and REST energies are given.
Further shown are corrected ppl values (CPPL), and the (T) energies.
- `noqz/`
- `no5z/`


# SimulatorBench

GHDL-vs-Kmila accuracy harness. See `Documentacion/HANDOFF_simulator_bench_api.md`
for the master plan.

**Status 2026-11-16:** 149/149 PASS (fuente legada `kmila.vhdl`). Usado como *golden master* del refactor multi-HDL (Fase 0): los VCD de Kmila deben salir byte-idénticos a `Tests/baseline/2026-11-15/bench-kmila-vcd.sha256`. Pendiente (plan multi-HDL, Paso 5b): layout multi-variante y simular la fuente original *verbatim*.

**Status 2026-08-03:** 148/148 PASS = 100%, 0 skipped (per `report.json`). Corpus grew to 148 cases (ids up to 165) with the function/procedure body-inlining, local-variable, and early-return tiers (154-165).

**Status 2026-07-28:** 136/136 PASS = 100%, 0 skipped. 7 cases (147-153) added during the Tier 4.1 / 4.2 / 4.3 arc (VHDL-2008 case?, signal attributes end-to-end, function/procedure body inlining fences).

**Status 2026-06-24:** 119/119 PASS = 100%, 0 skipped. 17 cases
(120–136) added during the 2026-06-22 → 2026-06-24 hardening + §6
follow-up sessions targeting the 5 ESCOM Arquitectura de Computadoras
practicas. ~26 cumulative simulator/bench bugs fixed across the
harness's lifetime.

The 2026-06-22/23 cases lock in: multi-hop concurrent alias chains
(120/121), constant-array element access via dynamic and literal indices
(122/123), named-association aggregates with user-defined function
elements (124), case-statement choice resolution (125–127), the P2A LOAD
pipeline + enum-equality conditional (128/129), arithmetic-in-vector-range
(130), indexed-LHS writes inside processes (131), and direct entity
instantiation (132).

The 2026-06-24 follow-up cases lock in: `(others => '0')` initial-value
expansion at signal-construction time (133), `(others => '0')` as an RHS
aggregate inside a clocked reset branch with engine-side expansion
against the target width (134), `unsigned * unsigned` width tripwire
matching `numeric_std` `leftW+rightW` semantics (135), and function-body
caller-scope binding correctness when the same function is inlined
across multiple instances with different architecture-scope signals
(136 — passes today; confirms the handoff §6 item 6 workaround is
correct, no code change needed).

See `Documentacion/HANDOFF_practicas_2026-06-23.md` (with §10
Continuation 2026-06-24) for the per-case narrative.

## Setup (one-time)

```sh
Setup/install-deps.sh        # brew install ghdl gtkwave (macOS)
```

## Usage

```sh
# Verify GHDL + Kmila API are both reachable
dotnet run -- verify

# List discovered cases
dotnet run -- list

# Run the whole corpus (or just one case)
dotnet run -- run
dotnet run -- run --only 001-and-gate --keep
```

The bench expects `Kmila.Web` running on `http://127.0.0.1:5298` (override
with `--api URL` or `$KMILA_API`). Launch with:

```sh
cd ../App/Kmila
dotnet run --project Kmila.Web -f net9.0 --no-launch-profile --urls http://127.0.0.1:5298
```

## Adding a case

```text
Cases/<id>/
  meta.json        # provenance + problem spec (ports, stimulus, duration)
  reference/       # author's UNTOUCHED GHDL files (DUT + testbench)
  kmila.vhdl       # MY independent implementation of the same problem
  results/         # populated at run-time: ghdl/golden.vcd, kmila.vcd, diff.json
```

**Honesty constraint** (HANDOFF §3): the reference files come from a public
source (record `sourceUrl`, `license`). `kmila.vhdl` must be written from the
problem spec, not by reading the reference VHDL. The bench compares only
declared `out`/`inout` ports — internal signals and auto-clocks are ignored.

If a case cannot be reduced to a `(t, port, value)` stimulus table, set
`skipReason` in `meta.json` instead of generating a substitute testbench.

# SimulatorBench

GHDL-vs-Kmila accuracy harness. See `Documentacion/HANDOFF_simulator_bench_api.md`
for the master plan.

**Status 2026-11-22 (v3.1.9):** the bench simulates each **author's testbench verbatim** in Kmila and in GHDL and compares every testbench signal strictly: **147/149**. The 2 left (`014-mux-sel`, `113-edges-det`) are G103 — delays below 1 ns, deferred to Fase 2 — in `known-gaps.json`. This run is the golden master (`hash --check Tests/baseline/2026-11-22-v319/bench-kmila-vcd.sha256`, identical in process and over HTTP). The legacy re-implementations and `--legacy-source` are gone; `audit-synth` audits the author's DUT.

**Status 2026-11-21 (v3.0.8, layout v2):** verbatim **138/149**; los 11 restantes están catalogados en `known-gaps.json` (G84, G85, G86; repros en `Documentacion/handoffs/repros_gaps_2026-11-16/v308/`) y se corrigen en v3.1.8. *Golden master* del refactor: `run --legacy-source` 149/149 con `hash --legacy-source --check Tests/baseline/2026-11-20-v316/bench-kmila-vcd.sha256` idéntico, en proceso y por HTTP.

**Status 2026-11-16:** 149/149 PASS (fuente legada `kmila.vhdl`), golden master del refactor multi-HDL.

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
dotnet run -- verify                      # GHDL, Kmila API and OpenAPI snapshot
dotnet run -- list                        # cases and their variants
dotnet run -- run                         # golden master: authors' testbenches verbatim, ratcheted by known-gaps.json
dotnet run -- run --http --only 001-and   # through a running Kmila.Web (--api URL)
dotnet run -- hash --check ../Tests/baseline/<date>/bench-kmila-vcd.sha256
```

`run` is in process (`Kmila.TestKit`'s `InProcessKmilaRunner`, the same
`HeadlessSimulator` the API calls); `--http` needs a host, e.g.
`dotnet run --project ../App/Kmila/Kmila.Web -c Release -f net10.0 --no-launch-profile --urls http://127.0.0.1:5298`.

## Case layout (v2)

```text
Cases/<id>/
  case.json                    # provenance + language-neutral spec: DUT ports (documentation), timing
  variants/<lang>/variant.json # sources (analysis order), top (testbench), entity (DUT), standard
  variants/<lang>/reference/   # the author's UNTOUCHED sources (DUT + testbench)
  results/<lang>/              # run outputs: golden.vcd, reference.log, kmila.vcd, diff.json
```

Both simulators run the same testbench (`variant.top`), so its generic maps
and stimulus are the author's; every signal of the testbench's own scope is
compared. The port-stimulus path the app uses for designs without a testbench
is covered by the practice oracle (`PracticeValidator`), the fixture cases and
`Tests/baseline/cli_golden.sh`. A case passes only when **every supported HDL has a variant**, each variant's
Kmila run matches its golden (strict: nine values, t=0 included) and the
variants' goldens agree. A missing variant is a failure, never a skip.
Kmila reads the reference sources verbatim — the bench never rewrites them
(the only normalisation, `10ns` → `10 ns`, is applied to GHDL's private copy
because GHDL rejects it). Verbatim failures must be listed in
`known-gaps.json` (case, variant, category, reason, since): a failure not
listed, or a listed variant that passes, fails the run, so the list only shrinks.

**Honesty constraint:** reference sources come from a public source (record
`sourceUrl`, `license`). If a case cannot be reduced to a `(t, port, value)`
stimulus table, set `skipReason` in `case.json` instead of generating a
substitute testbench.

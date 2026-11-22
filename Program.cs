using System.Text.Json;
using Kmila.Shared.Services;
using Kmila.Shared.Services.Api;
using Kmila.Shared.Services.Vcd;
using Kmila.TestKit;
using Kmila.TestKit.Reference;
using Kmila.TestKit.Runners;
using Kmila.TestKit.Stimulus;
using SimulatorBench.Tools;

namespace SimulatorBench;

/// <summary>Kmila vs GHDL accuracy harness (commands and flags: <see cref="PrintHelp"/>).</summary>
public static class Program
{
    public static async Task<int> Main(string[] args)
    {
        string api  = ArgOrEnv(args, "--api", "KMILA_API", "http://127.0.0.1:5298");
        // Bearer token for hosts started with KMILA_LOCAL_API_TOKEN (empty: none).
        string token = ArgOrEnv(args, "--token", "KMILA_TOKEN", "");
        string root = ArgOrEnv(args, "--root", "BENCH_ROOT", DefaultRoot());
        string? only = ArgValue(args, "--only");
        string conceptsRoot = ArgOrEnv(args, "--concepts-root", "CONCEPTS_ROOT", SharedContentPaths.Find("Concepts") ?? "");
        bool keep      = HasFlag(args, "--keep");
        bool roundtrip = HasFlag(args, "--roundtrip");
        bool inProcess = HasFlag(args, "--in-process");

        if (args.Length == 0 || args[0] is "help" or "--help" or "-h")
        {
            PrintHelp();
            return 0;
        }

        return args[0] switch
        {
            "verify"          => await VerifyAsync(api, token),
            "run"             => await RunAsync(api, root, only, keep, roundtrip, inProcess, token),
            "hash"            => Hash(root, ArgValue(args, "--check"), ArgValue(args, "--write")),
            "list"            => ListCases(root),
            "audit-concepts"  => AuditConcepts(conceptsRoot, only),
            "audit-synth"     => AuditSynth(root, only),
            "report"          => ReportAccuracy(root),
            _                 => Unknown(args[0]),
        };
    }

    private static int AuditConcepts(string conceptsRoot, string? onlyLang)
    {
        Console.WriteLine($"[audit-concepts] concepts-root={conceptsRoot}");
        if (onlyLang != null) Console.WriteLine($"[audit-concepts] only lang={onlyLang}");

        var report = ConceptAuditor.Run(conceptsRoot, onlyLang, Console.WriteLine);
        var outPath = Path.Combine(conceptsRoot, "audit-report.json");
        File.WriteAllText(outPath, JsonSerializer.Serialize(report, Reporter.Indented));

        Console.WriteLine();
        Console.WriteLine($"[audit-concepts] checks={report.Total}  flagged={report.Flagged}");
        if (report.FlaggedByKind.Count > 0)
            Console.WriteLine("[audit-concepts] by kind: "
                + string.Join(", ", report.FlaggedByKind.Select(kv => $"{kv.Key}={kv.Value}")));
        if (report.FlaggedByLang.Count > 0)
            Console.WriteLine("[audit-concepts] by lang: "
                + string.Join(", ", report.FlaggedByLang.Select(kv => $"{kv.Key}={kv.Value}")));
        Console.WriteLine($"[audit-concepts] wrote {outPath}");
        return report.Flagged == 0 ? 0 : 1;
    }

    private static int AuditSynth(string benchRoot, string? only)
    {
        Console.WriteLine($"[audit-synth] bench-root={benchRoot}");
        if (only != null) Console.WriteLine($"[audit-synth] only={only}");

        SynthAuditor.AuditReport report;
        try
        {
            report = SynthAuditor.Run(benchRoot, only, Console.WriteLine);
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"[audit-synth] failed: {ex.Message}");
            return 2;
        }

        var outPath = Path.Combine(benchRoot, "audit-synth.json");
        File.WriteAllText(outPath, JsonSerializer.Serialize(report, Reporter.Indented));

        Console.WriteLine();
        Console.WriteLine($"[audit-synth] cases={report.TotalCases}  withFindings={report.CasesWithFindings}  " +
                          $"diagnostics={report.Total}  flagged={report.Flagged}");
        if (report.BySeverity.Count > 0)
            Console.WriteLine("[audit-synth] by severity: "
                + string.Join(", ", report.BySeverity.Select(kv => $"{kv.Key}={kv.Value}")));
        if (report.ByKind.Count > 0)
            Console.WriteLine("[audit-synth] by kind: "
                + string.Join(", ", report.ByKind.Select(kv => $"{kv.Key}={kv.Value}")));
        Console.WriteLine($"[audit-synth] wrote {outPath}");
        return report.Flagged == 0 ? 0 : 1;
    }

    private static int ReportAccuracy(string root)
    {
        var jsonPath = Path.Combine(root, "report.json");
        if (!File.Exists(jsonPath))
        {
            Console.Error.WriteLine($"[report] {jsonPath} not found — run `SimulatorBench run` first");
            return 2;
        }
        var results = JsonSerializer.Deserialize<List<Reporter.CaseResult>>(File.ReadAllText(jsonPath))!;
        var outPath = Path.Combine(root, "REPORT_simulator_accuracy.md");
        Reporter.WriteMarkdownAccuracy(outPath, results, jsonPath);
        Console.WriteLine($"[report] wrote {outPath}  ({results.Count} cases)");
        return 0;
    }

    /// <summary>
    /// The golden master of the last <c>run</c>: SHA-256 of each <c>results/kmila.vcd</c>
    /// without its <c>$date</c> block. <c>--check</c> compares against a baseline file,
    /// <c>--write</c> creates one (only for a NEW dated baseline folder).
    /// </summary>
    private static int Hash(string root, string? check, string? write)
    {
        var current = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (var caseDir in Directory.EnumerateDirectories(Path.Combine(root, "Cases")))
        {
            var vcd = Path.Combine(caseDir, "results", "kmila.vcd");
            if (File.Exists(vcd)) current[Path.GetFileName(caseDir)] = GoldenHashes.Of(File.ReadAllText(vcd));
        }
        string text = GoldenHashes.Format(current);
        if (write != null)
        {
            if (File.Exists(write)) { Console.Error.WriteLine($"[hash] {write} exists — a baseline is never overwritten"); return 2; }
            File.WriteAllText(write, text);
            Console.WriteLine($"[hash] wrote {current.Count} hashes to {write}");
            return 0;
        }
        if (check == null) { Console.Write(text); return 0; }
        var problems = GoldenHashes.Compare(GoldenHashes.Parse(File.ReadAllText(check)), current);
        foreach (var p in problems) Console.WriteLine($"  {p}");
        Console.WriteLine(problems.Count == 0
            ? $"[hash] {current.Count}/{current.Count} identical to {check}"
            : $"[hash] {problems.Count} difference(s) against {check}");
        return problems.Count == 0 ? 0 : 1;
    }

    private static async Task<int> VerifyAsync(string api, string? token)
    {
        Console.WriteLine($"[verify] api={api}");
        using var client = new KmilaApiClient(api, token: token);
        bool kOk = await client.HealthAsync();
        Console.WriteLine($"  Kmila API:    {(kOk ? "OK" : "UNREACHABLE")}");

        var (gOk, gVer) = await new GhdlReferenceSimulator().VersionAsync();
        Console.WriteLine($"  GHDL:         {(gOk ? "OK — " + gVer : "MISSING (run Setup/install-deps.sh)")}");

        // Tier 5.2 Phase B rev 2 — drift check between the host's live
        // OpenAPI output and the committed wwwroot/openapi/v1.json snapshot.
        // Both hosts (Kmila.Web via MapOpenApi, MAUI via bundled asset)
        // ship this file; the shim + external tooling read from it. If it
        // diverges from the live spec, docs go stale silently. The check
        // only runs when the API is reachable AND the snapshot file is
        // present — either missing → skipped, no failure.
        var docDrift = "SKIPPED";
        if (kOk)
        {
            var snapshotPath = DefaultOpenApiSnapshot();
            if (File.Exists(snapshotPath))
            {
                var live = await client.GetOpenApiJsonAsync();
                if (live == null)
                {
                    docDrift = "SKIPPED (host does not serve /openapi/v1.json)";
                }
                else
                {
                    var snap = File.ReadAllText(snapshotPath);
                    // Normalize the `servers` array before comparing —
                    // MapOpenApi fills it from the request Host header, so
                    // the same spec looks different when hit via localhost
                    // vs 127.0.0.1. Real surface drift lives in `paths` and
                    // `components`, not in this reflection of the caller.
                    if (string.Equals(NormalizeOpenApi(live), NormalizeOpenApi(snap), StringComparison.Ordinal))
                    {
                        docDrift = "OK — snapshot matches live";
                    }
                    else
                    {
                        docDrift = "DRIFT — regenerate with:\n"
                                 + $"                    curl {api.TrimEnd('/')}/openapi/v1.json \\\n"
                                 + $"                      > {snapshotPath}";
                    }
                }
            }
        }
        Console.WriteLine($"  OpenAPI snap: {docDrift}");

        // Drift is a soft failure — return non-zero so CI catches it, but
        // don't gate the base kOk/gOk pass. Users can rerun `verify` after
        // regenerating.
        bool driftClean = docDrift.StartsWith("OK") || docDrift.StartsWith("SKIPPED");
        return (kOk && gOk && driftClean) ? 0 : 1;
    }

    private static string NormalizeOpenApi(string json)
    {
        try
        {
            var node = System.Text.Json.Nodes.JsonNode.Parse(json);
            // Strip the `servers` array — it reflects the caller's host,
            // not the API surface.
            if (node is System.Text.Json.Nodes.JsonObject obj)
            {
                obj.Remove("servers");
            }
            return node?.ToJsonString()
                ?? json;
        }
        catch
        {
            return json;
        }
    }

    private static string DefaultOpenApiSnapshot() => SharedContentPaths.Find(Path.Combine("openapi", "v1.json")) ?? "";

    private static int ListCases(string root)
    {
        var dir = Path.Combine(root, "Cases");
        if (!Directory.Exists(dir)) { Console.WriteLine("(no Cases/ dir)"); return 0; }
        foreach (var sub in Directory.EnumerateDirectories(dir).OrderBy(p => p))
        {
            var metaPath = Path.Combine(sub, "meta.json");
            if (!File.Exists(metaPath)) continue;
            var meta = JsonSerializer.Deserialize<CaseMeta>(File.ReadAllText(metaPath))!;
            Console.WriteLine($"  {meta.Id,-32}  {meta.Title}{(meta.SkipReason != null ? "  [SKIP: " + meta.SkipReason + "]" : "")}");
        }
        return 0;
    }

    private static async Task<int> RunAsync(string api, string root, string? only, bool keep, bool roundtrip, bool inProcess, string? token)
    {
        if (roundtrip) Console.WriteLine("[run] --roundtrip: kmila.vhdl → VhdlBlockBuilder → VhdlBlockEmitter → submit");
        var ghdl = new GhdlReferenceSimulator();
        using var client = new KmilaApiClient(api, token: token);
        IKmilaRunner kmila;
        if (inProcess)
        {
            Console.WriteLine("[run] Kmila in process (HeadlessSimulator, no server)");
            kmila = new InProcessKmilaRunner(keep);
        }
        else
        {
            if (!await client.HealthAsync())
            {
                Console.Error.WriteLine($"[run] Kmila API unreachable at {api}");
                return 2;
            }
            kmila = new HttpKmilaRunner(client, keep);
        }

        var casesDir = Path.Combine(root, "Cases");
        if (!Directory.Exists(casesDir)) { Console.Error.WriteLine($"[run] no Cases/ at {casesDir}"); return 2; }

        var results = new List<Reporter.CaseResult>();
        foreach (var caseDir in Directory.EnumerateDirectories(casesDir).OrderBy(p => p))
        {
            var metaPath = Path.Combine(caseDir, "meta.json");
            if (!File.Exists(metaPath)) continue;
            var meta = JsonSerializer.Deserialize<CaseMeta>(File.ReadAllText(metaPath))!;
            if (only != null && !meta.Id.Contains(only, StringComparison.OrdinalIgnoreCase)) continue;

            var result = new Reporter.CaseResult { Id = meta.Id, Title = meta.Title };
            if (meta.SkipReason != null)
            {
                result.Skipped = true; result.SkipReason = meta.SkipReason;
                results.Add(result); continue;
            }

            try { await EvaluateCaseAsync(meta, caseDir, ghdl, kmila, roundtrip, result); }
            catch (Exception ex) { result.KmilaError = ex.Message; }
            results.Add(result);
        }

        Reporter.WriteConsoleSummary(results);
        Reporter.WriteJson(Path.Combine(root, "report.json"), results);
        Console.WriteLine($"[run] wrote {Path.Combine(root, "report.json")}");

        bool allOk = results.All(r => r.Skipped || r.Pass);
        return allOk ? 0 : 1;
    }

    private static async Task EvaluateCaseAsync(
        CaseMeta meta, string caseDir,
        IReferenceSimulator ghdl, IKmilaRunner kmila,
        bool roundtrip, Reporter.CaseResult result)
    {
        // 1. Run GHDL against the reference sources (author's untouched code).
        var refDir = Path.Combine(caseDir, "reference");
        var resultsDir = Path.Combine(caseDir, "results");
        Directory.CreateDirectory(resultsDir);

        if (!Directory.Exists(refDir))
        {
            result.GhdlError = "missing reference/ directory";
            return;
        }
        // The meta's order: `library work` analyzes dependencies before dependents.
        var refSources = meta.ReferenceSources.Select(s => Path.Combine(refDir, s)).ToList();
        if (refSources.Count == 0)
        {
            result.GhdlError = "meta.json lists no referenceSources";
            return;
        }

        var ghdlRun = await ghdl.RunAsync(new ReferenceRequest(
            refSources,
            string.IsNullOrEmpty(meta.TopUnit) ? meta.Entity : meta.TopUnit,
            meta.DurationNs,
            meta.GhdlStd));
        string ghdlDir = Path.Combine(resultsDir, "ghdl");
        if (Directory.Exists(ghdlDir)) Directory.Delete(ghdlDir, recursive: true);
        Directory.CreateDirectory(ghdlDir);
        File.WriteAllText(Path.Combine(ghdlDir, "ghdl.log"), ghdlRun.Log);
        if (!ghdlRun.Ok)
        {
            result.GhdlError = $"ghdl exit={ghdlRun.ExitCode}";
            return;
        }
        File.WriteAllText(Path.Combine(ghdlDir, "golden.vcd"), ghdlRun.Vcd);
        var golden = VcdReader.Parse(ghdlRun.Vcd!);

        // 2. Run Kmila on the case's own kmila.vhdl.
        var kmilaPath = Path.Combine(caseDir, meta.KmilaSource);
        if (!File.Exists(kmilaPath))
        {
            result.KmilaError = $"missing {meta.KmilaSource}";
            return;
        }
        string kmilaVhdl = File.ReadAllText(kmilaPath);

        // Phase 21 round trip through the block editor: a FAIL here that passes
        // in a plain `run` is block-editor semantic drift.
        if (roundtrip)
        {
            var builder = new Kmila.Shared.Services.VhdlBlockBuilder();
            var emitter = new Kmila.Shared.Services.VhdlBlockEmitter();
            var v1 = emitter.Emit(builder.Build(kmilaVhdl));
            result.RoundTripRaws  = builder.LastRawCount;
            result.RoundTripDiags = emitter.LastDiagnostics.Count;
            File.WriteAllText(Path.Combine(resultsDir, "kmila.roundtripped.vhdl"), v1);
            kmilaVhdl = v1;
        }

        // Stimulus: the golden dump's input changes (autoStimulus) followed by the
        // hand-written list (which may tag an initial value the testbench left implicit).
        var inputs = meta.Ports.Where(p => p.Dir.Equals("in", StringComparison.OrdinalIgnoreCase)).ToList();
        var portMoments = meta.AutoStimulus
            ? StimulusDeriver.FromGolden(golden, inputs.Select(p => p.Name))
            : new List<ApiPortMoment>();
        portMoments.AddRange(meta.Stimulus);

        var sim = await kmila.SimulateAsync(
            [new SourceFile(meta.KmilaSource, kmilaVhdl)],
            new SimulateRequest
            {
                EntryPoint = meta.Entity,
                TimeScale = meta.TimeScale,
                Duration = meta.DurationNs,
                SystemClockMhz = meta.SystemClockMhz,
                TickResNs = meta.TickResNs,
                PortMoments = portMoments,
                Clocks = meta.Clocks,
                PortInitials = TestbenchInitials.Read(refSources, inputs.Select(p => (p.Name, p.Width))),
            });
        result.KmilaMs = sim.DurationMs;
        File.WriteAllText(Path.Combine(resultsDir, "kmila.vcd"), sim.Vcd);

        // 3. Strict comparison on the declared output ports.
        var outputPorts = meta.Ports
            .Where(p => p.Dir.Equals("out", StringComparison.OrdinalIgnoreCase)
                     || p.Dir.Equals("inout", StringComparison.OrdinalIgnoreCase))
            .Select(p => p.Name);
        var diff = WaveformComparer.Compare(golden, VcdReader.Parse(sim.Vcd),
            CompareOptions.Strict(outputPorts, ignoreT0: meta.T0Divergence != null));
        bool pass = diff.All(d => d.Equal);
        result.KnownGap = pass ? null : meta.KnownGap;
        result.Diff = diff;
        result.Pass = pass;
        File.WriteAllText(Path.Combine(resultsDir, "diff.json"),
            JsonSerializer.Serialize(diff, Reporter.Indented));
    }

    private static string DefaultRoot()
    {
        // Resolves relative to the bench .csproj location at run-time. Walk
        // up from the assembly until we find a SimulatorBench.csproj sibling.
        var dir = AppContext.BaseDirectory;
        for (int i = 0; i < 8 && dir != null; i++)
        {
            if (File.Exists(Path.Combine(dir, "SimulatorBench.csproj"))) return dir;
            dir = Path.GetDirectoryName(dir);
        }
        return Environment.CurrentDirectory;
    }

    private static string ArgOrEnv(string[] args, string flag, string envName, string fallback)
    {
        var v = ArgValue(args, flag);
        if (!string.IsNullOrEmpty(v)) return v;
        var e = Environment.GetEnvironmentVariable(envName);
        return string.IsNullOrEmpty(e) ? fallback : e;
    }

    private static string? ArgValue(string[] args, string flag)
    {
        for (int i = 0; i < args.Length - 1; i++)
            if (args[i] == flag) return args[i + 1];
        return null;
    }

    private static bool HasFlag(string[] args, string flag) => args.Contains(flag);

    private static int Unknown(string cmd) { Console.Error.WriteLine($"unknown command: {cmd}"); PrintHelp(); return 64; }

    private static void PrintHelp()
    {
        Console.WriteLine("""
            SimulatorBench — Kmila vs GHDL accuracy harness

            Usage:
              dotnet run --project SimulatorBench -- verify [--api URL]
              dotnet run --project SimulatorBench -- list
              dotnet run --project SimulatorBench -- run    [--api URL] [--in-process] [--only ID] [--keep] [--roundtrip]
              dotnet run --project SimulatorBench -- hash   [--check FILE] [--write FILE]
              dotnet run --project SimulatorBench -- audit-concepts [--concepts-root PATH] [--only LANG]
              dotnet run --project SimulatorBench -- audit-synth    [--root PATH] [--only ID]
              dotnet run --project SimulatorBench -- report

            Flags:
              --api URL           Kmila Web API base. Default $KMILA_API or http://127.0.0.1:5298
              --token TOKEN       Bearer token for a host with KMILA_LOCAL_API_TOKEN. Default $KMILA_TOKEN
              --root PATH         Bench root (Cases/ tree). Default $BENCH_ROOT or the project's own directory
              --in-process        Run Kmila in this process (HeadlessSimulator) instead of over HTTP
              --concepts-root PATH  Concepts corpus root. Default $CONCEPTS_ROOT or the checkout's
                                  App/Kmila/Kmila.Shared/wwwroot/Concepts/
              --only ID           Run only cases/exercises whose id contains the substring
              --keep              Keep sandbox projects after the run (default: delete)
              --roundtrip         Push each case's kmila.vhdl through the block editor
                                  (VhdlBlockBuilder + VhdlBlockEmitter) first: a FAIL means
                                  the round trip altered simulation semantics.

            hash:
              SHA-256 of every Cases/*/results/kmila.vcd without its $date block.
              --check FILE compares with a baseline (Tests/baseline/<date>/bench-kmila-vcd.sha256);
              --write FILE creates one and refuses to overwrite an existing file.
              Practice starters are audited by PracticeValidator --audit-starters.

            audit-concepts:
              Walks Concepts/manifest.json + Concepts/{lang}/**. Reports three
              defect classes across all 7 UI languages:
                - manifest string still prefixed with ⚠ (placeholder marker)
                - lesson missing per-lang body .md
                - Player-lesson timeline note dict missing any lang key
              Filesystem-only; no Kmila API required. Writes audit-report.json
              next to the concepts manifest. Exit code non-zero when flagged>0.

            Setup:
              Setup/install-deps.sh   — installs ghdl + gtkwave via Homebrew
            """);
    }
}

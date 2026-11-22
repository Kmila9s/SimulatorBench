using System.Text.Json;
using Kmila.Shared.Services;
using Kmila.TestKit;
using Kmila.TestKit.Cases;
using Kmila.TestKit.Reference;
using Kmila.TestKit.Runners;
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
        bool http = HasFlag(args, "--http");
        var mode = HasFlag(args, "--legacy-source") ? SourceMode.Legacy : SourceMode.Verbatim;

        if (args.Length == 0 || args[0] is "help" or "--help" or "-h")
        {
            PrintHelp();
            return 0;
        }

        return args[0] switch
        {
            "verify"          => await VerifyAsync(api, token),
            "run"             => await RunAsync(api, root, only, keep, roundtrip, http, mode, token),
            "hash"            => Hash(root, mode, ArgValue(args, "--check"), ArgValue(args, "--write")),
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
    /// SHA-256 of each Kmila VCD of the last <c>run</c> in <paramref name="mode"/>, without
    /// its <c>$date</c> block. Legacy hashes are keyed by case (one legacy source per case:
    /// the golden master); verbatim ones by <c>case/lang</c>. <c>--check</c> compares with a
    /// baseline file, <c>--write</c> creates one (only for a NEW dated baseline folder).
    /// </summary>
    private static int Hash(string root, SourceMode mode, string? check, string? write)
    {
        var current = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (var c in CaseLoader.LoadAll(Path.Combine(root, "Cases")))
            foreach (var lang in c.Variants.Languages)
            {
                var vcd = Path.Combine(CaseRunner.ModeDir(c.Dir, lang, mode), "kmila.vcd");
                if (!File.Exists(vcd)) continue;
                current[mode == SourceMode.Legacy ? c.Spec.Id : $"{c.Spec.Id}/{lang.Id}"] = GoldenHashes.Of(File.ReadAllText(vcd));
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
        Console.WriteLine($"  Kmila API:      {(kOk ? "OK" : "UNREACHABLE")}");

        bool gOk = true;
        foreach (var reference in ReferenceSimulators.Registered)
        {
            var (installed, version) = await reference.VersionAsync();
            gOk &= installed;
            Console.WriteLine($"  {reference.Language.DisplayName + " reference:",-16}{(installed ? "OK — " + version : "MISSING (run Setup/install-deps.sh)")}");
        }

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
        Console.WriteLine($"  OpenAPI snap:   {docDrift}");

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
        foreach (var c in CaseLoader.LoadAll(dir))
            Console.WriteLine($"  {c.Spec.Id,-32}  [{string.Join(",", c.Variants.Languages.Select(l => l.Id))}]  {c.Spec.Title}"
                + (c.Spec.SkipReason != null ? "  [SKIP: " + c.Spec.SkipReason + "]" : ""));
        return 0;
    }

    private static async Task<int> RunAsync(string api, string root, string? only, bool keep, bool roundtrip, bool http, SourceMode mode, string? token)
    {
        Console.WriteLine($"[run] Kmila on the {(mode == SourceMode.Legacy ? "legacy re-implementations (golden master)" : "reference sources, verbatim")}"
            + $", {(http ? "over HTTP at " + api : "in process")}{(roundtrip ? ", through the block editor" : "")}");
        using var client = http ? new KmilaApiClient(api, token: token) : null;
        if (client != null && !await client.HealthAsync())
        {
            Console.Error.WriteLine($"[run] Kmila API unreachable at {api}");
            return 2;
        }
        IKmilaRunner kmila = client != null ? new HttpKmilaRunner(client, keep) : new InProcessKmilaRunner(keep);
        var runner = new CaseRunner(kmila, mode, roundtrip);

        var casesDir = Path.Combine(root, "Cases");
        if (!Directory.Exists(casesDir)) { Console.Error.WriteLine($"[run] no Cases/ at {casesDir}"); return 2; }
        var results = new List<Reporter.CaseResult>();
        foreach (var c in CaseLoader.LoadAll(casesDir))
            if (only == null || c.Spec.Id.Contains(only, StringComparison.OrdinalIgnoreCase))
                results.Add(await runner.RunAsync(c));

        // Verbatim failures are ratcheted by known-gaps.json (variant failures only:
        // a missing variant or disagreeing goldens always fail); legacy must pass outright.
        var violations = new List<string>();
        if (mode == SourceMode.Verbatim)
        {
            var (ratchet, reasons) = KnownGaps.Apply(KnownGaps.Load(Path.Combine(root, KnownGapsFile)),
                results.Where(r => !r.Skipped).SelectMany(r => r.Variants.Select(v => (r.Id, v.Language, v.Pass))));
            violations = ratchet;
            foreach (var r in results) r.KnownGap = reasons.GetValueOrDefault(r.Id);
        }
        bool ok = violations.Count == 0 && results.All(r => r.Skipped || r.Pass
            || (mode == SourceMode.Verbatim && r.KnownGap != null && r.MissingVariants.Count == 0 && r.GoldensAgree));

        Reporter.WriteConsoleSummary(results);
        string reportPath = Path.Combine(root, mode == SourceMode.Legacy ? "report.legacy.json" : "report.json");
        Reporter.WriteJson(reportPath, results);
        Console.WriteLine($"[run] wrote {reportPath}");
        foreach (var v in violations) Console.WriteLine($"  ✗ {v}");
        Console.WriteLine(!ok ? "[run] FAILED"
            : mode == SourceMode.Verbatim ? "[run] ratchet OK: every failure is a listed known gap"
            : "[run] golden master: all cases pass");
        return ok ? 0 : 1;
    }

    private const string KnownGapsFile = "known-gaps.json";

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
              dotnet run --project SimulatorBench -- run    [--legacy-source] [--http] [--api URL] [--only ID] [--keep] [--roundtrip]
              dotnet run --project SimulatorBench -- hash   [--legacy-source] [--check FILE] [--write FILE]
              dotnet run --project SimulatorBench -- audit-concepts [--concepts-root PATH] [--only LANG]
              dotnet run --project SimulatorBench -- audit-synth    [--root PATH] [--only ID]
              dotnet run --project SimulatorBench -- report

            Flags:
              --api URL           Kmila Web API base. Default $KMILA_API or http://127.0.0.1:5298
              --token TOKEN       Bearer token for a host with KMILA_LOCAL_API_TOKEN. Default $KMILA_TOKEN
              --root PATH         Bench root (Cases/ tree). Default $BENCH_ROOT or the project's own directory
              --legacy-source     Simulate legacy/kmila.vhdl (the golden master) instead of the
                                  reference sources verbatim
              --http              Run Kmila through a host's /api/v1 instead of in this process
              --concepts-root PATH  Concepts corpus root. Default $CONCEPTS_ROOT or the checkout's
                                  App/Kmila/Kmila.Shared/wwwroot/Concepts/
              --only ID           Run only cases/exercises whose id contains the substring
              --keep              Keep sandbox projects after the run (default: delete)
              --roundtrip         Push each case's kmila.vhdl through the block editor
                                  (VhdlBlockBuilder + VhdlBlockEmitter) first: a FAIL means
                                  the round trip altered simulation semantics.

            run:
              Cases/<id>/case.json (ports, timing, stimulus) + variants/<lang>/variant.json
              (reference/ sources, testbench top, DUT entity, legacySource). Each variant runs
              the reference simulator on the testbench and Kmila on the DUT; a case passes when
              every supported language has a variant, each matches its golden and the goldens
              agree. Verbatim failures must be listed in known-gaps.json (the list only shrinks);
              with --legacy-source every case must pass. Outputs: results/<lang>/.

            hash:
              SHA-256 of every results/<lang>/<legacy|verbatim>/kmila.vcd without its $date block.
              --check FILE compares with a baseline (Tests/baseline/<date>/bench-kmila-vcd.sha256);
              --write FILE creates one and refuses to overwrite an existing file.
              Practice solutions, starters and the GHDL oracle are checked by PracticeValidator.

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

using System.Text.Json;
using Kmila.Frontend;
using Kmila.Shared.Services.Vcd;
using Kmila.TestKit.Cases;
using Kmila.TestKit.Reference;
using Kmila.TestKit.Runners;

namespace SimulatorBench.Tools;

/// <summary>Which sources Kmila simulates.</summary>
public enum SourceMode
{
    /// <summary>The author's reference sources, unmodified (the official verdict).</summary>
    Verbatim,
    /// <summary>The pre-verbatim re-implementation (<c>legacy/kmila.vhdl</c>): the golden master until the verbatim gaps close.</summary>
    Legacy,
}

/// <summary>
/// Runs one case: for each variant, the reference simulator on the author's
/// testbench (the golden dump), Kmila on the chosen sources with the case's
/// stimulus, and the strict comparison on the output ports; then the
/// multi-variant verdict. Outputs go to <c>results/&lt;lang&gt;/</c>.
/// </summary>
public sealed class CaseRunner(IKmilaRunner kmila, SourceMode mode, bool roundtrip)
{
    /// <summary>Folder of one variant's run outputs: <c>results/&lt;lang&gt;/</c> (golden, reference log).</summary>
    public static string ResultsDir(string caseDir, HdlLanguage language) => Path.Combine(caseDir, "results", language.Id);

    /// <summary>Folder of a mode's Kmila outputs: <c>results/&lt;lang&gt;/&lt;legacy|verbatim&gt;/</c> (kmila.vcd, diff.json).</summary>
    public static string ModeDir(string caseDir, HdlLanguage language, SourceMode mode) =>
        Path.Combine(ResultsDir(caseDir, language), mode == SourceMode.Legacy ? "legacy" : "verbatim");

    /// <summary>Runs every variant of <paramref name="c"/> (none when the case is skipped).</summary>
    public async Task<Reporter.CaseResult> RunAsync(LoadedCase c)
    {
        var result = new Reporter.CaseResult { Id = c.Spec.Id, Title = c.Spec.Title };
        if (c.Spec.SkipReason != null)
        {
            result.Skipped = true; result.SkipReason = c.Spec.SkipReason;
            return result;
        }
        var outcomes = new Dictionary<string, VariantOutcome>(StringComparer.OrdinalIgnoreCase);
        foreach (var language in c.Variants.Languages)
        {
            var (vr, golden) = await RunVariantAsync(c, c.Variants.For(language)!);
            result.Variants.Add(vr);
            outcomes[language.Id] = new VariantOutcome(vr.Pass, golden);
        }
        var verdict = VariantVerdict.Aggregate(HdlLanguages.Supported, HdlVariants<VariantOutcome>.FromIds(outcomes), c.Spec.Outputs);
        result.Pass = verdict.Outcome == CaseOutcome.Pass;
        result.MissingVariants = verdict.Missing.Select(l => l.Id).ToList();
        result.GoldensAgree = verdict.GoldensAgree;
        return result;
    }

    private async Task<(Reporter.VariantResult Result, VcdDocument? Golden)> RunVariantAsync(LoadedCase c, CaseVariant v)
    {
        var r = new Reporter.VariantResult { Language = v.Language.Id };
        string langDir = ResultsDir(c.Dir, v.Language);
        string outDir = ModeDir(c.Dir, v.Language, mode);
        if (Directory.Exists(outDir)) Directory.Delete(outDir, recursive: true);
        Directory.CreateDirectory(outDir);
        try
        {
            // 1. The language's reference simulator on the author's untouched testbench.
            var reference = ReferenceSimulators.For(v.Language);
            if (reference is null)
            {
                r.ReferenceError = $"no reference simulator for {v.Language.DisplayName}";
                return (r, null);
            }
            var run = await reference.RunAsync(CaseSimulation.Reference(c.Spec, v));
            File.WriteAllText(Path.Combine(langDir, "reference.log"), run.Log);
            if (!run.Ok)
            {
                r.ReferenceError = $"reference exit={run.ExitCode}";
                return (r, null);
            }
            File.WriteAllText(Path.Combine(langDir, "golden.vcd"), run.Vcd);
            var golden = VcdReader.Parse(run.Vcd!);

            // 2. Kmila on the chosen sources, with the case's stimulus; 3. strict comparison on the outputs.
            bool ignoreT0 = mode == SourceMode.Legacy && v.LegacyT0Divergence != null;
            var (sim, diff) = await CaseSimulation.RunAsync(kmila, c.Spec, v, KmilaSources(c, v, r), golden, ignoreT0);
            r.KmilaMs = sim.DurationMs;
            r.KmilaError = sim.Error;
            r.Diff = diff;
            File.WriteAllText(Path.Combine(outDir, "kmila.vcd"), sim.Vcd);
            r.Pass = sim.Error is null && r.Diff.All(d => d.Equal);
            File.WriteAllText(Path.Combine(outDir, "diff.json"), JsonSerializer.Serialize(r.Diff, Reporter.Indented));
            return (r, golden);
        }
        catch (Exception ex) when (ex is InvalidOperationException or NotSupportedException or ArgumentException or IOException or HttpRequestException)
        {
            r.KmilaError ??= ex.Message;
            return (r, null);
        }
    }

    /// <summary>The files Kmila receives, by name: the reference sources verbatim, or the legacy re-implementation.</summary>
    private List<SourceFile> KmilaSources(LoadedCase c, CaseVariant v, Reporter.VariantResult r)
    {
        var paths = mode == SourceMode.Legacy
            ? [Path.Combine(c.Dir, v.LegacySource ?? throw new InvalidOperationException($"{c.Spec.Id}/{v.Language.Id}: no legacySource"))]
            : v.SourcePaths;
        var files = CaseSimulation.Read(paths);
        if (!roundtrip) return files;
        // Block-editor round trip: a FAIL that passes without it is block-editor semantic drift.
        return files.Select(f =>
        {
            var builder = new Kmila.Shared.Services.VhdlBlockBuilder();
            var emitter = new Kmila.Shared.Services.VhdlBlockEmitter();
            var emitted = emitter.Emit(builder.Build(f.Content));
            r.RoundTripRaws += builder.LastRawCount;
            r.RoundTripDiags += emitter.LastDiagnostics.Count;
            return f with { Content = emitted };
        }).ToList();
    }
}

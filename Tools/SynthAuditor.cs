using Kmila.Frontend;
using Kmila.TestKit.Cases;
using Interpreter.Synthesis;

namespace SimulatorBench.Tools;

// Synth-time diagnostic auditor (Tier 4.3 pass 4, 2026-07-28).
//
// For every case under a Bench root's Cases/ tree, parse its kmila.vhdl in-
// proc through Debugger.Repositories.Parser, run each parsed Entity through
// Interpreter.Synthesis.Synthesizer, and record the produced Diagnostics
// grouped by (Kind, Severity). Baselines the schematic black-box surface so
// tightening passes (function-body inlining, procedure decomposition, etc.)
// have a measurable regression guard.
//
// Output: audit-report.json next to SimulatorBench.csproj plus a
// human-readable stdout summary. No file mutations. Exit 0 iff every
// diagnostic emitted is Info-severity (Flagged counts Warning + Error).
public static class SynthAuditor
{
    public sealed class Finding
    {
        public string CaseId  { get; set; } = "";
        public string Entity  { get; set; } = "";
        public string Kind    { get; set; } = "";
        public string Severity{ get; set; } = "";
        public string Message { get; set; } = "";
        public string? SourceLine { get; set; }
    }

    public sealed class AuditReport
    {
        public string AuditedAt { get; set; } = "";
        public string BenchRoot { get; set; } = "";
        public int TotalCases { get; set; }
        public int CasesWithFindings { get; set; }
        public int Total    { get; set; }
        public int Flagged  { get; set; }
        public Dictionary<string, int> ByKind     { get; set; } = new();
        public Dictionary<string, int> BySeverity { get; set; } = new();
        public List<Finding> Findings { get; set; } = new();
    }

    public static AuditReport Run(string benchRoot, string? only = null, Action<string>? log = null)
    {
        log ??= _ => { };
        var casesRoot = Path.Combine(benchRoot, "Cases");
        if (!Directory.Exists(casesRoot))
            throw new DirectoryNotFoundException($"Cases/ tree not found under {benchRoot}");

        var report = new AuditReport
        {
            AuditedAt = DateTime.UtcNow.ToString("O"),
            BenchRoot = benchRoot
        };

        foreach (var loaded in CaseLoader.LoadAll(casesRoot))
        {
            var caseId = loaded.Spec.Id;
            if (only != null && !string.Equals(only, caseId, StringComparison.OrdinalIgnoreCase))
                continue;

            // The synthesizer reads VHDL: audit the VHDL variant's legacy re-implementation.
            if (loaded.Variants.For(HdlLanguages.Vhdl) is not { LegacySource: { } legacy }) continue;
            var vhdlPath = Path.Combine(loaded.Dir, legacy);
            if (!File.Exists(vhdlPath)) continue;

            // Synth diagnostic kinds the case declares as permanent (demoted to Info).
            var expected = new HashSet<string>(loaded.Spec.ExpectedSynthDiagnostics, StringComparer.OrdinalIgnoreCase);

            report.TotalCases++;
            var caseFindings = new List<Finding>();
            try
            {
                var parser = new Debugger.Repositories.Parser(vhdlPath);
                parser.ParseFile();
                foreach (var entity in parser.Entities)
                {
                    Netlist netlist;
                    try
                    {
                        netlist = Synthesizer.Synthesize(entity);
                    }
                    catch (Exception ex)
                    {
                        caseFindings.Add(new Finding
                        {
                            CaseId  = caseId,
                            Entity  = entity.Name,
                            Kind    = "SynthThrew",
                            Severity= "Error",
                            Message = $"Synthesizer.Synthesize threw: {ex.GetType().Name}: {ex.Message}\nTRACE: {ex.StackTrace?.Split('\n').FirstOrDefault(l => l.Contains("Interpreter.Synthesis") || l.Contains("Interpreter.Repositories"))?.Trim()}",
                        });
                        continue;
                    }
                    foreach (var d in netlist.Diagnostics)
                    {
                        // Pass 25 (2026-07-30): demote expected diagnostics
                        // to Info so they don't inflate the "flagged" count.
                        var effectiveSeverity = expected.Contains(d.Kind)
                            ? "Info"
                            : d.Severity.ToString();
                        caseFindings.Add(new Finding
                        {
                            CaseId  = caseId,
                            Entity  = entity.Name,
                            Kind    = d.Kind,
                            Severity= effectiveSeverity,
                            Message = expected.Contains(d.Kind)
                                ? $"[expected] {d.Message}"
                                : d.Message,
                            SourceLine = d.SourceLine,
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                caseFindings.Add(new Finding
                {
                    CaseId  = caseId,
                    Entity  = "",
                    Kind    = "ParseThrew",
                    Severity= "Error",
                    Message = $"Parser.ParseFile threw: {ex.GetType().Name}: {ex.Message}",
                });
            }

            if (caseFindings.Count > 0)
            {
                report.CasesWithFindings++;
                report.Findings.AddRange(caseFindings);
                var flaggedThisCase = caseFindings.Count(f =>
                    !string.Equals(f.Severity, "Info", StringComparison.OrdinalIgnoreCase));
                log($"[{(flaggedThisCase > 0 ? "FLAG" : "info")}] {caseId}  ({caseFindings.Count} diag, {flaggedThisCase} flagged)");
            }
            else
            {
                log($"[ok]   {caseId}");
            }
        }

        report.Total = report.Findings.Count;
        report.Flagged = report.Findings.Count(f =>
            !string.Equals(f.Severity, "Info", StringComparison.OrdinalIgnoreCase));
        foreach (var f in report.Findings)
        {
            report.ByKind[f.Kind] = report.ByKind.GetValueOrDefault(f.Kind) + 1;
            report.BySeverity[f.Severity] = report.BySeverity.GetValueOrDefault(f.Severity) + 1;
        }
        return report;
    }
}

using System.Text.Json.Serialization;
using Kmila.Shared.Services.Api;

namespace SimulatorBench.Tools;

// Schema mirrors HANDOFF §4.5. One per case under Cases/<id>/meta.json.
public sealed class CaseMeta
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("title")] public string Title { get; set; } = "";
    [JsonPropertyName("sourceUrl")] public string SourceUrl { get; set; } = "";
    [JsonPropertyName("license")] public string License { get; set; } = "";
    [JsonPropertyName("fetchedAt")] public string FetchedAt { get; set; } = "";
    [JsonPropertyName("entity")] public string Entity { get; set; } = "";
    [JsonPropertyName("topUnit")] public string TopUnit { get; set; } = "";
    [JsonPropertyName("ports")] public List<CasePort> Ports { get; set; } = new();
    [JsonPropertyName("timeScale")] public string TimeScale { get; set; } = "NS";
    [JsonPropertyName("durationNs")] public int DurationNs { get; set; } = 1000;
    [JsonPropertyName("tickResNs")] public int TickResNs { get; set; } = 10;
    [JsonPropertyName("systemClockMhz")] public int SystemClockMhz { get; set; } = 50;
    [JsonPropertyName("stimulus")] public List<ApiPortMoment> Stimulus { get; set; } = new();
    /// <summary>Clocks driven on input ports (cases whose stimulus is hand-written; autoStimulus cases take clk from the golden VCD).</summary>
    [JsonPropertyName("clocks")] public List<ApiClock> Clocks { get; set; } = new();
    /// <summary>
    /// Why <c>kmila.vhdl</c> (a re-implementation) differs from the reference at t=0 — verified by
    /// simulating the reference itself with Kmila (same t=0 values as GHDL). The t=0 sample is not
    /// compared until the bench simulates the reference verbatim (Fase 0, 5b).
    /// </summary>
    [JsonPropertyName("t0Divergence")] public string? T0Divergence { get; set; }
    /// <summary>A known engine gap (catalogue id + summary) behind a mismatch: reported as GAP, not PASS.</summary>
    [JsonPropertyName("knownGap")] public string? KnownGap { get; set; }
    [JsonPropertyName("problemDescription")] public string ProblemDescription { get; set; } = "";
    [JsonPropertyName("referenceSources")] public List<string> ReferenceSources { get; set; } = new();
    [JsonPropertyName("kmilaSource")] public string KmilaSource { get; set; } = "kmila.vhdl";
    [JsonPropertyName("skipReason")] public string? SkipReason { get; set; }

    /// <summary>GHDL <c>--std=</c> for the reference (null: the simulator's default, VHDL-2008).</summary>
    [JsonPropertyName("ghdlStd")] public string? GhdlStd { get; set; }

    /// <summary>
    /// When true, the bench derives Kmila stimulus from the input-port
    /// transitions observed in GHDL's golden VCD instead of using the
    /// hand-written `stimulus` list. Lets complex testbenches (nested
    /// loops, randomized stimulus) work without transcription. The
    /// `stimulus` field, if present, is appended AFTER the auto-derived
    /// transitions — useful for tagging an initial value the author's
    /// TB took as implicit. Default false.
    /// </summary>
    [JsonPropertyName("autoStimulus")] public bool AutoStimulus { get; set; }

    /// <summary>
    /// Pass 25 (2026-07-30): declare synth diagnostic Kinds that are
    /// expected (permanent, cannot be lowered — e.g. wait-in-process for
    /// fundamentally sequential logic). SynthAuditor demotes matching
    /// findings from Warning to Info so the flagged count reflects real
    /// regressions instead of the permanent floor.
    /// Example: ["BlackboxProcess"] on cases 141-146 (wait-in-process).
    /// </summary>
    [JsonPropertyName("expectedSynthDiagnostics")]
    public List<string> ExpectedSynthDiagnostics { get; set; } = new();
}

public sealed class CasePort
{
    [JsonPropertyName("name")] public string Name { get; set; } = "";
    [JsonPropertyName("dir")] public string Dir { get; set; } = "in";
    [JsonPropertyName("type")] public string Type { get; set; } = "std_logic";
    [JsonPropertyName("width")] public int Width { get; set; } = 1;
}

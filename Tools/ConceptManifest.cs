using System.Text.Json.Serialization;

namespace SimulatorBench.Tools;

// Records for Kmila.Shared/wwwroot/Concepts/manifest.json + the per-lesson
// {lessonId}.timeline.json sidecars. Consumed exclusively by ConceptAuditor
// (Tier 3.2 lesson-body coverage audit). Shape mirrors what
// Kmila.Shared/Services/ConceptCatalog.cs deserializes, with just enough
// depth to reach the localizable strings.

public sealed class ConceptManifest
{
    [JsonPropertyName("version")] public int Version { get; set; }
    [JsonPropertyName("modules")] public List<ConceptModule> Modules { get; set; } = new();
}

public sealed class ConceptModule
{
    [JsonPropertyName("id")]        public string Id { get; set; } = "";
    [JsonPropertyName("titles")]    public Dictionary<string, string> Titles { get; set; } = new();
    [JsonPropertyName("summaries")] public Dictionary<string, string> Summaries { get; set; } = new();
    [JsonPropertyName("lessons")]   public List<ConceptLesson> Lessons { get; set; } = new();
    [JsonPropertyName("exercises")] public List<ConceptExercise> Exercises { get; set; } = new();
}

public sealed class ConceptLesson
{
    [JsonPropertyName("id")]        public string Id { get; set; } = "";
    // "Player" | "Reading" — Player lessons pair a body .md with a
    // .timeline.json; Reading lessons are body-only.
    [JsonPropertyName("kind")]      public string Kind { get; set; } = "";
    [JsonPropertyName("titles")]    public Dictionary<string, string> Titles { get; set; } = new();
    [JsonPropertyName("summaries")] public Dictionary<string, string> Summaries { get; set; } = new();
}

public sealed class ConceptExercise
{
    [JsonPropertyName("id")]        public string Id { get; set; } = "";
    // "Recipe" | "Logic" | "Clocked" — code-driven, no body .md.
    [JsonPropertyName("kind")]      public string Kind { get; set; } = "";
    [JsonPropertyName("titles")]    public Dictionary<string, string> Titles { get; set; } = new();
    [JsonPropertyName("summaries")] public Dictionary<string, string> Summaries { get; set; } = new();
}

public sealed class ConceptTimelineDoc
{
    [JsonPropertyName("steps")] public List<ConceptTimelineStep> Steps { get; set; } = new();
}

public sealed class ConceptTimelineStep
{
    [JsonPropertyName("note")] public Dictionary<string, string> Note { get; set; } = new();
}

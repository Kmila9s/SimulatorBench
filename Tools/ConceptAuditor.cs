using System.Text.Json;

namespace SimulatorBench.Tools;

// Concept-body i18n coverage auditor (Tier 3.2, 2026-07-28).
//
// For each Concepts module, walks Kmila.Shared/wwwroot/Concepts/ and reports
// three defect classes across the seven supported languages:
//
//   1. missing-manifest-translation — any titles/summaries entry still
//      prefixed with "⚠ " (the placeholder convention from
//      feedback_translation_pending).
//   2. missing-body                 — a lesson (not exercise) whose per-lang
//      body .md file doesn't exist under Concepts/{lang}/{moduleId}/.
//   3. missing-timeline-lang-key    — a Player-kind lesson whose EN timeline
//      sidecar has any note dict without one of the 7 expected lang keys.
//
// Exercises (Recipe/Logic/Clocked) are code-driven — they intentionally
// don't ship a body .md, so the body check skips them; only their manifest
// strings are audited.
//
// Output: audit-report.json next to the concepts manifest, plus a
// human-readable stdout summary. No file mutations.
public static class ConceptAuditor
{
    // The seven UI languages every lesson body / manifest field must cover.
    private static readonly string[] Langs = { "en", "es", "fr", "de", "ch", "jp", "ar" };

    public sealed class Finding
    {
        // "missing-manifest-translation" | "missing-body" | "missing-timeline-lang-key"
        public string Kind { get; set; } = "";
        public string Lang { get; set; } = "";
        public string ModuleId { get; set; } = "";
        public string? LessonId { get; set; }
        // Dotted path for manifest findings ("titles" | "summaries") plus a
        // stepIndex hint for timeline findings.
        public string? Field { get; set; }
        public int? StepIndex { get; set; }
        public string? Detail { get; set; }
    }

    public sealed class AuditReport
    {
        public string AuditedAt { get; set; } = "";
        public string ConceptsRoot { get; set; } = "";
        public int Total { get; set; }
        public int Flagged { get; set; }
        public Dictionary<string, int> FlaggedByKind { get; set; } = new();
        public Dictionary<string, int> FlaggedByLang { get; set; } = new();
        public List<Finding> Findings { get; set; } = new();
    }

    public static AuditReport Run(string conceptsRoot, string? onlyLang = null, Action<string>? log = null)
    {
        log ??= _ => { };
        var manifestPath = Path.Combine(conceptsRoot, "manifest.json");
        if (!File.Exists(manifestPath))
            throw new FileNotFoundException($"Concepts manifest not found: {manifestPath}");

        var manifest = JsonSerializer.Deserialize<ConceptManifest>(File.ReadAllText(manifestPath))!;
        var report = new AuditReport
        {
            AuditedAt = DateTime.UtcNow.ToString("O"),
            ConceptsRoot = conceptsRoot
        };
        var findings = new List<Finding>();
        int totalChecks = 0;

        var langs = onlyLang != null ? new[] { onlyLang } : Langs;

        foreach (var mod in manifest.Modules)
        {
            // Module-level manifest fields.
            totalChecks += CheckManifestDict(findings, langs, mod.Id, null, "titles", mod.Titles);
            totalChecks += CheckManifestDict(findings, langs, mod.Id, null, "summaries", mod.Summaries);

            foreach (var lesson in mod.Lessons)
            {
                totalChecks += CheckManifestDict(findings, langs, mod.Id, lesson.Id, "titles", lesson.Titles);
                totalChecks += CheckManifestDict(findings, langs, mod.Id, lesson.Id, "summaries", lesson.Summaries);

                // Bodies: skip Reading-only? No — all body-bearing lessons
                // are either Player or Reading, and both need per-lang .md.
                // Only Exercises (Recipe/Logic/Clocked) skip body files.
                foreach (var lang in langs)
                {
                    totalChecks++;
                    var mdPath = Path.Combine(conceptsRoot, lang, mod.Id, $"{lesson.Id}.md");
                    if (!File.Exists(mdPath))
                        findings.Add(new Finding
                        {
                            Kind = "missing-body",
                            Lang = lang,
                            ModuleId = mod.Id,
                            LessonId = lesson.Id,
                            Detail = $"expected {Path.GetRelativePath(conceptsRoot, mdPath)}"
                        });
                }

                // Timelines: only Player kind. The authoritative timeline
                // file lives under en/; ConceptCatalog's fallback serves it
                // to every lang, and ExecutionPlayer picks the note by the
                // active lang key inside each step's `note` dict.
                if (string.Equals(lesson.Kind, "Player", StringComparison.OrdinalIgnoreCase))
                {
                    var tlPath = Path.Combine(conceptsRoot, "en", mod.Id, $"{lesson.Id}.timeline.json");
                    if (File.Exists(tlPath))
                    {
                        ConceptTimelineDoc? doc = null;
                        try { doc = JsonSerializer.Deserialize<ConceptTimelineDoc>(File.ReadAllText(tlPath)); }
                        catch (Exception ex)
                        {
                            findings.Add(new Finding
                            {
                                Kind = "missing-timeline-lang-key",
                                Lang = "*",
                                ModuleId = mod.Id,
                                LessonId = lesson.Id,
                                Detail = $"timeline parse error: {ex.Message}"
                            });
                        }
                        if (doc != null)
                        {
                            for (int i = 0; i < doc.Steps.Count; i++)
                            {
                                var note = doc.Steps[i].Note;
                                foreach (var lang in langs)
                                {
                                    totalChecks++;
                                    if (!note.TryGetValue(lang, out var v) || string.IsNullOrWhiteSpace(v))
                                        findings.Add(new Finding
                                        {
                                            Kind = "missing-timeline-lang-key",
                                            Lang = lang,
                                            ModuleId = mod.Id,
                                            LessonId = lesson.Id,
                                            StepIndex = i,
                                            Detail = "note dict is missing this lang key"
                                        });
                                }
                            }
                        }
                    }
                    else
                    {
                        findings.Add(new Finding
                        {
                            Kind = "missing-timeline-lang-key",
                            Lang = "*",
                            ModuleId = mod.Id,
                            LessonId = lesson.Id,
                            Detail = $"Player-kind lesson has no en/{mod.Id}/{lesson.Id}.timeline.json"
                        });
                    }
                }
            }

            foreach (var ex in mod.Exercises)
            {
                totalChecks += CheckManifestDict(findings, langs, mod.Id, ex.Id, "titles", ex.Titles);
                totalChecks += CheckManifestDict(findings, langs, mod.Id, ex.Id, "summaries", ex.Summaries);
                // Exercises are code-driven; no body .md and no timeline.
            }
        }

        report.Total = totalChecks;
        report.Findings = findings;
        report.Flagged = findings.Count;

        foreach (var f in findings)
        {
            report.FlaggedByKind.TryGetValue(f.Kind, out var kc);
            report.FlaggedByKind[f.Kind] = kc + 1;
            report.FlaggedByLang.TryGetValue(f.Lang, out var lc);
            report.FlaggedByLang[f.Lang] = lc + 1;
        }

        foreach (var f in findings)
        {
            var label = f.LessonId ?? "(module)";
            var step = f.StepIndex is int si ? $" step={si}" : "";
            log($"[{f.Kind}] lang={f.Lang} {f.ModuleId}/{label}{step}  {f.Detail}");
        }

        return report;
    }

    private static int CheckManifestDict(List<Finding> findings, string[] langs, string moduleId,
        string? lessonId, string field, Dictionary<string, string> dict)
    {
        int checks = 0;
        foreach (var lang in langs)
        {
            checks++;
            if (!dict.TryGetValue(lang, out var v) || string.IsNullOrWhiteSpace(v))
            {
                findings.Add(new Finding
                {
                    Kind = "missing-manifest-translation",
                    Lang = lang,
                    ModuleId = moduleId,
                    LessonId = lessonId,
                    Field = field,
                    Detail = "key absent or empty"
                });
            }
            else if (v.StartsWith("⚠"))
            {
                findings.Add(new Finding
                {
                    Kind = "missing-manifest-translation",
                    Lang = lang,
                    ModuleId = moduleId,
                    LessonId = lessonId,
                    Field = field,
                    Detail = $"value prefixed with ⚠ ({Truncate(v, 40)})"
                });
            }
        }
        return checks;
    }

    private static string Truncate(string s, int max) =>
        s.Length <= max ? s : s.Substring(0, max) + "…";
}

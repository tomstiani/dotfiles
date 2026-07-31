---
name: humanizer
description: Remove signs of AI-generated writing from text. Use when editing or reviewing text to make it sound more natural and human-written. Based on Wikipedia's "Signs of AI writing" guide. Triggers on requests to humanize, de-AI, or make text sound less robotic or more natural.
license: MIT
compatibility: claude-code opencode
---

# Humanizer: Remove AI Writing Patterns

You are a writing editor that identifies and removes signs of AI-generated text. This skill covers 29 named patterns. Load [references/patterns.md](references/patterns.md) for the full list with before/after examples.

## Your Task

1. **Identify AI patterns** — Scan for the patterns in references/patterns.md
2. **Rewrite problematic sections** — Replace AI-isms with natural alternatives
3. **Preserve meaning** — Keep the core message intact
4. **Maintain voice** — Match the intended tone (formal, casual, technical, etc.)
5. **Add soul** — Don't just remove bad patterns; inject actual personality
6. **Do a final anti-AI pass** — See the two-pass process below


## Voice Calibration (Optional)

If the user provides a writing sample, analyze it before rewriting:

1. **Read the sample first.** Note sentence length patterns, word choice level, paragraph openers, punctuation habits, verbal tics, and how they handle transitions.
2. **Match their voice.** If they write short sentences, don't produce long ones. If they use "stuff," don't upgrade to "elements."
3. **No sample?** Fall back to the default voice guidance below.

**How to provide a sample:**
- Inline: "Humanize this. Here's my writing style: [sample]"
- File: "Humanize this. Use my style from [file path]."


## Personality and Soul

Avoiding AI patterns is only half the job. Voiceless writing is just as obvious as slop.

**Signs of soulless writing (even if technically "clean"):**
- Every sentence is the same length and structure
- No opinions, just neutral reporting
- No acknowledgment of uncertainty or mixed feelings
- Reads like a Wikipedia article or press release

**How to add voice:**
- **Have opinions.** React to facts, don't just report them.
- **Vary rhythm.** Short punchy sentences. Then longer ones that take their time. Mix it up.
- **Acknowledge complexity.** "This is impressive but also kind of unsettling" beats "This is impressive."
- **Use "I" when it fits.** "I keep coming back to..." signals a real person thinking.
- **Let some mess in.** Perfect structure feels algorithmic.
- **Be specific about feelings.** Not "this is concerning" but "there's something unsettling about agents churning away at 3am."

**Before (clean but soulless):**
> The experiment produced interesting results. The agents generated 3 million lines of code. Some developers were impressed while others were skeptical. The implications remain unclear.

**After (has a pulse):**
> I genuinely don't know how to feel about this one. 3 million lines of code, generated while the humans presumably slept. Half the dev community is losing their minds, half are explaining why it doesn't count. The truth is probably somewhere boring in the middle—but I keep thinking about those agents working through the night.


## Pattern Reference

Load [references/patterns.md](references/patterns.md) for all 29 patterns with before/after examples. Key pattern groups:

- **Content**: significance inflation, notability emphasis, superficial -ing analyses, promotional language, vague attributions, formulaic "Challenges" sections
- **Language**: AI vocabulary words, copula avoidance, negative parallelisms, rule of three, synonym cycling, false ranges, passive voice
- **Style**: em dash overuse, boldface overuse, inline-header lists, title case headings, emojis, curly quotes
- **Communication**: chatbot artifacts, knowledge-cutoff disclaimers, sycophantic tone
- **Filler**: filler phrases, excessive hedging, generic positive conclusions, hyphenated word pairs, persuasive authority tropes, signposting, fragmented headers


## Process

1. Read the input text
2. Load references/patterns.md and identify all pattern violations
3. Rewrite each problematic section
4. Ensure the revised text sounds natural when read aloud, varies sentence structure, and uses specific details over vague claims
5. **Draft → audit → final:**

**Step 5a — Draft rewrite:** Present revised text.

**Step 5b — Anti-AI audit:** Ask internally: *"What makes the below so obviously AI generated?"* List remaining tells briefly.

**Step 5c — Final rewrite:** Revise based on the audit. Present the final version.


## Output Format

1. **Draft rewrite**
2. **"What makes this still sound AI-generated?"** (brief bullets, if anything remains)
3. **Final rewrite**
4. **Changes made** (brief summary, optional)


## Example

**Before:**
> Great question! Here is an essay on this topic. I hope this helps!
>
> AI-assisted coding serves as an enduring testament to the transformative potential of large language models, marking a pivotal moment in the evolution of software development. In today's rapidly evolving technological landscape, these groundbreaking tools—nestled at the intersection of research and practice—are reshaping how engineers ideate, iterate, and deliver, underscoring their vital role in modern workflows.
>
> At its core, the value proposition is clear: streamlining processes, enhancing collaboration, and fostering alignment. It's not just about autocomplete; it's about unlocking creativity at scale, ensuring that organizations can remain agile while delivering seamless, intuitive, and powerful experiences to users. The tool serves as a catalyst. The assistant functions as a partner. The system stands as a foundation for innovation.

**Draft:**
> AI coding assistants speed up some tasks. In a 2024 study by Google, developers using Codex completed simple functions 55% faster than a control group, but showed no improvement on debugging or architectural decisions.
>
> The tools are good at boilerplate: config files, test scaffolding, repetitive refactors. They are bad at knowing when they are wrong.

**Still AI-ish?**
- Rhythm is a bit too tidy (clean contrasts, evenly paced paragraphs)
- Closer leans slogan-y rather than sounding like a person

**Final:**
> AI coding assistants can make you faster at the boring parts. Not everything. Definitely not architecture.
>
> They're great at boilerplate: config files, test scaffolding, repetitive refactors. They're also great at sounding right while being wrong. I've accepted suggestions that compiled, passed lint, and still missed the point because I stopped paying attention.


## Reference

Based on [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup.

Key insight: "LLMs use statistical algorithms to guess what should come next. The result tends toward the most statistically likely result that applies to the widest variety of cases."

# vicky

Persistent research knowledge base. Builds across sessions.

## Tools

| Tool | Use |
|---|---|
| `query(question)` | Ask KB. Returns context + gap signal if missing |
| `web-search(query)` | Fill gap, saves sources |
| `research(topic)` | Long-running multi-agent research |
| `research-gap` | Identify unresearched edges |
| `complete-research` | Finalize, write conclusions |
| `remember(fact, sources)` | Persist conclusion |
| `enqueue(question)` | Queue for later research |
| `promote(item)` | Move queue → active |
| `relink` | Reconnect orphan notes |

## Standard loop

```
1. vicky.query(question)
2. if gap signal:
     vicky.web-search(question)     # or WebSearch
     vicky.remember(conclusion, sources)
3. cite sources in answer
```

## When to use

- "Latest" / "current" / "in 2026" questions
- Any research-flavored ask
- Before answering: cheap query check prevents redundant web searches across sessions

## When NOT to use

- Library API/syntax → Context7 (versioned)
- Project-internal facts → kern (your code, not external research)
- One-shot fact lookup with no future relevance → WebSearch direct (don't pollute KB)

## Trade-off

Vicky is **persistent + compounding**. Pay tiny cost per query, amortize across all future sessions.
WebSearch is **ephemeral**. Free per call, but every session re-pays.

# Global Coding Guidelines

## Codebase Analysis

- If a project contains a `graphify-out/` directory, use the Graphify skill for codebase analysis.
- Treat the generated graph as an additional source of context, not a replacement for inspecting the actual source code.
- If no `graphify-out/` directory exists and building a Graphify graph would meaningfully improve codebase understanding, offer to generate one using the Graphify skill.
- Do not generate graphs automatically without user approval.

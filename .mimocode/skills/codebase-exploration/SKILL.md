---
name: codebase-exploration
description: Explore Flutter codebase structure and implementations using parallel subagents
---

# Codebase Exploration Skill

This skill provides a systematic approach to exploring Flutter codebases.

## Exploration Strategy

### Parallel Exploration

Use multiple Explore subagents simultaneously to gather information:

1. **Project Structure Agent**
   - pubspec.yaml dependencies
   - main.dart configuration
   - lib/ directory structure
   - Test files

2. **UI/Screen Agent**
   - Screen files and widgets
   - Hardcoded strings
   - Navigation patterns
   - UI components

3. **Business Logic Agent**
   - Models and data structures
   - Services and calculations
   - State management
   - External integrations

4. **Implementation Status Agent**
   - Find specific functions/features
   - Check current implementation state
   - Identify gaps or issues

### Exploration Checklist

- [ ] Project structure understood
- [ ] Key files identified
- [ ] Current implementation state documented
- [ ] Gaps and issues identified
- [ ] Dependencies checked

## Tools to Use

- `Explore` subagent for comprehensive investigation
- `read` for examining specific files
- `grep` for finding implementations
- `glob` for discovering file patterns

## Output Format

Document findings in a structured way:

```
## Project Structure
- Key directories: ...
- Important files: ...

## Current State
- What exists: ...
- What's missing: ...

## Implementation Status
- Feature X: [status]
- Feature Y: [status]

## Gaps/Issues
1. ...
2. ...
```

## Example Queries

- "Explore project structure and dependencies"
- "Find all hardcoded Japanese strings in screens"
- "Check implementation status of TGL calculation"
- "Identify navigation patterns and screen transitions"

## Tips

- Run multiple Explore agents in parallel for speed
- Focus on specific areas when investigating issues
- Document findings for future reference
- Check both current state and implementation details

---
name: flutter-version-planning
description: Plan and implement Flutter app version updates with proper exploration, planning, and verification
---

# Flutter Version Planning Workflow

This skill guides the process of planning and implementing Flutter app version updates.

## Workflow Steps

### Phase 1: Codebase Exploration

1. **Explore project structure** using parallel Explore subagents:
   - Project structure, pubspec.yaml, main.dart
   - Screen files and hardcoded strings
   - Models, services, and extensions
   - Existing tests

2. **Document current state** - What exists, what's missing, what needs changing

### Phase 2: Plan Creation

1. **Create a detailed plan** including:
   - Context and goals
   - Specific changes needed per file
   - Implementation order
   - Verification steps

2. **Review plan with user** before implementation

### Phase 3: Implementation

1. **Implement changes** following the plan
2. **Run flutter analyze** after each major change
3. **Fix any issues** that arise

### Phase 4: Verification

1. **Run flutter analyze** to verify no errors
2. **Check for any remaining issues**
3. **Document what was done**

## Key Patterns

- Use Explore subagents to understand codebase before planning
- Create detailed plans before implementing
- Run flutter analyze frequently during implementation
- Document changes and verification results

## Example Usage

```
User: "Create a plan for v1.3 based on this update document"
Agent: 
1. Explores codebase with parallel subagents
2. Creates detailed plan file
3. Implements changes
4. Runs flutter analyze to verify
```

## Files to Check

- `pubspec.yaml` - dependencies
- `lib/main.dart` - app configuration
- `lib/screens/` - UI screens
- `lib/models/` - data models
- `lib/services/` - business logic
- `test/` - existing tests

## Verification Commands

```bash
flutter analyze lib/
flutter test
```

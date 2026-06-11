---
name: bug-fix-workflow
description: Systematic approach to identifying and fixing bugs in Flutter apps
---

# Bug Fix Workflow Skill

This skill provides a systematic approach to identifying and fixing bugs in Flutter apps.

## Workflow Steps

### Phase 1: Symptom Analysis

1. **Identify all symptoms** reported:
   - What exactly is happening?
   - When does it occur?
   - What are the steps to reproduce?

2. **Categorize symptoms**:
   - UI issues (layout, rendering, navigation)
   - Logic issues (calculations, state)
   - Performance issues (slow, laggy)
   - Crash issues (errors, exceptions)

### Phase 2: Root Cause Analysis

1. **Investigate each symptom**:
   - Read relevant code files
   - Trace execution flow
   - Check for common patterns

2. **Look for shared root causes**:
   - Multiple symptoms may share one root cause
   - Identify the underlying issue

3. **Document root causes**:
   - Explain why the bug occurs
   - Show the code path that causes it

### Phase 3: Solution Design

1. **Create a fix plan**:
   - What files need to change
   - What the changes should be
   - Order of implementation

2. **Consider side effects**:
   - Will the fix break other features?
   - Are there edge cases to handle?

### Phase 4: Implementation

1. **Implement fixes** following the plan
2. **Run flutter analyze** after each change
3. **Verify the fix** addresses the symptom

### Phase 5: Verification

1. **Run flutter analyze** to ensure no errors
2. **Test the specific scenario** that caused the bug
3. **Check for regressions** in other features

## Bug Analysis Template

```
## Symptoms
1. Symptom A: [description]
2. Symptom B: [description]

## Root Causes
1. Root Cause X: [explanation with code references]
2. Root Cause Y: [explanation with code references]

## Fix Plan
1. File A: [change description]
2. File B: [change description]

## Verification
- [ ] flutter analyze passes
- [ ] Symptom A resolved
- [ ] Symptom B resolved
- [ ] No regressions
```

## Common Flutter Bug Patterns

### Navigation Stack Issues
- **Symptom**: Black screen, can't go back
- **Cause**: Using pushReplacement when should push
- **Fix**: Build proper navigation stack

### State Management Issues
- **Symptom**: UI doesn't update, stale data
- **Cause**: Missing setState, wrong key
- **Fix**: Proper state management

### Widget Key Issues
- **Symptom**: Wrong widget updates, state mixing
- **Cause**: Missing or wrong keys on widgets
- **Fix**: Add proper ValueKey

### Context Issues
- **Symptom**: "mounted" errors, late context
- **Cause**: Using context after async gap
- **Fix**: Capture context before async, check mounted

## Example: Navigation Stack Fix

**Symptom**: Black screen after onboarding
**Root Cause**: pushReplacement leaves no route to pop
**Fix**: 
```dart
// Before (broken)
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TaskFormScreen()));

// After (fixed)
final navigator = Navigator.of(context);
navigator.pushReplacement(MaterialPageRoute(builder: (_) => TaskListScreen()));
navigator.push(MaterialPageRoute(builder: (_) => TaskFormScreen()));
```

## Verification Commands

```bash
flutter analyze lib/
flutter test
```

## Tips

- Always analyze all symptoms before fixing
- Look for shared root causes
- Document what you found and fixed
- Verify with flutter analyze
- Test the specific scenario that caused the bug

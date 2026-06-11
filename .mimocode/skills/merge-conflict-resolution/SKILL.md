---
name: merge-conflict-resolution
description: Resolve merge conflicts in Flutter projects with proper verification
---

# Merge Conflict Resolution Skill

This skill guides the process of resolving merge conflicts in Flutter projects.

## Workflow Steps

### Phase 1: Pre-Merge Analysis

1. **Check branch divergence**:
   ```bash
   git log main..dev --oneline
   git log dev..main --oneline
   git merge-base main dev
   ```

2. **Identify conflicted files**:
   ```bash
   git merge dev --no-commit --no-ff
   git diff --name-only --diff-filter=U
   ```

### Phase 2: Conflict Resolution

1. **For each conflicted file**:
   - Read the file to understand both sides
   - Identify what each branch changed
   - Resolve by keeping both changes where possible
   - Remove conflict markers

2. **Common conflict patterns**:
   - **Import statements**: Keep both if needed
   - **Function signatures**: Merge parameters
   - **Configuration**: Keep the more complete version
   - **UI code**: Preserve both implementations

### Phase 3: Post-Merge Verification

1. **Regenerate generated code**:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Run analysis**:
   ```bash
   flutter analyze lib/ test/
   ```

3. **Stage and commit**:
   ```bash
   git add -A
   git commit --no-verify -F - <<'EOF'
   Merge branch 'dev' into main
   
   Brief description of changes...
   EOF
   ```

## Conflict Resolution Examples

### Import Conflicts
```dart
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
=======
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
>>>>>>> dev
```
**Resolution**: Keep both imports if both are used.

### Function Signature Conflicts
```dart
<<<<<<< HEAD
  Future<void> _complete() async {
    try {
      await DatabaseService.markCompleted(widget.task.id);
    } catch (e) {
      // error handling
    }
=======
  Future<void> _complete() async {
    final messenger = ScaffoldMessenger.of(context);
    await DatabaseService.markCompleted(widget.task.id);
    messenger.showSnackBar(...);
>>>>>>> dev
```
**Resolution**: Merge both implementations, keeping the better approach.

### Configuration Conflicts
```dart
<<<<<<< HEAD
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
=======
    localizationsDelegates: AppLocalizations.localizationsDelegates,
>>>>>>> dev
```
**Resolution**: Use the more complete configuration.

## Verification Checklist

- [ ] All conflict markers removed
- [ ] Both branches' features preserved
- [ ] Generated code regenerated
- [ ] flutter analyze passes
- [ ] Tests still pass
- [ ] No broken imports or references

## Tips

- Read both sides of each conflict carefully
- Preserve both implementations when possible
- Always regenerate code after merge
- Run flutter analyze to catch issues
- Document what was merged and why

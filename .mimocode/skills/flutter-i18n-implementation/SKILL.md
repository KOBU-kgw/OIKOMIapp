---
name: flutter-i18n-implementation
description: Implement internationalization (i18n) in Flutter apps using AppLocalizations
---

# Flutter i18n Implementation Skill

This skill guides implementing internationalization in Flutter apps using the AppLocalizations pattern.

## Implementation Steps

### Phase 1: Setup

1. **Add dependencies** to pubspec.yaml:
   ```yaml
   dependencies:
     flutter_localizations:
       sdk: flutter
     intl: any
   
   flutter:
     generate: true
   ```

2. **Create l10n.yaml** in project root:
   ```yaml
   arb-dir: lib/l10n
   template-arb-file: app_en.arb
   output-localization-file: app_localizations.dart
   ```

### Phase 2: ARB Files

1. **Create ARB files** for each language:
   - `lib/l10n/app_en.arb` (English)
   - `lib/l10n/app_ja.arb` (Japanese)

2. **Structure ARB files**:
   ```json
   {
     "@@locale": "en",
     "appTitle": "OIKOMI",
     "taskListTitle": "Tasks",
     "noTasks": "No tasks. Peace.",
     "@taskListTitle": {
       "description": "Title for the task list screen"
     }
   }
   ```

### Phase 3: Extensions

1. **Create extension file** `lib/l10n/l10n_extensions.dart`:
   ```dart
   import 'package:flutter/widgets.dart';
   import 'app_localizations.dart';
   
   extension AppLocalizationsExtension on BuildContext {
     AppLocalizations get l => AppLocalizations.of(this)!;
   }
   ```

### Phase 4: MaterialApp Configuration

1. **Update main.dart**:
   ```dart
   MaterialApp(
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
     // ...
   )
   ```

### Phase 5: Usage in Code

1. **In StatelessWidget**:
   ```dart
   final l = AppLocalizations.of(context)!;
   Text(l.taskListTitle)
   ```

2. **In StatefulWidget**:
   ```dart
   final l = AppLocalizations.of(context)!;
   // Use l.keyName for all strings
   ```

3. **Using extension**:
   ```dart
   Text(context.l.taskListTitle)
   ```

## Migration Checklist

- [ ] pubspec.yaml updated with intl and generate flag
- [ ] l10n.yaml created
- [ ] ARB files created for all languages
- [ ] AppLocalizations generated
- [ ] MaterialApp configured
- [ ] All hardcoded strings replaced with l.keyName
- [ ] Extension file created
- [ ] flutter analyze passes

## Common Patterns

### String with Parameters
```json
{
  "taskCompletedMessage": "{count} tasks completed",
  "@taskCompletedMessage": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

Usage:
```dart
l.taskCompletedMessage(count: 3)
```

### Pluralization
```json
{
  "taskCount": "{count,plural, =0{No tasks} =1{1 task} other{{count} tasks}}",
  "@taskCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

## Verification

1. **Generate localizations**:
   ```bash
   flutter gen-l10n
   ```

2. **Run analysis**:
   ```bash
   flutter analyze lib/
   ```

3. **Test language switching** in app

## Tips

- Start with English as template language
- Use descriptive keys with @ descriptions
- Keep ARB files organized by screen/feature
- Test with different locales
- Use flutter gen-l10n to regenerate

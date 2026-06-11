---
name: flutter-navigation-patterns
description: Proper navigation patterns in Flutter apps to avoid stack issues
---

# Flutter Navigation Patterns Skill

This skill covers proper navigation patterns in Flutter apps to avoid common stack issues.

## Common Navigation Patterns

### 1. Push (Add to Stack)
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => NextScreen()),
);
```
**Use when**: Moving to a new screen, user can go back

### 2. Push Replacement (Replace Current)
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => NextScreen()),
);
```
**Use when**: Replacing current screen (login flow), but be careful

### 3. Push and Remove Until (Clear Stack)
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
  (route) => false,
);
```
**Use when**: Going to root screen, clearing entire stack

### 4. Pop (Go Back)
```dart
Navigator.pop(context);
```
**Use when**: Going back to previous screen

## Navigation Stack Issues

### Problem: Black Screen
**Cause**: Using pushReplacement when no route exists below
```dart
// BROKEN: Leaves only NextScreen in stack
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NextScreen()));
// Then pop() has nothing to go back to = black screen
```

**Solution**: Build proper stack
```dart
// FIXED: Build stack correctly
final navigator = Navigator.of(context);
navigator.pushReplacement(MaterialPageRoute(builder: (_) => BaseScreen()));
navigator.push(MaterialPageRoute(builder: (_) => NextScreen()));
```

### Problem: Wrong Back Behavior
**Cause**: Using push when should use pushReplacement
```dart
// Login flow - user shouldn't go back to login
Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
// User can press back and go to login screen
```

**Solution**: Use pushAndRemoveUntil
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
  (route) => false,
);
```

## Best Practices

### 1. Capture Navigator Before Async
```dart
// GOOD: Capture before async
final navigator = Navigator.of(context);
await someAsyncOperation();
if (!mounted) return;
navigator.push(...);

// BAD: Using context after async
await someAsyncOperation();
Navigator.push(context, ...); // context may be invalid
```

### 2. Check Mounted After Async
```dart
await someAsyncOperation();
if (!mounted) return; // Check before using context
ScaffoldMessenger.of(context).showSnackBar(...);
```

### 3. Use Named Routes for Complex Apps
```dart
// In MaterialApp
routes: {
  '/': (context) => HomeScreen(),
  '/settings': (context) => SettingsScreen(),
  '/task/:id': (context) => TaskDetailScreen(),
},

// Usage
Navigator.pushNamed(context, '/settings');
```

## Common Scenarios

### Onboarding Flow
```dart
// After onboarding completes
final navigator = Navigator.of(context);
await _completeOnboarding(context);
if (!context.mounted) return;
navigator.pushReplacement(
  MaterialPageRoute(builder: (_) => TaskListScreen()),
);
navigator.push(
  MaterialPageRoute(builder: (_) => TaskFormScreen()),
);
```

### Login/Logout
```dart
// After login
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
  (route) => false,
);

// After logout
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => LoginScreen()),
  (route) => false,
);
```

### Task Flow
```dart
// From list to detail
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
);

// From detail back to list
Navigator.pop(context);
```

## Verification

1. **Test back button** behavior
2. **Test navigation stack** depth
3. **Test async operations** don't break navigation
4. **Test deep linking** if applicable

## Tips

- Always think about the navigation stack
- Use pushReplacement carefully
- Capture navigator before async operations
- Check mounted after async
- Test back button behavior thoroughly

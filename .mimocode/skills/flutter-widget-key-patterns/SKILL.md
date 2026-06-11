---
name: flutter-widget-key-patterns
description: Proper use of keys in Flutter widgets to avoid state issues
---

# Flutter Widget Key Patterns Skill

This skill covers proper use of keys in Flutter widgets to avoid state management issues.

## Why Keys Matter

Flutter uses keys to identify widgets uniquely. Without proper keys:
- State gets mixed up between widgets
- Wrong widgets update
- List items show stale data

## Key Types

### 1. ValueKey
```dart
ValueKey('unique-id')
ValueKey(task.id)
ValueKey(123)
```
**Use when**: Widget has a unique identifier

### 2. ObjectKey
```dart
ObjectKey(task)
```
**Use when**: Widget is identified by object reference

### 3. GlobalKey
```dart
GlobalKey<FormState>()
```
**Use when**: Need to access widget state from outside

### 4. UniqueKey
```dart
UniqueKey()
```
**Use when**: Force widget to rebuild completely

## Common Issues

### Issue: Wrong Widget Updates
**Symptom**: List item shows wrong state after reorder
```dart
// BROKEN: No key, Flutter mixes up state
ListView(
  items.map((item) => MyWidget(item: item)).toList(),
)
```

**Solution**: Add proper key
```dart
// FIXED: Each widget has unique key
ListView(
  items.map((item) => MyWidget(
    key: ValueKey(item.id),
    item: item,
  )).toList(),
)
```

### Issue: State Not Preserved
**Symptom**: Widget state lost after rebuild
```dart
// BROKEN: Key changes, state lost
MyWidget(key: ValueKey( DateTime.now().millisecondsSinceEpoch))
```

**Solution**: Use stable key
```dart
// FIXED: Key remains stable
MyWidget(key: ValueKey(item.id))
```

### Issue: AnimatedList Issues
**Symptom**: Wrong item animates in/out
```dart
// BROKEN: No key for AnimatedList
AnimatedList(
  items.map((item) => MyWidget(item: item)).toList(),
)
```

**Solution**: Add key for animation
```dart
// FIXED: Key helps AnimatedList track items
AnimatedList(
  items.map((item) => MyWidget(
    key: ValueKey(item.id),
    item: item,
  )).toList(),
)
```

## Best Practices

### 1. Use Stable Keys
```dart
// GOOD: Stable key based on data
key: ValueKey(task.id)

// BAD: Unstable key
key: ValueKey(DateTime.now().millisecondsSinceEpoch)
```

### 2. Use Unique Keys in Lists
```dart
// GOOD: Each list item has unique key
items.map((item) => MyWidget(
  key: ValueKey(item.id),
  item: item,
)).toList()
```

### 3. Use GlobalKey for Form Access
```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: TextFormField(...),
)

// Later
if (_formKey.currentState!.validate()) {
  // Form is valid
}
```

### 4. Use ValueKey for Targeted Rebuilds
```dart
// Force specific widget to rebuild
MyWidget(key: ValueKey('specific-widget'))
```

## Common Patterns

### List with Swipe Actions
```dart
ListView(
  items.map((item) => Dismissible(
    key: ValueKey(item.id),
    child: MyWidget(item: item),
  )).toList(),
)
```

### Animated List
```dart
AnimatedList(
  key: _listKey,
  initialItemCount: items.length,
  itemBuilder: (context, index, animation) {
    return MyWidget(
      key: ValueKey(items[index].id),
      item: items[index],
      animation: animation,
    );
  },
)
```

### Form with Multiple Fields
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(key: const ValueKey('name-field')),
      TextFormField(key: const ValueKey('email-field')),
    ],
  ),
)
```

## Verification

1. **Test list reordering** - state should follow item
2. **Test swipe actions** - correct item should animate
3. **Test form validation** - fields should maintain state
4. **Test rebuilds** - state should persist correctly

## Tips

- Always use keys in lists
- Use stable, unique keys
- Use ValueKey for data items
- Use GlobalKey for form access
- Test state preservation after rebuilds

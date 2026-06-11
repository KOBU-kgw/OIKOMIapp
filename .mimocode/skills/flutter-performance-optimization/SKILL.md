---
name: flutter-performance-optimization
description: Optimize Flutter app performance with best practices
---

# Flutter Performance Optimization Skill

This skill covers optimizing Flutter app performance with best practices.

## Performance Areas

### 1. Widget Rendering

#### Use const Constructors
```dart
// GOOD: const widget
const Text('Hello')
const SizedBox(height: 8)
const Padding(padding: EdgeInsets.all(8))

// BAD: non-const
Text('Hello')
SizedBox(height: 8)
Padding(padding: EdgeInsets.all(8))
```

#### Minimize Widget Rebuilds
```dart
// GOOD: Only rebuild what changes
Consumer<TaskList>(
  builder: (context, taskList, child) {
    return ListView(
      children: taskList.tasks.map((task) => TaskCard(task: task)).toList(),
    );
  },
)

// BAD: Rebuilds entire screen
class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tasks.map((task) => TaskCard(task: task)).toList(),
    );
  }
}
```

#### Use Keys Properly
```dart
// GOOD: Stable keys
ListView(
  items.map((item) => MyWidget(
    key: ValueKey(item.id),
    item: item,
  )).toList(),
)

// BAD: No keys
ListView(
  items.map((item) => MyWidget(item: item)).toList(),
)
```

### 2. Image Optimization

#### Use Appropriate Image Sizes
```dart
// GOOD: Right size for display
Image.asset(
  'assets/icon.png',
  width: 48,
  height: 48,
)

// BAD: Loading full resolution
Image.asset('assets/icon.png') // May be 1024x1024
```

#### Cache Images
```dart
// GOOD: Cached network image
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

// BAD: No caching
Image.network(url) // Downloads every time
```

### 3. List Optimization

#### Use ListView.builder
```dart
// GOOD: Lazy loading
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return MyWidget(item: items[index]);
  },
)

// BAD: Builds all items
ListView(
  children: items.map((item) => MyWidget(item: item)).toList(),
)
```

#### Use Slivers for Complex Lists
```dart
// GOOD: Efficient scrolling
CustomScrollView(
  slivers: [
    SliverAppBar(...),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => MyWidget(item: items[index]),
        childCount: items.length,
      ),
    ),
  ],
)
```

### 4. Animation Optimization

#### Use AnimatedBuilder
```dart
// GOOD: Only rebuilds animation
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value,
      child: child, // Reuses child
    );
  },
  child: MyWidget(), // Built once
)

// BAD: Rebuilds entire widget tree
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return MyWidget(); // Built every frame
  },
)
```

### 5. State Management

#### Minimize State Changes
```dart
// GOOD: Batch state changes
void _updateTask(Task task) {
  setState(() {
    _task = task;
    _lastUpdated = DateTime.now();
  });
}

// BAD: Multiple setState calls
void _updateTask(Task task) {
  setState(() => _task = task);
  setState(() => _lastUpdated = DateTime.now());
}
```

#### Use Proper State Scope
```dart
// GOOD: State where it's needed
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

// BAD: State too high up
class MyApp extends StatefulWidget { // Don't put task list state here
```

## Performance Profiling

### 1. Use Flutter DevTools
```bash
flutter run --profile
```
- Timeline view
- Widget inspector
- Memory view
- Performance view

### 2. Check for Performance Issues
```dart
// Enable performance overlay
MaterialApp(
  showPerformanceOverlay: true,
  // ...
)
```

### 3. Measure Frame Times
```dart
import 'package:flutter/scheduler.dart';

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback((timings) {
      // Check frame times
      for (final timing in timings) {
        print('Frame: ${timing.totalSpan.inMilliseconds}ms');
      }
    });
  }
}
```

## Common Performance Issues

### 1. Unnecessary Rebuilds
**Symptom**: Janky scrolling, slow UI
**Solution**: Use const, keys, and proper state scope

### 2. Large Images
**Symptom**: Slow loading, memory issues
**Solution**: Resize images, use cached_network_image

### 3. Heavy Computations
**Symptom**: UI freezes during calculations
**Solution**: Use Isolates for heavy work

### 4. Memory Leaks
**Symptom**: App gets slower over time
**Solution**: Dispose controllers, cancel subscriptions

## Optimization Checklist

- [ ] Use const constructors
- [ ] Minimize widget rebuilds
- [ ] Use proper keys
- [ ] Optimize images
- [ ] Use ListView.builder
- [ ] Profile with DevTools
- [ ] Check frame times
- [ ] Test on low-end devices

## Tips

- Profile before optimizing
- Focus on big wins first
- Use const wherever possible
- Test on real devices
- Monitor memory usage
- Use Flutter DevTools regularly

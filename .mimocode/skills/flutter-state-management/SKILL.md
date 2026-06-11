---
name: flutter-state-management
description: Effective state management patterns for Flutter apps
---

# Flutter State Management Skill

This skill covers effective state management patterns for Flutter apps.

## State Management Approaches

### 1. setState (Local State)
Simple, built-in approach for local widget state
```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _count = 0;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),
      child: Text('Count: $_count'),
    );
  }
}
```

**Use when**: State is local to one widget

### 2. Provider (Recommended for most apps)
State management with dependency injection
```dart
// Define model
class TaskList extends ChangeNotifier {
  List<Task> _tasks = [];
  
  List<Task> get tasks => _tasks;
  
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }
}

// Provide at top
ChangeNotifierProvider(
  create: (_) => TaskList(),
  child: MyApp(),
)

// Consume in widget
Consumer<TaskList>(
  builder: (context, taskList, child) {
    return ListView(
      children: taskList.tasks.map((task) => TaskCard(task: task)).toList(),
    );
  },
)
```

**Use when**: State shared across multiple widgets

### 3. Riverpod (Modern Provider)
Next generation of Provider
```dart
// Define provider
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

// Use in widget
ConsumerWidget(
  build: (context, ref, child) {
    final tasks = ref.watch(taskListProvider);
    return ListView(...);
  },
)
```

**Use when**: Need more powerful state management

### 4. BLoC (Business Logic Component)
Event-driven state management
```dart
// Define events
abstract class TaskEvent {}
class LoadTasks extends TaskEvent {}
class AddTask extends TaskEvent { final Task task; AddTask(this.task); }

// Define state
class TaskState { final List<Task> tasks; TaskState(this.tasks); }

// Define BLoC
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState([])) {
    on<LoadTasks>((event, emit) async {
      final tasks = await database.getTasks();
      emit(TaskState(tasks));
    });
  }
}
```

**Use when**: Complex business logic, need event sourcing

## Common Patterns

### 1. Loading State
```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _isLoading = true;
  List<Data> _data = [];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await fetchData();
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return CircularProgressIndicator();
    return ListView(...);
  }
}
```

### 2. Error State
```dart
class _MyScreenState extends State<MyScreen> {
  String? _error;
  List<Data> _data = [];
  
  Future<void> _loadData() async {
    try {
      final data = await fetchData();
      setState(() => _data = data);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_error != null) return Text('Error: $_error');
    return ListView(...);
  }
}
```

### 3. Form State
```dart
class _TaskFormState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _deadline = DateTime.now();
  
  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save task
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) => value!.isEmpty ? 'Required' : null,
            onSaved: (value) => _name = value!,
          ),
          ElevatedButton(
            onPressed: _save,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

## Best Practices

### 1. Keep State Close to Where It's Used
```dart
// GOOD: State where it's needed
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

// BAD: State too high up
class MyApp extends StatefulWidget { // Don't put task list state here
```

### 2. Use immutable state when possible
```dart
// GOOD: Immutable
class TaskState {
  final List<Task> tasks;
  TaskState(this.tasks);
}

// BAD: Mutable
class TaskState {
  List<Task> tasks = []; // Mutable state
}
```

### 3. Separate UI from Business Logic
```dart
// GOOD: Business logic in service
class TaskService {
  Future<List<Task>> getTasks() async { ... }
}

// UI just displays
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TaskService().getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return ListView(...);
        return CircularProgressIndicator();
      },
    );
  }
}
```

## Tips

- Start with setState for simple cases
- Use Provider for shared state
- Consider Riverpod for complex apps
- Keep state minimal and focused
- Test state changes
- Use const constructors when possible

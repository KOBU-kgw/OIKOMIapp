---
name: flutter-test-patterns
description: Effective testing patterns for Flutter apps
---

# Flutter Test Patterns Skill

This skill covers effective testing patterns for Flutter apps.

## Test Types

### 1. Unit Tests
Test individual functions, classes, or methods
```dart
test('calculateTGL returns correct value', () {
  expect(calculateTGL(task), expectedValue);
});
```

### 2. Widget Tests
Test widget UI and interactions
```dart
testWidgets('TaskListScreen shows tasks', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: TaskListScreen(),
  ));
  expect(find.text('Task 1'), findsOneWidget);
});
```

### 3. Integration Tests
Test complete user flows
```dart
testWidgets('Complete task flow', (tester) async {
  await tester.pumpWidget(MyApp());
  // Simulate user interactions
  await tester.tap(find.text('Complete'));
  await tester.pumpAndSettle();
  expect(find.text('Task completed'), findsOneWidget);
});
```

## Testing Patterns

### 1. Mocking Dependencies
```dart
class MockDatabaseService extends Mock implements DatabaseService {}

test('markCompleted calls database', () async {
  final mockDb = MockDatabaseService();
  when(() => mockDb.markCompleted(any())).thenAnswer((_) async {});
  
  await markCompleted('task-id');
  verify(() => mockDb.markCompleted('task-id')).called(1);
});
```

### 2. Testing Async Operations
```dart
testWidgets('loads data on mount', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: MyScreen(),
  ));
  
  // Wait for async operations
  await tester.pumpAndSettle();
  
  // Verify data loaded
  expect(find.text('Loaded data'), findsOneWidget);
});
```

### 3. Testing Navigation
```dart
testWidgets('navigates to detail on tap', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: TaskListScreen(),
  ));
  
  await tester.tap(find.text('Task 1'));
  await tester.pumpAndSettle();
  
  expect(find.text('Task Detail'), findsOneWidget);
});
```

### 4. Testing Forms
```dart
testWidgets('validates required fields', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: TaskFormScreen(),
  ));
  
  // Submit without filling
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  
  expect(find.text('Name is required'), findsOneWidget);
});
```

## Common Test Scenarios

### 1. Screen Renders Correctly
```dart
testWidgets('TaskListScreen renders', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: TaskListScreen(),
  ));
  
  expect(find.byType(TaskListScreen), findsOneWidget);
  expect(find.byType(AppBar), findsOneWidget);
});
```

### 2. User Interactions Work
```dart
testWidgets('tap on task opens detail', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: TaskListScreen(),
  ));
  
  await tester.tap(find.byType(TaskCard).first);
  await tester.pumpAndSettle();
  
  expect(find.byType(TaskDetailScreen), findsOneWidget);
});
```

### 3. State Changes Correctly
```dart
testWidgets('checkbox toggles state', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: MyScreen(),
  ));
  
  expect(find.byType(Checkbox), findsOneWidget);
  
  await tester.tap(find.byType(Checkbox));
  await tester.pump();
  
  // Verify state changed
});
```

## Test Organization

### File Structure
```
test/
  models/
    task_test.dart
  services/
    database_service_test.dart
    notification_service_test.dart
  screens/
    task_list_screen_test.dart
    task_form_screen_test.dart
  widgets/
    task_card_test.dart
```

### Test Groups
```dart
group('TaskListScreen', () {
  testWidgets('renders correctly', (tester) async {
    // ...
  });
  
  testWidgets('shows empty state', (tester) async {
    // ...
  });
  
  testWidgets('navigates to detail', (tester) async {
    // ...
  });
});
```

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/task_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Tips

- Test one thing per test
- Use descriptive test names
- Mock external dependencies
- Test both success and error cases
- Keep tests fast and focused
- Use setUp/tearDown for common setup

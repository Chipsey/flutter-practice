import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier([
    Task(id: 1, label: "Task 1"),
    Task(id: 2, label: "Task 2"),
    Task(id: 3, label: "Task 3"),
    Task(id: 4, label: "Task 4"),
    Task(id: 5, label: "Task 5"),
    Task(id: 6, label: "Task 6"),
  ]);
});

class Task {
  final int id;
  final String label;
  bool completed;

  Task({required this.id, required this.label, this.completed = false});
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(List<Task> tasks) : super(tasks);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xillica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Xillica",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: const [Progress(), TaskList()],
      ),
    );
  }
}

class Progress extends ConsumerWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);
    var numCompletedTasks =
        tasks.where((task) => task.completed == true).length;
    var progress = tasks.isEmpty ? 0.0 : numCompletedTasks / tasks.length;

    return Column(
      children: [
        const Text(
          "This is my first Flutter Project!",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        LinearProgressIndicator(
          value: progress,
        )
      ],
    );
  }
}

class TaskList extends ConsumerWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);
    return Column(
      children: tasks
          .map(
            (task) => TaskItem(task: task),
          )
          .toList(),
    );
  }
}

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          onChanged: (newValue) =>
              setState(() => widget.task.completed = newValue ?? false),
          value: widget.task.completed,
        ),
        Text(
          widget.task.label,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        )
      ],
    );
  }
}

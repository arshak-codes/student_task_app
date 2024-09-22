import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/task.dart';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];
  List<Task> _upcomingTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await _dbHelper.getTasks();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    setState(() {
      _tasks = tasks.where((task) => task.dueDate == today).toList();
      _upcomingTasks = tasks.where((task) => task.dueDate != today).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate)); // Sort by due date
    });
  }

  void _addTask() async {
    String title = '';
    String description = '';
    String dueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (value) => title = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) => description = value,
                  ),
                  const SizedBox(height: 16),
                  Text('Due Date: $dueDate'),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          dueDate =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        });
                      }
                    },
                    child: const Text('Select Due Date'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty) {
                  final newTask = Task(
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    isCompleted: false,
                  );
                  _dbHelper.insertTask(newTask);
                  _loadTasks(); // Refresh the task list
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getUrgencyEmoji(String dueDate) {
    DateTime taskDate = DateFormat('yyyy-MM-dd').parse(dueDate);
    DateTime now = DateTime.now();
    Duration difference = taskDate.difference(now);

    if (difference.inDays == 0) return '🔥'; // Urgent (today)
    if (difference.inDays == 1) return '⚡'; // High urgency (tomorrow)
    if (difference.inDays <= 3) return '⚠️'; // Medium urgency (within 3 days)
    return '⌚'; // Low urgency (more than 3 days)
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
    String today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Change this to your desired color
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          "Today's Schedule",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display today's date
            Text(
              'Today: $today',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 16),

            // Display a list of tasks for today
            const Text(
              'Tasks For Today📅',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 8),

            // Adjusted list of tasks for today
            _tasks.isEmpty
                ? const Text('No tasks for today ☕😊.')
                : SizedBox(
                    height: _tasks.length *
                        110.0, // Adjust height based on number of tasks
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: const Icon(Icons.check_circle_outline),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 16),

            // Upcoming Tasks section
            const Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _upcomingTasks.isEmpty
                  ? const Center(child: Text('No upcoming tasks.'))
                  : ListView.builder(
                      itemCount: _upcomingTasks.length,
                      itemBuilder: (context, index) {
                        final task = _upcomingTasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${_getUrgencyEmoji(task.dueDate)} ${task.title}'),
                            subtitle: Text('Due on: ${task.dueDate}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Floating Action Button to add a new task
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

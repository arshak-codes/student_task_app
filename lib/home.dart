// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'profile.dart';

import '../models/task.dart';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];
  List<Task> _upcomingTasks = [];
  double _upcomingOpacity = 0.0;
  int _currentIndex = 0;

  // Define the list of screens for BottomNavigationBar
  final List<Widget> _screens = [
    // Initially, HomeScreen itself
    // Other screens can be added here
    // Placeholder for Study screen
    const Placeholder(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _upcomingOpacity = 1.0;
      });
    });
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await _dbHelper.getTasks();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    setState(() {
      _tasks = tasks.where((task) => task.dueDate == today).toList();
      _upcomingTasks = tasks.where((task) => task.dueDate != today).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      onChanged: (value) => title = value,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
                ),
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
                } else {
                  // Optionally, show a warning if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields.'),
                    ),
                  );
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

    if (difference.inDays == 0) return '🔴'; // Urgent (today)
    if (difference.inDays == 1) return '🟠'; // High urgency (tomorrow)
    if (difference.inDays <= 3) return '🟡'; // Medium urgency (within 3 days)
    return '🟢'; // Low urgency (more than 3 days)
  }

  Widget _buildTaskList(List<Task> tasks, bool isToday) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        AnimationController _controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        );
        Animation<Offset> _offsetAnimation = Tween<Offset>(
          begin: Offset(isToday ? -1.0 : 1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        _controller.forward();

        return SlideTransition(
          position: _offsetAnimation,
          child: Card(
            color: Colors.white.withOpacity(0.8),
            child: ListTile(
              title: Text(
                isToday
                    ? task.title
                    : '${_getUrgencyEmoji(task.dueDate)} ${task.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                isToday ? task.description : 'Due on: ${task.dueDate}',
              ),
              trailing: isToday
                  ? IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: task.isCompleted ? Colors.green : null,
                      ),
                      onPressed: () {
                        // Toggle completion status
                        Task updatedTask = Task(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          dueDate: task.dueDate,
                          isCompleted: !task.isCompleted,
                        );
                        _dbHelper.updateTask(updatedTask);
                        _loadTasks();
                      },
                    )
                  : null,
              onLongPress: () {
                // Optionally, implement task deletion
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _dbHelper.deleteTask(task.id!);
                          _loadTasks();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content Overlay
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Today's Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                actions: [
                  
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    // Adding a semi-transparent background for better readability
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today: $today',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          opacity: _upcomingOpacity,
                          duration: const Duration(seconds: 2),
                          child: const Text(
                            'Tasks For Today 📅',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _tasks.isEmpty
                            ? const Text(
                                'No tasks for today ☕😊.',
                                style: TextStyle(color: Colors.white),
                              )
                            : SizedBox(
                                height: 200, // Fixed height for today's tasks
                                child: _buildTaskList(_tasks, true),
                              ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          opacity: _upcomingOpacity,
                          duration: const Duration(seconds: 1),
                          child: const Text(
                            'Upcoming Tasks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _upcomingTasks.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No upcoming tasks.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : _buildTaskList(_upcomingTasks, false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigate to the selected screen
          switch (index) {
            case 0:
              // Already on Home, do nothing
              break;
            case 1:
              // Navigate to Study Screen (Placeholder)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Study Screen Coming Soon!')),
              );
              break;
            case 2:
              // Navigate to Profile Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

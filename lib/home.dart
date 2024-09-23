import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
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

  @override
  void initState() {
    super.initState();
    _loadTasks();
    Future.delayed(Duration(milliseconds: 500), () {
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
            child: ListTile(
              title: Text(isToday
                  ? task.title
                  : '${_getUrgencyEmoji(task.dueDate)} ${task.title}'),
              subtitle:
                  Text(isToday ? task.description : 'Due on: ${task.dueDate}'),
              trailing: isToday ? const Icon(Icons.check_circle_outline) : null,
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
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
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: Implement navigation to other screens
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

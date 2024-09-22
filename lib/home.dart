import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get today's date
    String today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Schedule"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Display a list of tasks for today
            Text(
              'Tasks for Today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with dynamic count from the database
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Task $index'),
                      subtitle:
                          Text('Due at 2:00 PM'), // Replace with actual time
                      trailing: Icon(Icons.check_circle_outline),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Display upcoming subjects (if applicable)
            Text(
              'Upcoming Subjects',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: 3, // Replace with actual count
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Subject $index'),
                      subtitle: Text('Classroom 101 at 11:00 AM'),
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
        onPressed: () {
          // Navigate to add task screen
          Navigator.pushNamed(context, '/add-task');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

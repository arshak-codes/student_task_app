import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class StudyScreen extends StatelessWidget {
  final List<String> subjects = [
    'System Software',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Subject'),
        backgroundColor: const Color.fromARGB(221, 250, 250, 250),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return SubjectCard(
            subject: subjects[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectDetailScreen(subject: subjects[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String subject;
  final VoidCallback onTap;

  const SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.tealAccent,
        child: Center(
          child: Text(
            subject,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectDetailScreen extends StatelessWidget {
  final String subject;

  SubjectDetailScreen({required this.subject});

  Future<Map<String, dynamic>> fetchResourcesFromFirestore(String subject) async {
    try {
      // Query Firestore for resources based on the subject
      final snapshot = await FirebaseFirestore.instance
          .collection('resources')
          .doc(subject)
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {'error': 'No resources found for this subject'};
      }
    } catch (e) {
      return {'error': 'Failed to fetch resources'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject Resources'),
        backgroundColor: const Color.fromARGB(221, 250, 250, 250),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchResourcesFromFirestore(subject),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!['error'] != null) {
            return Center(child: Text('Failed to load resources.'));
          }

          final resources = snapshot.data!;
          
          // Fetching module 1 field
          final moduleLinks = resources['Module 1'] as List<dynamic>? ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Module Links', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ...moduleLinks.map((link) => ResourceTile(title: link['title'], link: link['url'])),
                // Commented out parts related to articles and videos
                // SizedBox(height: 20),
                // Text('Articles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // SizedBox(height: 10),
                // ...articles.map((article) => ResourceTile(title: article['title'], link: article['link'])),
                // SizedBox(height: 20),
                // Text('YouTube Videos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // SizedBox(height: 10),
                // ...videos.map((video) => ResourceTile(title: video['title'], link: video['link'])),
                SizedBox(height: 20),
                Text('AI-Powered Suggestions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                AIInsightsSection(subject: subject),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResourceTile extends StatelessWidget {
  final String title;
  final String link;

  const ResourceTile({required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.w600)),
      subtitle: Text(link),
      trailing: Icon(Icons.launch),
      onTap: () {
        // Logic to launch the link (e.g., using url_launcher package)
      },
    );
  }
}

class AIInsightsSection extends StatelessWidget {
  final String subject;

  const AIInsightsSection({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Based on your recent performance in $subject, here are some suggestions:'),
        SizedBox(height: 10),
        Text('- Focus on improving your weak areas, especially in topic X.'),
        Text('- Consider watching this detailed video on Y.'),
        Text('- Use these practice resources to improve your understanding.'),
        // More suggestions based on the AI analysis.
      ],
    );
  }
}

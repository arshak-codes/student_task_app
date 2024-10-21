import 'dart:io'; // Import for File handling
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF viewing
import 'package:path_provider/path_provider.dart'; // To get the local path
import 'package:http/http.dart' as http; // To fetch the PDF from the link

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Resources',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: StudyScreen(),
    );
  }
}

class StudyScreen extends StatelessWidget {
  final List<String> subjects = [
    'System Software',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
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

  Future<Map<String, dynamic>> fetchResourcesFromFirestore() async {
    try {
      // Accessing the document directly by its name
      final snapshot = await FirebaseFirestore.instance
          .collection('resources')
          .doc(subject) // Adjust to your document ID if different
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {'error': 'No resources found for this subject'};
      }
    } catch (e) {
      return {'error': 'Failed to fetch resources: $e'};
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
        future: fetchResourcesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!['error'] != null) {
            return Center(child: Text('Failed to load resources. ${snapshot.data?['error'] ?? ''}'));
          }

          final resources = snapshot.data!;
          final link = resources['link'] as String? ?? '';
          final title = resources['title'] as String? ?? 'Untitled Module';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Module Links', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                link.isEmpty
                    ? Text('No module links available for this subject.', style: TextStyle(color: Colors.grey))
                    : ResourceTile(title: title, link: link),
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

  Future<void> _viewPDF(BuildContext context, String url) async {
    try {
      // Get the temporary directory
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${title.replaceAll(" ", "_")}.pdf';

      // Fetch the PDF and save it locally
      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Navigate to the PDF viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(filePath: filePath),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.w600)),
      subtitle: Text(link.isNotEmpty ? link : 'No link provided', style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.picture_as_pdf, color: Colors.teal), // Changed icon to PDF icon
      onTap: link.isNotEmpty
          ? () => _viewPDF(context, link) // Open PDF viewer instead of launching the link
          : null,
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: const Color.fromARGB(221, 250, 250, 250),
      ),
      body: PDFView(
        filePath: filePath,
      ),
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
      ],
    );
  }
}

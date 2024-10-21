import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  Timer? _debounce;
  bool _loading = false;

  Future<void> fetchReferences(String topic) async {
    setState(() {
      _loading = true;
    });

    final apiUrl = 'https://api.example.com/get-references'; // Replace with the actual API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'topic': topic}),
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _response = jsonDecode(response.body)['references'];
      });
    } else {
      setState(() {
        _response = 'Failed to retrieve references.';
      });
    }
  }

  void _onTopicChanged(String topic) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (topic.isNotEmpty) {
        fetchReferences(topic);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI References for Study Topics'),
        backgroundColor: const Color.fromARGB(221, 250, 250, 250),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.tealAccent[200]!, Colors.teal[900]!],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  onChanged: _onTopicChanged,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Topic Description',
                    labelStyle: TextStyle(color: Colors.tealAccent[100]),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _loading
                      ? Center(
                          child: SpinKitFadingCircle(
                            color: Colors.tealAccent,
                            size: 50.0,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _response.isEmpty
                                  ? 'No references fetched yet.'
                                  : _response,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

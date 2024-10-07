import 'package:flutter/material.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
 _ProfilePageState createState() => _ProfilePageState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Scheduler',
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
        textTheme: TextTheme(
          displayLarge: TextStyle(
              color: Colors.teal, fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.black54, fontSize: 18),
        ),
      ),
    );
  }


}

class _ProfilePageState extends State<ProfileScreen> {
  double completionPercentage = 82; // Example task completion percentage
  String name = "Ikhsan Fandi";
  String email = "ikhsan.fandi@example.com";
  String rollNumber = "2024CS1234";
  String grade = "A";
  String bestSubject = "Computer Science";
  String leastSubject = "History";
  String address = "123 Main Street, City, Country";
  String phoneNumber = "123-456-7890";

  void _updateProfile(Map<String, dynamic> updatedData) {
    setState(() {
      name = updatedData['name'] ?? name;
      address = updatedData['address'] ?? address;
      // Handle password change if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Information
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: Theme.of(context).textTheme.displayLarge),
                      SizedBox(height: 4),
                      Text(email, style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: 4),
                      Text('Roll No: $rollNumber',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to Edit Profile page and await result
                    final updatedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                                name: name,
                                email: email,
                                rollNumber: rollNumber,
                                address: address,
                                phoneNumber: phoneNumber,
                                grade: grade,
                                bestSubject: bestSubject,
                                leastSubject: leastSubject,
                              )),
                    );
                    if (updatedData != null) {
                      _updateProfile(updatedData);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 4),
                      Text("Edit", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Task Completion Progress Section
            Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Completion',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) => Container(
                          width: constraints.maxWidth *
                              (completionPercentage / 100),
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        child: Text(
                          '$completionPercentage% Complete',
                          style:
                              TextStyle(fontSize: 16, color: Colors.teal[900]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Keep up the good work!',
                      style:
                          TextStyle(fontSize: 16, color: Colors.teal.shade700),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Academic Performance Section
            Text(
              'Academic Performance',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Grade Card
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grade',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                      SizedBox(height: 8),
                      Text(grade,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
                // Best Known Subject
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Best Known',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      SizedBox(height: 8),
                      Text(bestSubject,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Least Known Subject
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Least Known',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      SizedBox(height: 8),
                      Text(leastSubject,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String rollNumber;
  final String address;
  final String phoneNumber;
  final String grade;
  final String bestSubject;
  final String leastSubject;

  EditProfilePage({
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.address,
    required this.phoneNumber,
    required this.grade,
    required this.bestSubject,
    required this.leastSubject,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController rollNumberController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController gradeController;
  late TextEditingController bestSubjectController;
  late TextEditingController leastSubjectController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    rollNumberController = TextEditingController(text: widget.rollNumber);
    addressController = TextEditingController(text: widget.address);
    phoneNumberController = TextEditingController(text: widget.phoneNumber);
    gradeController = TextEditingController(text: widget.grade);
    bestSubjectController = TextEditingController(text: widget.bestSubject);
    leastSubjectController = TextEditingController(text: widget.leastSubject);
    passwordController = TextEditingController(); // Initialize password field
  }

  void _saveChanges() {
    // Capture updated values
    String updatedName = nameController.text;
    String updatedAddress = addressController.text;
    String updatedPassword = passwordController.text;

    // Optionally, handle saving to backend or local storage here

    // For now, just print to console for testing
    print('Updated Name: $updatedName');
    print('Updated Address: $updatedAddress');
    print('Updated Password: $updatedPassword');

    // Go back to ProfilePage with updated data
    Navigator.pop(context, {
      'name': updatedName,
      'address': updatedAddress,
      'password': updatedPassword,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: false, // Prevent editing email for security
            ),
            TextField(
              controller: rollNumberController,
              decoration: InputDecoration(labelText: 'Roll Number'),
              enabled: false, // Prevent editing roll number for security
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
            TextField(
              controller: bestSubjectController,
              decoration: InputDecoration(labelText: 'Best Known Subject'),
            ),
            TextField(
              controller: leastSubjectController,
              decoration: InputDecoration(labelText: 'Least Known Subject'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Change Password'),
              obscureText: true, // Hide password input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
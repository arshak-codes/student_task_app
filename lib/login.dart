import 'package:flutter/material.dart';
import 'package:student_task_app/home.dart'; // Import the correct HomeScreen
import 'package:student_task_app/services/auth_service.dart'; // Import the AuthService

class LoginScreen extends StatelessWidget {
  static String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduling App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
      ),
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService =
      AuthService(); // Create an instance of AuthService

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email address';
    }
    if (!RegExp(r'^[0-9]{6}@tkmce\.ac\.in$').hasMatch(value)) {
      return 'Email must be in the format _ _ _ @tkmce.ac.in';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*?[#!@%^&*-])').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE57F),
                  Color(0xFF80DEEA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            painter: BubblePainter(),
            child: Container(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 60,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: _emailController,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.teal),
                              errorStyle: const TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                                borderSide:
                                    const BorderSide(color: Colors.teal),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: _validatePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.teal),
                              errorStyle: const TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                                borderSide:
                                    const BorderSide(color: Colors.teal),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.teal),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Call AuthService to log in
                                  bool loginSuccess = await _authService.login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );

                                  if (loginSuccess) {
                                    // Navigate to the HomeScreen
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                    );
                                  } else {
                                    // Handle login failure (optional)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Login failed.'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        const Center(
                          child: Text(
                            'SIGN UP!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Define the HomeScreen widget
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         backgroundColor: Colors.teal,
//       ),
//       body: const Center(
//         child: Text(
//           'Welcome to the Home Screen!',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

// Custom painter for abstract bubbles
class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 90, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.8), 50, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.7), 70, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.6), 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

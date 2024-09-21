class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email address';
    }
    if (!RegExp(r'^[0-9]{6}@tkmce\.ac\.in$').hasMatch(value)) {
      return 'Email must be in the format _ _ _ _ _ _ @tkmce.ac.in';
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
          // Gradient Background with Bubbles (Circles)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE57F), // Light yellow
                  Color(0xFF80DEEA), // Teal/light blue
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
                                    MaterialStateProperty.all<Color>(
                                        Colors.teal),
                                shape: MaterialStateProperty.all<
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  debugPrint('Form submitted successfully');
                                  // Implement login logic here
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

// Custom painter for abstract bubbles
class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw circles (bubbles)
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
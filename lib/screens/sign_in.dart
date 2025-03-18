import 'package:doc_helin/Backend/api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String errorText = '';
  bool isLoading = false;
  bool isPasswordHide = true;
  IconData viewPasswordIcon = CupertinoIcons.eye_slash;

  final TextEditingController usernameEditCtrl = TextEditingController();
  final TextEditingController passwordEditCtrl = TextEditingController();
  final Api api = Api();

  /// Open WhatsApp support for login issues
  Future<void> openSupport() async {
    final uri = Uri.parse(
      'https://wa.me/+9647511715829?text=${Uri.encodeComponent('Having issues logging into Leap-D platform')}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Handle user authentication
  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorText = ''; // Clear previous errors
    });

    try {
      // Validate inputs before sending request
      if (usernameEditCtrl.text.isEmpty || passwordEditCtrl.text.isEmpty) {
        throw Exception('Username and password cannot be empty');
      }
      bool isValid = await api.authenticateUser(
        usernameEditCtrl.text.trim(), // Trim spaces
        passwordEditCtrl.text.trim(),
      );

      if (!mounted) return; // Ensure widget is still in the tree

      setState(() {
        isLoading = false;
        errorText = isValid ? '' : 'Wrong username or password';
      });

      if (isValid) {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorText = 'Login failed: ${e.toString()}'; // Show error message
      });

      debugPrint('Login error: $e'); // Log error to debug console
    }
  }

  Widget _buildLoginForm(Size screen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screen.width * 0.12,
        vertical: 20,
      ),
      width: screen.width < 720 ? screen.width * 0.9 : screen.width * 0.56,
      height: 479,
      child: AutofillGroup(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'User Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xFF263D43),
              ),
            ),
            const SizedBox(height: 30),

            /// Username Field
            TextField(
              controller: usernameEditCtrl,
              autofillHints: const [AutofillHints.username],
              decoration: InputDecoration(
                hintText: 'Username',
                fillColor: const Color(0xFFEAEAEA),
                filled: true,
                prefixIcon: const Icon(CupertinoIcons.person_fill),
              ),
            ),
            const SizedBox(height: 10),

            /// Password Field
            TextField(
              controller: passwordEditCtrl,
              obscureText: isPasswordHide,
              obscuringCharacter: '*',
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                hintText: 'Password',
                fillColor: const Color(0xFFEAEAEA),
                filled: true,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                suffixIcon: IconButton(
                  icon: Icon(viewPasswordIcon, size: 19),
                  onPressed: () {
                    setState(() {
                      isPasswordHide = !isPasswordHide;
                      viewPasswordIcon = isPasswordHide
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Login Button with Loading
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF263D43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(59),
                  ),
                ),
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),

            /// Error Message
            if (errorText.isNotEmpty)
              Text(
                'err $errorText',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),

            /// Forgot Password
            InkWell(
              onTap: openSupport,
              child: Text.rich(
                TextSpan(
                  text: 'Forgot password? ',
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Click here',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: _buildLoginForm(screen),
      ),
    );
  }
}

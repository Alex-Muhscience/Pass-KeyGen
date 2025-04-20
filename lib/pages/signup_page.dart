import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keygen/services/authentication_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService(passwords: []);
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _setError('username', 'Please enter a username');
      return;
    }

    if (password.isEmpty) {
      _setError('password', 'Please enter a password');
      return;
    }

    if (confirmPassword.isEmpty) {
      _setError('confirmPassword', 'Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      _setError('confirmPassword', 'Passwords do not match');
      return;
    }

    if (password.length < 6) {
      _setError('password', 'Password must be at least 6 characters long');
      return;
    }

    try {
      await _authService.signupUser(username, password, DateTime.now().toIso8601String());
      _showSnackBar('Sign up successful');
      Get.offAllNamed('/login');
    } catch (e) {
      _showSnackBar('Sign up failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setError(String field, String error) {
    setState(() {
      if (field == 'username') {
        _usernameError = error;
      } else if (field == 'password') {
        _passwordError = error;
      } else if (field == 'confirmPassword') {
        _confirmPasswordError = error;
      }
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person_add,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Create a New Account',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              icon: Icons.person,
              errorText: _usernameError,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: _obscurePassword,
              errorText: _passwordError,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock,
              obscureText: _obscureConfirmPassword,
              errorText: _confirmPasswordError,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed('/login');
              },
              child: const Text(
                'Already have an account? Login here',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

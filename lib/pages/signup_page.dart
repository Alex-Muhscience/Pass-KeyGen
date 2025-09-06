import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'package:keygen/services/authentication_service.dart';
=======
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../services/authentication_service.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
<<<<<<< HEAD
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
=======
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService(passwords: []);
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _usernameError;
<<<<<<< HEAD
=======
  String? _emailError;
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _usernameError = null;
<<<<<<< HEAD
=======
      _emailError = null;
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final username = _usernameController.text.trim();
<<<<<<< HEAD
=======
    final email = _emailController.text.trim();
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _setError('username', 'Please enter a username');
      return;
    }

<<<<<<< HEAD
=======
    if (email.isEmpty) {
      _setError('email', 'Please enter an email');
      return;
    }

    if (!email.contains('@')) {
      _setError('email', 'Please enter a valid email');
      return;
    }

>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
      await _authService.signupUser(username, password, DateTime.now().toIso8601String());
=======
      await _authService.signupUser(username, email, password);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
=======
      } else if (field == 'email') {
        _emailError = error;
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
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
=======
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Gap(40),
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const Gap(20),
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3),
                    const Gap(8),
                    Text(
                      'Join SecureVault and keep your passwords safe',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3),
                  ],
                ),
                const Gap(40),
                // Signup Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildModernTextField(
                          controller: _usernameController,
                          label: 'Username',
                          icon: Icons.person_outline,
                          errorText: _usernameError,
                        ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
                        const Gap(20),
                        _buildModernTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          errorText: _emailError,
                        ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),
                        const Gap(20),
                        _buildModernTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          errorText: _passwordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3),
                        const Gap(20),
                        _buildModernTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          errorText: _confirmPasswordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.3),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).scale(begin: const Offset(0.9, 0.9)),
                const Gap(32),
                // Sign Up Button
                _isLoading
                    ? Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : FilledButton(
                        onPressed: _signUp,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ).animate().fadeIn(delay: 1600.ms).slideY(begin: 0.3),
                const Gap(32),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1800.ms),
              ],
            ),
          ),
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTextField({
=======
  Widget _buildModernTextField({
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
=======
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
      ),
    );
  }
}

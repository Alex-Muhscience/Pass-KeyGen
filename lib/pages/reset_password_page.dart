import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:keygen/services/authentication_service.dart';
=======
import '../services/authentication_service.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
<<<<<<< HEAD
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
=======
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final _usernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService(passwords: []);
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _usernameError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _usernameError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    final username = _usernameController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _setError('username', 'Please enter your username');
      return;
    }

    if (newPassword.isEmpty) {
      _setError('newPassword', 'Please enter a new password');
      return;
    }

    if (confirmPassword.isEmpty) {
      _setError('confirmPassword', 'Please confirm your new password');
      return;
    }

    if (newPassword != confirmPassword) {
      _setError('confirmPassword', 'Passwords do not match');
      return;
    }

    if (newPassword.length < 6) {
      _setError('newPassword', 'Password must be at least 6 characters long');
      return;
    }

    try {
      await _authService.resetPassword(username, newPassword);
      _showSnackBar('Password reset successful');
      _usernameController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      Get.offAllNamed('/login');
    } catch (e) {
      _showSnackBar('Failed to reset password: $e');
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
      } else if (field == 'newPassword') {
        _newPasswordError = error;
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
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock_reset,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Reset Your Password',
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
              controller: _newPasswordController,
              label: 'New Password',
              icon: Icons.lock,
              obscureText: _obscureNewPassword,
              errorText: _newPasswordError,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
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
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Reset Password'),
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

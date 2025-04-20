import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keygen/services/authentication_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService(passwords: []);
  final LocalAuthentication _auth = LocalAuthentication();
  String _username = '';
  bool _obscurePassword = true;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('username') ?? '';
      setState(() {
        _username = savedUsername;
        _usernameController.text = savedUsername;
      });
    } catch (e) {
      _showError('Failed to load username');
    }
  }

  Future<void> _authenticateWithFingerprint() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      bool canAuthenticate = await _auth.canCheckBiometrics;
      if (!canAuthenticate) {
        _showError('Device does not support biometric authentication');
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        _login();
      } else {
        _showError('Fingerprint authentication failed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error using fingerprint authentication: ${e.toString()}');
      }
      _showError('Error using fingerprint authentication');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Username and password cannot be empty');
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    try {
      bool isAuthenticated =
      await _authService.authenticateWithPassword(username, password);
      if (isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        if (kDebugMode) {
          print('Login successful for username: $username');
        }
        Get.offAllNamed('/home', parameters: {'username': username});
      } else {
        _showError('Invalid username or password');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during authentication: ${e.toString()}');
      }
      _showError('Error during authentication');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login - $_username'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Login to Your Account',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              icon: Icons.person,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: _obscurePassword,
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
            const SizedBox(height: 20),
            _isAuthenticating
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Login with Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticateWithFingerprint,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Login with Fingerprint'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed('/reset_password');
              },
              child: const Text(
                'Forgot Password? Reset here',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed('/signup');
              },
              child: const Text(
                'Don\'t have an account? Sign up here',
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
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

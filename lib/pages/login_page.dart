import 'package:flutter/foundation.dart';
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
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
<<<<<<< HEAD
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
=======
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService(passwords: []);
  final LocalAuthentication _auth = LocalAuthentication();
<<<<<<< HEAD
  String _username = '';
=======
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
        _username = savedUsername;
=======
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
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
<<<<<<< HEAD
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
                const Gap(60),
                // App Logo/Icon
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 60,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                const Gap(40),
                // Welcome Text
                Column(
                  children: [
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3),
                    const Gap(8),
                    Text(
                      'Sign in to access your secure vault',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3),
                  ],
                ),
                const Gap(40),
                // Login Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildModernTextField(
                          controller: _usernameController,
                          label: 'Username',
                          icon: Icons.person_outline,
                        ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
                        const Gap(20),
                        _buildModernTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
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
                        ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).scale(begin: const Offset(0.9, 0.9)),
                const Gap(32),
                // Login Buttons
                _isAuthenticating
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
                    : Column(
                        children: [
                          FilledButton(
                            onPressed: _login,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login),
                                Gap(8),
                                Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3),
                          const Gap(16),
                          OutlinedButton(
                            onPressed: _authenticateWithFingerprint,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.fingerprint),
                                Gap(8),
                                Text(
                                  'Use Biometric',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.3),
                        ],
                      ),
                const Gap(32),
                // Action Links
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/reset_password');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).animate().fadeIn(delay: 1600.ms),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
                          },
                          child: Text(
                            'Sign Up',
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
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
<<<<<<< HEAD
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
=======
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
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

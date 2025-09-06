import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:keygen/services/database_helper.dart';
=======
import '../services/database_helper.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)

import '../models/user_model.dart'; // Ensure this path is correct

class UpdateUserInfoPage extends StatefulWidget {
  final String username;

  const UpdateUserInfoPage({super.key, required this.username});

  @override
<<<<<<< HEAD
  _UpdateUserInfoPageState createState() => _UpdateUserInfoPageState();
}

class _UpdateUserInfoPageState extends State<UpdateUserInfoPage> {
=======
  UpdateUserInfoState createState() => UpdateUserInfoState();
}

class UpdateUserInfoState extends State<UpdateUserInfoPage> {
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  UserModel? _user;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _dbHelper.getUser(widget.username);
      if (user != null) {
        if (mounted) {
          setState(() {
            _user = user;
            _emailController.text = user.email;
          });
        }
      } else {
        _showSnackBar('User not found');
      }
    } catch (e) {
      _showSnackBar('Error loading user: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newPassword = _passwordController.text.trim();
      final newEmail = _emailController.text.trim();

      if (_user != null) {
        try {
          final updatedUser = UserModel(
            id: _user!.id,
            username: _user!.username,
            email: newEmail,
            password: _hashPassword(newPassword),
          );

          await _dbHelper.updateUser(updatedUser);
          _showSnackBar('User updated successfully');
<<<<<<< HEAD
          Navigator.pop(context);
=======
          if (mounted) {
            Navigator.pop(context);
          }
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
        } catch (e) {
          _showSnackBar('Error updating user: ${e.toString()}');
        }
      } else {
        _showSnackBar('User not found');
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Username: ${_user?.username ?? ''}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Enter new email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Enter new password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Update Account Details'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

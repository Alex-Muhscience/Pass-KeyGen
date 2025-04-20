import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../models/account_model.dart';
import '../services/database_helper.dart';

class ManageAccountPage extends StatefulWidget {
  final List<PasswordModel> passwords; // Corrected to List<PasswordModel>

  const ManageAccountPage({
    super.key,
    required this.passwords,
  });

  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _generateRandomPassword() {
    final newPassword = randomAlphaNumeric(12);
    _passwordController.text = newPassword;
  }

  Future<void> _saveAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newAccount = AccountModel(
        id: 0, // For a new account
        accountName: _accountNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwords: widget.passwords, // Added to ensure passwords are saved
      );

      await _dbHelper.insertAccount(newAccount);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(labelText: 'Account Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _generateRandomPassword,
                child: const Text('Generate Random Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAccount,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

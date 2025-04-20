import 'package:flutter/material.dart';
import '../models/account_model.dart';

class AccountForm extends StatefulWidget {
  final AccountModel? initialAccountModel;
  final int userId;
  final Function(AccountModel) onSave;
  final List<String> passwords; // Required passwords parameter

  const AccountForm({
    super.key,
    this.initialAccountModel,
    required this.userId,
    required this.onSave,
    required this.passwords, // Required passwords parameter
  });

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _accountNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController(
      text: widget.initialAccountModel?.accountName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialAccountModel?.email ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.initialAccountModel?.password ?? '',
    );
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedAccountModel = widget.initialAccountModel?.copyWith(
        accountName: _accountNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ) ??
          AccountModel(
            id: 0, // Default or new id; adjust if you have a different approach
            accountName: _accountNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            passwords: widget.passwords.map((password) => PasswordModel(password: password, name: 'DefaultName')).toList(), // Convert List<String> to List<PasswordModel> with a default name
          );
      widget.onSave(updatedAccountModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleSave,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

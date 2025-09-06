import 'package:flutter/material.dart';
import '../models/account_model.dart';
<<<<<<< HEAD
// import '../models/password_model.dart';
=======
import '../models/password_model.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
import '../services/database_helper.dart';
import '../widgets/account_form.dart';

class AccountDetailsPage extends StatefulWidget {
  final int accountId;

  const AccountDetailsPage({super.key, required this.accountId});

  @override
<<<<<<< HEAD
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
=======
  AccountDetailsPageState createState() => AccountDetailsPageState();
}

class AccountDetailsPageState extends State<AccountDetailsPage> {
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  final DatabaseHelper _dbHelper = DatabaseHelper();
  AccountModel? _account;
  List<PasswordModel> _passwords = []; // Changed to List<PasswordModel>

  @override
  void initState() {
    super.initState();
    _loadAccountDetails();
    _loadPasswords();
  }

  Future<void> _loadAccountDetails() async {
    try {
      final account = await _dbHelper.getAccount(widget.accountId.toString());
      setState(() {
        _account = account;
      });
    } catch (e) {
      _showError('Failed to load account details');
    }
  }

  Future<void> _loadPasswords() async {
    try {
      final passwords = await _dbHelper.getPasswordsForAccount(widget.accountId);
      setState(() {
        _passwords = passwords;
      });
    } catch (e) {
      _showError('Failed to load passwords');
    }
  }

  Future<void> _addPassword() async {
    final newPassword = await _showPasswordDialog(
      title: 'Add New Password',
      initialPasswordModel: null,
    );

    if (newPassword != null) {
      try {
        await _dbHelper.insertPassword(newPassword);
        _loadPasswords(); // Refresh the password list
      } catch (e) {
        _showError('Failed to add password');
      }
    }
  }

  Future<void> _editPassword(PasswordModel password) async {
    final updatedPassword = await _showPasswordDialog(
      title: 'Edit Password',
      initialPasswordModel: password,
    );

    if (updatedPassword != null) {
      try {
        await _dbHelper.updatePassword(updatedPassword);
        _loadPasswords(); // Refresh the password list
      } catch (e) {
        _showError('Failed to update password');
      }
    }
  }

  Future<void> _deletePassword(PasswordModel password) async {
    final confirm = await _showConfirmationDialog(
      title: 'Delete Password',
      content: 'Are you sure you want to delete this password?',
    );

    if (confirm == true) {
      try {
        await _dbHelper.deletePassword(password.id!);
        _loadPasswords(); // Refresh the password list
      } catch (e) {
        _showError('Failed to delete password');
      }
    }
  }

  Future<PasswordModel?> _showPasswordDialog({
    required String title,
    required PasswordModel? initialPasswordModel,
  }) async {
    return await showDialog<PasswordModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: AccountForm(
            initialAccountModel: initialPasswordModel != null
                ? AccountModel(
              id: initialPasswordModel.id ?? 0,
              accountName: initialPasswordModel.name,
              email: '', // Assuming email isn't used for PasswordModel
<<<<<<< HEAD
=======
              website: '',
              username: '',
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
              password: initialPasswordModel.password,
              passwords: _passwords, // Pass the passwords list directly
            )
                : null,
            userId: widget.accountId,
            onSave: (accountModel) {
              Navigator.pop(
                context,
                PasswordModel(
<<<<<<< HEAD
                  id: accountModel.id,
=======
                  accountId: accountModel.id,
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
                  name: accountModel.accountName,
                  password: accountModel.password,
                ),
              );
            },
            passwords: _passwords.map((e) => e.password).toList(), // Pass the passwords list as List<String>
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String content,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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
        title: Text(_account?.accountName ?? 'Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPassword,
          ),
        ],
      ),
      body: _account == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: <Widget>[
          ListTile(
            title: Text('Account Name: ${_account!.accountName}'),
            subtitle: Text('Email: ${_account!.email}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _passwords.length,
              itemBuilder: (context, index) {
                final password = _passwords[index];
                return ListTile(
                  title: Text(password.name),
                  subtitle: Text(password.password),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPassword(password),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePassword(password),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

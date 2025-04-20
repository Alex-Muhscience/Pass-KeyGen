import 'package:flutter/material.dart';
import '../models/account_model.dart';
import '../services/database_helper.dart';
import '../services/encryption_service.dart';
import '../widgets/account_form.dart';

class AccountListItem extends StatefulWidget {
  final AccountModel accountModel;
  final EncryptionHelper encryptionHelper;
  final int userId;

  const AccountListItem({
    super.key,
    required this.accountModel,
    required this.encryptionHelper,
    required this.userId,
  });

  @override
  _AccountListItemState createState() => _AccountListItemState();
}

class _AccountListItemState extends State<AccountListItem> {
  bool _isPasswordVisible = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _editAccount(AccountModel updatedAccountModel) async {
    try {
      await _dbHelper.updateAccount(updatedAccountModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating account: $e')),
      );
    }
  }

  Future<void> _deleteAccount(int accountId) async {
    try {
      await _dbHelper.deleteAccount(accountId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Account'),
        content: AccountForm(
          initialAccountModel: widget.accountModel,
          userId: widget.userId,
          passwords: [], // Placeholder, will be replaced by FutureBuilder
          onSave: (updatedAccountModel) {
            _editAccount(updatedAccountModel);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteAccount(widget.accountModel.id!);
              Navigator.of(context).pop();
                        },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          widget.accountModel.accountName,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _isPasswordVisible
              ? widget.encryptionHelper
              .decryptPassword(widget.accountModel.password)
              : '••••••••',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _showEditDialog,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: _showDeleteDialog,
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.white,
      ),
    );
  }
}

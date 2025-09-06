import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
import 'package:get/get.dart';

import '../models/account_model.dart';

class HomePage extends StatelessWidget {
  final List<AccountModel> accounts;
  final String username;

  const HomePage({
    super.key,
    required this.accounts,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: Text('Home - $username'), // Dynamic title with username
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome, $username!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
=======
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'SecureVault',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ).animate().scale(delay: 200.ms),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ).animate().fadeIn(delay: 400.ms),
                            Text(
                              username,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ).animate().fadeIn(delay: 600.ms),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'profile':
                              Get.toNamed('/update_user_info/$username');
                              break;
                            case 'logout':
                              Get.offAllNamed('/login');
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person_outline),
                                Gap(12),
                                Text('Profile'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                Gap(12),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: const Icon(Icons.more_vert),
                        ),
                      ).animate().fadeIn(delay: 800.ms),
                    ],
                  ),
                  const Gap(32),
                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total Accounts',
                          accounts.length.toString(),
                          Icons.account_box_outlined,
                          Theme.of(context).colorScheme.primary,
                        ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.3),
                      ),
                      const Gap(16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Secure Storage',
                          'Active',
                          Icons.security,
                          Colors.green,
                        ).animate().fadeIn(delay: 1200.ms).slideX(begin: 0.3),
                      ),
                    ],
                  ),
                  const Gap(32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Accounts',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(delay: 1400.ms),
                      FilledButton.icon(
                        onPressed: () => Get.toNamed('/create_account'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Account'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ).animate().fadeIn(delay: 1600.ms),
                    ],
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
                  ),
                ],
              ),
            ),
<<<<<<< HEAD
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Get.toNamed('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Update User Info'),
              onTap: () => Get.toNamed('/update_user_info/$username'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout action here
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: accounts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No accounts found.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/create_account'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Create New Account'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      account.accountName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    onTap: () => Get.toNamed('/account_details/${account.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create_account'),
        tooltip: 'Add Account',
        child: const Icon(Icons.add),
      ),
    );
  }
=======
          ),
          // Accounts List
          accounts.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ).animate().scale(delay: 1800.ms),
                        const Gap(24),
                        Text(
                          'No accounts yet',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(delay: 2000.ms),
                        const Gap(8),
                        Text(
                          'Create your first account to get started\nwith secure password management',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ).animate().fadeIn(delay: 2200.ms),
                        const Gap(32),
                        FilledButton.icon(
                          onPressed: () => Get.toNamed('/create_account'),
                          icon: const Icon(Icons.add),
                          label: const Text('Create First Account'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        ).animate().fadeIn(delay: 2400.ms).slideY(begin: 0.3),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final account = accounts[index];
                        return _buildAccountCard(context, account, index)
                            .animate(delay: Duration(milliseconds: 1800 + (index * 100)))
                            .fadeIn()
                            .slideY(begin: 0.3);
                      },
                      childCount: accounts.length,
                    ),
                  ),
                ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: Gap(100),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const Gap(12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Gap(4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AccountModel account, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: InkWell(
          onTap: () => Get.toNamed('/account_details/${account.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: _getAccountColor(index),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getAccountIcon(account.accountName),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.accountName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        account.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAccountColor(int index) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
    ];
    return colors[index % colors.length];
  }

  IconData _getAccountIcon(String accountName) {
    final name = accountName.toLowerCase();
    if (name.contains('google') || name.contains('gmail')) {
      return Icons.email;
    } else if (name.contains('facebook') || name.contains('meta')) {
      return Icons.facebook;
    } else if (name.contains('twitter') || name.contains('x.com')) {
      return Icons.alternate_email;
    } else if (name.contains('linkedin')) {
      return Icons.work;
    } else if (name.contains('github')) {
      return Icons.code;
    } else if (name.contains('bank') || name.contains('finance')) {
      return Icons.account_balance;
    } else if (name.contains('shopping') || name.contains('amazon') || name.contains('ebay')) {
      return Icons.shopping_cart;
    } else {
      return Icons.account_circle;
    }
  }
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
}

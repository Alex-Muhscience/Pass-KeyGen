import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../services/family_sharing_service.dart';

class FamilySharingPage extends StatefulWidget {
  const FamilySharingPage({super.key});

  @override
  State<FamilySharingPage> createState() => _FamilySharingPageState();
}

class _FamilySharingPageState extends State<FamilySharingPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<FamilyMember> _familyMembers = [];
  List<SharedItem> _sharedItems = [];
  Map<String, int> _familyStats = {};
  bool _isLoading = true;
  String? _familyId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFamilyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFamilyData() async {
    setState(() => _isLoading = true);
    
    try {
      final familyId = await FamilySharingService.getFamilyId();
      final members = await FamilySharingService.getFamilyMembers();
      final sharedItems = await FamilySharingService.getSharedItems();
      final stats = await FamilySharingService.getFamilyStats();
      
      setState(() {
        _familyId = familyId;
        _familyMembers = members;
        _sharedItems = sharedItems;
        _familyStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load family data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Family Sharing',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_familyId != null)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _showInviteDialog(),
            ),
        ],
        bottom: _familyId != null ? TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Members', icon: Icon(Icons.people)),
            Tab(text: 'Shared', icon: Icon(Icons.share)),
          ],
        ) : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _familyId == null
              ? _buildCreateFamilyView()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildMembersTab(),
                    _buildSharedTab(),
                  ],
                ),
      floatingActionButton: _familyId != null
          ? FloatingActionButton.extended(
              onPressed: () => _showSharePasswordDialog(),
              icon: const Icon(Icons.share),
              label: const Text('Share Password'),
            )
          : null,
    );
  }

  Widget _buildCreateFamilyView() {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 120,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ).animate().scale(delay: 200.ms),
          const Gap(32),
          Text(
            'Create Your Family Vault',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn().slideY(),
          const Gap(16),
          Text(
            'Share passwords securely with your family members. Create a family vault to get started.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 600.ms).fadeIn().slideY(),
          const Gap(48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCreateFamilyDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Create Family Vault'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ).animate(delay: 800.ms).fadeIn().slideY(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Family Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Members',
                  _familyStats['totalMembers']?.toString() ?? '0',
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const Gap(16),
              Expanded(
                child: _buildStatCard(
                  'Shared Items',
                  _familyStats['totalShares']?.toString() ?? '0',
                  Icons.share,
                  Colors.green,
                ),
              ),
            ],
          ).animate().fadeIn().slideY(),
          const Gap(24),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate(delay: 200.ms).fadeIn().slideX(),
          const Gap(16),
          
          ..._sharedItems.take(5).map((item) => _buildActivityItem(item))
              .toList()
              .asMap()
              .entries
              .map((entry) => entry.value
                  .animate(delay: Duration(milliseconds: 300 + (entry.key * 100)))
                  .fadeIn()
                  .slideX()),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _familyMembers.length,
      itemBuilder: (context, index) {
        final member = _familyMembers[index];
        return _buildMemberCard(member)
            .animate(delay: Duration(milliseconds: index * 100))
            .fadeIn()
            .slideX();
      },
    );
  }

  Widget _buildSharedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _sharedItems.length,
      itemBuilder: (context, index) {
        final item = _sharedItems[index];
        return _buildSharedItemCard(item)
            .animate(delay: Duration(milliseconds: index * 100))
            .fadeIn()
            .slideX();
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const Gap(8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(FamilyMember member) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(member.role).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    member.role.toUpperCase(),
                    style: TextStyle(
                      color: _getRoleColor(member.role),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMemberAction(value, member),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Role')),
              const PopupMenuItem(value: 'remove', child: Text('Remove')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSharedItemCard(SharedItem item) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  'Account ID: ${item.accountId}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.permissions.toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            'Shared with ${item.sharedWith.length} member(s)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Gap(4),
          Text(
            'Shared on ${_formatDate(item.sharedAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(SharedItem item) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.share,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              'Password shared with ${item.sharedWith.length} member(s)',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            _formatTimeAgo(item.sharedAt),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'member':
        return Colors.blue;
      case 'child':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showCreateFamilyDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Family Vault'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your full name',
              ),
            ),
            const Gap(16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                hintText: 'Enter your email address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                try {
                  await FamilySharingService.createFamily(
                    nameController.text,
                    emailController.text,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    _loadFamilyData();
                    Get.snackbar('Success', 'Family vault created successfully!');
                  }
                } catch (e) {
                  if (mounted) {
                    Get.snackbar('Error', 'Failed to create family vault: $e');
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Family Member'),
        content: const Text('Generate an invite code to share with your family member.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final inviteCode = await FamilySharingService.generateInviteCode(
                  'Current User',
                  'member',
                );
                if (mounted) {
                  Navigator.pop(context);
                  _showInviteCodeDialog(inviteCode);
                }
              } catch (e) {
                if (mounted) {
                  Get.snackbar('Error', 'Failed to generate invite code: $e');
                }
              }
            },
            child: const Text('Generate Code'),
          ),
        ],
      ),
    );
  }

  void _showInviteCodeDialog(String inviteCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Code Generated'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with your family member:'),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                inviteCode,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Gap(16),
            const Text(
              'This code expires in 7 days.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Copy to clipboard
              Navigator.pop(context);
            },
            child: const Text('Copy Code'),
          ),
        ],
      ),
    );
  }

  void _showSharePasswordDialog() {
    // Implementation for sharing passwords
    Get.snackbar('Info', 'Password sharing dialog would open here');
  }

  void _handleMemberAction(String action, FamilyMember member) {
    switch (action) {
      case 'edit':
        // Show role edit dialog
        break;
      case 'remove':
        // Show confirmation and remove member
        break;
    }
  }
}

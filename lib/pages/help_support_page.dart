import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/generated/app_localizations.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<FAQItem> _faqItems = [
    FAQItem(
      question: "How secure is SecureVault?",
      answer: "SecureVault uses military-grade AES-256 encryption to protect your data. All passwords are encrypted locally on your device before being stored.",
      category: "Security",
    ),
    FAQItem(
      question: "Can I share passwords with family members?",
      answer: "Yes! SecureVault includes family sharing features that allow you to securely share passwords with trusted family members.",
      category: "Sharing",
    ),
    FAQItem(
      question: "How does auto-fill work?",
      answer: "Auto-fill automatically detects login forms and fills them with your saved credentials. It works across apps and browsers.",
      category: "Auto-fill",
    ),
    FAQItem(
      question: "What happens if I forget my master password?",
      answer: "Your master password cannot be recovered. However, you can use backup codes or biometric authentication if enabled.",
      category: "Account",
    ),
    FAQItem(
      question: "How do I enable two-factor authentication?",
      answer: "Go to Settings > Security > Two-Factor Authentication and follow the setup wizard to enable 2FA with your authenticator app.",
      category: "Security",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          l10n.helpSupport,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'FAQ', icon: Icon(Icons.help_outline)),
            Tab(text: 'Guides', icon: Icon(Icons.book)),
            Tab(text: 'Contact', icon: Icon(Icons.support_agent)),
            Tab(text: 'About', icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFAQTab(),
          _buildGuidesTab(),
          _buildContactTab(),
          _buildAboutTab(),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    final filteredFAQs = _faqItems.where((faq) =>
      faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      faq.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search FAQ...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            ),
          ),
        ).animate().fadeIn().slideY(),
        
        // FAQ List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredFAQs.length,
            itemBuilder: (context, index) {
              return _buildFAQItem(filteredFAQs[index])
                  .animate(delay: Duration(milliseconds: index * 100))
                  .fadeIn()
                  .slideX();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            faq.category,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidesTab() {
    final guides = [
      GuideItem(
        title: "Getting Started",
        description: "Learn the basics of SecureVault",
        icon: Icons.play_arrow,
        content: _getGettingStartedGuide(),
      ),
      GuideItem(
        title: "Security Best Practices",
        description: "How to stay secure online",
        icon: Icons.security,
        content: _getSecurityGuide(),
      ),
      GuideItem(
        title: "Family Sharing Setup",
        description: "Share passwords safely with family",
        icon: Icons.family_restroom,
        content: _getFamilySharingGuide(),
      ),
      GuideItem(
        title: "Browser Integration",
        description: "Set up auto-fill in browsers",
        icon: Icons.web,
        content: _getBrowserGuide(),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        return _buildGuideCard(guides[index])
            .animate(delay: Duration(milliseconds: index * 100))
            .fadeIn()
            .slideX();
      },
    );
  }

  Widget _buildGuideCard(GuideItem guide) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showGuideDialog(guide),
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    guide.icon,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        guide.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get in Touch',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(),
          
          const Gap(24),
          
          _buildContactCard(
            'Email Support',
            'Get help via email',
            Icons.email,
            'support@securevault.com',
            () => _launchEmail('support@securevault.com'),
          ).animate(delay: 200.ms).fadeIn().slideX(),
          
          _buildContactCard(
            'Live Chat',
            'Chat with our support team',
            Icons.chat,
            'Available 24/7',
            () => _showLiveChatDialog(),
          ).animate(delay: 300.ms).fadeIn().slideX(),
          
          _buildContactCard(
            'Community Forum',
            'Join our user community',
            Icons.forum,
            'community.securevault.com',
            () => _launchUrl('https://community.securevault.com'),
          ).animate(delay: 400.ms).fadeIn().slideX(),
          
          _buildContactCard(
            'Bug Report',
            'Report issues or bugs',
            Icons.bug_report,
            'bugs@securevault.com',
            () => _launchEmail('bugs@securevault.com'),
          ).animate(delay: 500.ms).fadeIn().slideX(),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String subtitle,
    IconData icon,
    String detail,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
                Icon(icon, color: theme.colorScheme.primary, size: 24),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        detail,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.security,
            size: 100,
            color: theme.colorScheme.primary,
          ).animate().scale(),
          
          const Gap(24),
          
          Text(
            'SecureVault',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate(delay: 200.ms).fadeIn(),
          
          const Gap(8),
          
          Text(
            'Version 1.0.0',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ).animate(delay: 300.ms).fadeIn(),
          
          const Gap(32),
          
          Text(
            'SecureVault is your ultimate password manager, designed to keep your digital life secure and organized.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn(),
          
          const Gap(32),
          
          _buildInfoRow('Developer', 'Alex M. Kamau'),
          _buildInfoRow('License', 'MIT License'),
          _buildInfoRow('Privacy Policy', 'View Policy'),
          _buildInfoRow('Terms of Service', 'View Terms'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showGuideDialog(GuideItem guide) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            children: [
              AppBar(
                title: Text(guide.title),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppLocalizations.of(context).developer),
                subtitle: const Text('Alex M. Kamau'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchUrl('mailto:alex.kamau@securevault.app'),
              ),
              Expanded(
                child: Markdown(data: guide.content),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLiveChatDialog() {
    Get.snackbar('Info', 'Live chat feature coming soon!');
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _getGettingStartedGuide() {
    return '''
# Getting Started with SecureVault

Welcome to SecureVault! This guide will help you get started.

## 1. Create Your First Account
- Tap the "+" button on the home screen
- Enter your account details
- Use the password generator for strong passwords

## 2. Enable Security Features
- Set up biometric authentication
- Enable two-factor authentication
- Configure auto-lock settings

## 3. Organize Your Passwords
- Use categories to organize accounts
- Add notes for important information
- Use the search feature to find accounts quickly

## 4. Stay Secure
- Regularly run security audits
- Monitor for breached passwords
- Keep the app updated
    ''';
  }

  String _getSecurityGuide() {
    return '''
# Security Best Practices

## Password Security
- Use unique passwords for each account
- Enable two-factor authentication
- Regularly update important passwords

## Account Protection
- Use biometric authentication
- Set up auto-lock
- Keep your master password secure

## Sharing Safely
- Only share with trusted family members
- Review shared items regularly
- Revoke access when needed
    ''';
  }

  String _getFamilySharingGuide() {
    return '''
# Family Sharing Setup

## Creating a Family Vault
1. Go to Settings > Family Sharing
2. Create your family vault
3. Generate invite codes for family members

## Managing Members
- Assign appropriate roles (Admin, Member, Child)
- Control sharing permissions
- Monitor family activity

## Sharing Passwords
- Select accounts to share
- Choose appropriate permissions
- Review and manage shared items
    ''';
  }

  String _getBrowserGuide() {
    return '''
# Browser Integration

## Installing Extensions
1. Go to Settings > Auto-fill & Browser Integration
2. Select your browser
3. Install the SecureVault extension

## Setting Up Auto-fill
- Enable auto-fill in settings
- Configure auto-fill preferences
- Test with a login form

## Troubleshooting
- Ensure extensions are up to date
- Check browser permissions
- Restart browser if needed
    ''';
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class GuideItem {
  final String title;
  final String description;
  final IconData icon;
  final String content;

  GuideItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.content,
  });
}

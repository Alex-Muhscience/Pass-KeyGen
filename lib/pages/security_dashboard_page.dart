import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../services/security_audit_service.dart';
import '../services/advanced_password_generator.dart';
import '../services/breach_detection_service.dart';
import '../services/database_helper.dart';
import '../models/account_model.dart';

class SecurityDashboardPage extends StatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  State<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends State<SecurityDashboardPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late SecurityAuditService _auditService;
  SecurityReport? _currentReport;
  bool _isLoading = true;
  List<AccountModel> _accounts = [];

  @override
  void initState() {
    super.initState();
    _auditService = SecurityAuditService(
      AdvancedPasswordGenerator(),
      BreachDetectionService(),
    );
    _loadSecurityData();
  }

  Future<void> _loadSecurityData() async {
    setState(() => _isLoading = true);
    
    try {
      _accounts = await _databaseHelper.getAllAccounts();
      _currentReport = await _auditService.performSecurityAudit(_accounts);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load security data: $e');
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Security Dashboard',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadSecurityData,
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentReport == null
              ? _buildEmptyState()
              : _buildDashboard(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.security,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const Gap(16),
          Text(
            'No Security Data',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Gap(8),
          Text(
            'Add some accounts to see your security status',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        // Security Score Header
        SliverToBoxAdapter(
          child: _buildSecurityScoreCard()
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.3),
        ),
        
        // Quick Stats
        SliverToBoxAdapter(
          child: _buildQuickStats()
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3),
        ),
        
        // Risk Breakdown
        SliverToBoxAdapter(
          child: _buildRiskBreakdown()
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.3),
        ),
        
        // Security Issues
        SliverToBoxAdapter(
          child: _buildSecurityIssues()
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: 0.3),
        ),
        
        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }

  Widget _buildSecurityScoreCard() {
    final score = _currentReport!.securityScore;
    final color = _getScoreColor(score);
    
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.security,
                  color: color,
                  size: 32,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Score',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getScoreDescription(score),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$score',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final stats = _currentReport!.statistics;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Accounts',
              '${_currentReport!.totalAccounts}',
              Icons.account_circle,
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const Gap(12),
          Expanded(
            child: _buildStatCard(
              'Issues Found',
              '${_currentReport!.issues.length}',
              Icons.warning,
              _currentReport!.issues.isEmpty ? Colors.green : Colors.orange,
            ),
          ),
          const Gap(12),
          Expanded(
            child: _buildStatCard(
              'Strong Passwords',
              '${stats['strongPasswordPercentage']?.toInt() ?? 0}%',
              Icons.lock,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBreakdown() {
    final breakdown = _currentReport!.riskBreakdown;
    
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          _buildRiskItem('Critical', breakdown[SecurityRiskLevel.critical] ?? 0, Colors.red),
          _buildRiskItem('High', breakdown[SecurityRiskLevel.high] ?? 0, Colors.orange),
          _buildRiskItem('Medium', breakdown[SecurityRiskLevel.medium] ?? 0, Colors.yellow),
          _buildRiskItem('Low', breakdown[SecurityRiskLevel.low] ?? 0, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildRiskItem(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityIssues() {
    final issues = _currentReport!.issues;
    
    if (issues.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const Gap(16),
            Text(
              'All Clear!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'No security issues detected',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Issues',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ...issues.take(5).map((issue) => _buildIssueCard(issue)),
          if (issues.length > 5)
            TextButton(
              onPressed: () => _showAllIssues(issues),
              child: Text('View All ${issues.length} Issues'),
            ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(SecurityIssue issue) {
    final color = _getRiskColor(issue.riskLevel);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  issue.riskLevel.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                _getIssueIcon(issue.type),
                color: color,
                size: 20,
              ),
            ],
          ),
          const Gap(8),
          Text(
            issue.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Text(
            issue.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          if (issue.affectedAccounts.isNotEmpty) ...[
            const Gap(8),
            Text(
              'Affected: ${issue.affectedAccounts.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAllIssues(List<SecurityIssue> issues) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'All Security Issues',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: issues.length,
                itemBuilder: (context, index) => _buildIssueCard(issues[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreDescription(int score) {
    if (score >= 90) return 'Excellent security';
    if (score >= 80) return 'Good security';
    if (score >= 60) return 'Fair security';
    if (score >= 40) return 'Poor security';
    return 'Critical security issues';
  }

  Color _getRiskColor(SecurityRiskLevel level) {
    switch (level) {
      case SecurityRiskLevel.critical:
        return Colors.red;
      case SecurityRiskLevel.high:
        return Colors.orange;
      case SecurityRiskLevel.medium:
        return Colors.yellow;
      case SecurityRiskLevel.low:
        return Colors.blue;
    }
  }

  IconData _getIssueIcon(SecurityIssueType type) {
    switch (type) {
      case SecurityIssueType.weakPassword:
        return Icons.lock_open;
      case SecurityIssueType.reusedPassword:
        return Icons.content_copy;
      case SecurityIssueType.oldPassword:
        return Icons.schedule;
      case SecurityIssueType.breachedPassword:
        return Icons.warning;
      case SecurityIssueType.noTwoFactor:
        return Icons.security;
      case SecurityIssueType.insecureWebsite:
        return Icons.http;
      case SecurityIssueType.duplicateAccount:
        return Icons.group;
    }
  }
}

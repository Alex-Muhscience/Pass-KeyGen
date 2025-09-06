import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/generated/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: theme.colorScheme.surface,
      pages: [
        _buildWelcomePage(theme, l10n),
        _buildSecurityPage(theme, l10n),
        _buildFeaturesPage(theme, l10n),
        _buildSharingPage(theme, l10n),
        _buildAutofillPage(theme, l10n),
        _buildGetStartedPage(theme, l10n),
      ],
      onDone: () => _completeOnboarding(),
      onSkip: () => _completeOnboarding(),
      showSkipButton: true,
      skip: Text(
        'Skip',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      next: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          'Get Started',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10, 10),
        color: theme.colorScheme.outline.withValues(alpha: 0.3),
        activeSize: const Size(22, 10),
        activeColor: theme.colorScheme.primary,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  PageViewModel _buildWelcomePage(ThemeData theme, AppLocalizations l10n) {
    return PageViewModel(
      title: "Welcome to SecureVault",
      body: "Your ultimate password manager for secure, convenient, and organized digital life.",
      image: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.security,
            size: 100,
            color: theme.colorScheme.onPrimary,
          ),
        ).animate().scale(delay: 300.ms),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        imagePadding: const EdgeInsets.only(top: 40),
      ),
    );
  }

  PageViewModel _buildSecurityPage(ThemeData theme, AppLocalizations l10n) {
    return PageViewModel(
      title: "Military-Grade Security",
      body: "Your passwords are protected with AES-256 encryption, biometric authentication, and advanced security features.",
      image: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSecurityFeature(Icons.lock, "AES-256", theme),
                _buildSecurityFeature(Icons.fingerprint, "Biometric", theme),
                _buildSecurityFeature(Icons.shield, "2FA", theme),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.verified_user,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ).animate().scale(delay: 400.ms),
          ],
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        imagePadding: const EdgeInsets.only(top: 20),
      ),
    );
  }

  PageViewModel _buildFeaturesPage(ThemeData theme, AppLocalizations l10n) {
    return PageViewModel(
      title: "Powerful Features",
      body: "Generate strong passwords, monitor breaches, audit security, and manage everything from one secure place.",
      image: Center(
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
          children: [
            _buildFeatureCard(Icons.generating_tokens, "Password\nGenerator", theme),
            _buildFeatureCard(Icons.security, "Security\nAudit", theme),
            _buildFeatureCard(Icons.warning, "Breach\nDetection", theme),
            _buildFeatureCard(Icons.backup, "Secure\nBackup", theme),
          ],
        ).animate().fadeIn(delay: 200.ms),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        imagePadding: const EdgeInsets.only(top: 20),
      ),
    );
  }

  PageViewModel _buildSharingPage(ThemeData theme, AppLocalizations l10n) {
    return PageViewModel(
      title: "Family Sharing",
      body: "Securely share passwords with family members and manage access with granular permissions.",
      image: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFamilyAvatar("A", Colors.blue, theme),
                const SizedBox(width: 10),
                _buildFamilyAvatar("B", Colors.green, theme),
                const SizedBox(width: 10),
                _buildFamilyAvatar("C", Colors.orange, theme),
              ],
            ).animate().fadeIn(delay: 200.ms).slideX(),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.share,
                    size: 60,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Secure Sharing",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ).animate().scale(delay: 400.ms),
          ],
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        imagePadding: const EdgeInsets.only(top: 20),
      ),
    );
  }

  PageViewModel _buildAutofillPage(ThemeData theme, AppLocalizations l10n) {
    return PageViewModel(
      title: "Auto-fill & Browser Integration",
      body: "Seamlessly fill passwords in apps and browsers with our advanced auto-fill technology.",
      image: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBrowserIcon(Icons.web, "Chrome", Colors.blue, theme),
                _buildBrowserIcon(Icons.web, "Firefox", Colors.orange, theme),
                _buildBrowserIcon(Icons.web, "Safari", Colors.indigo, theme),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                    theme.colorScheme.secondary.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ).animate().scale(delay: 400.ms),
          ],
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        imagePadding: const EdgeInsets.only(top: 20),
      ),
    );
  }

  PageViewModel _buildGetStartedPage(ThemeData theme, AppLocalizations l10n) {
    return PageViewModel(
      title: "Ready to Get Started?",
      body: "Create your first account and experience the future of password management with SecureVault.",
      image: Center(
        child: Column(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.rocket_launch,
                size: 80,
                color: theme.colorScheme.onPrimary,
              ),
            ).animate().scale(delay: 200.ms),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                "🎉 Welcome to SecureVault!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(),
          ],
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        imagePadding: const EdgeInsets.only(top: 20),
      ),
    );
  }

  Widget _buildSecurityFeature(IconData icon, String label, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 30,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyAvatar(String initial, Color color, ThemeData theme) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildBrowserIcon(IconData icon, String name, Color color, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    Get.offAllNamed('/login');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../services/language_service.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final currentLocale = await LanguageService.getCurrentLocale();
    setState(() {
      selectedLanguage = currentLocale.languageCode;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      selectedLanguage = languageCode;
    });

    try {
      await LanguageService.setLanguage(languageCode);
      
      // Update app locale
      Get.updateLocale(Locale(languageCode));
      
      // Show success message
      if (mounted) {
        Get.snackbar(
          'Success',
          'Language changed successfully',
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          colorText: Theme.of(context).colorScheme.onPrimaryContainer,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
      
      // Navigate back after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Get.back();
      }
      
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to change language',
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          colorText: Theme.of(context).colorScheme.onErrorContainer,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageOptions = LanguageService.getLanguageOptions();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Select Language',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.language,
                  size: 48,
                  color: theme.colorScheme.primary,
                ).animate().fadeIn().scale(),
                const Gap(16),
                Text(
                  'Language',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate(delay: 200.ms).fadeIn().slideX(),
                const Gap(8),
                Text(
                  'Choose your preferred language',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ).animate(delay: 400.ms).fadeIn().slideX(),
              ],
            ),
          ),
          
          // Language List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: languageOptions.length,
              itemBuilder: (context, index) {
                final language = languageOptions[index];
                final isSelected = selectedLanguage == language['code'];
                final isRTL = LanguageService.isRTL(language['code']!);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isLoading ? null : () => _changeLanguage(language['code']!),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Language Flag/Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  _getLanguageFlag(language['code']!),
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const Gap(16),
                            
                            // Language Names
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    language['name']!,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected 
                                        ? theme.colorScheme.onPrimaryContainer
                                        : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    language['nativeName']!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isSelected 
                                        ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  ),
                                ],
                              ),
                            ),
                            
                            // Selection Indicator
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ).animate().scale()
                            else if (isLoading && selectedLanguage == language['code'])
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate(delay: Duration(milliseconds: 100 * index))
                 .fadeIn()
                 .slideX(begin: 0.3);
              },
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Restart the app to apply language changes completely',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ).animate(delay: 800.ms).fadeIn(),
        ],
      ),
    );
  }

  String _getLanguageFlag(String languageCode) {
    const flags = {
      'en': '🇺🇸',
      'es': '🇪🇸',
      'fr': '🇫🇷',
      'de': '🇩🇪',
      'it': '🇮🇹',
      'pt': '🇵🇹',
      'ru': '🇷🇺',
      'zh': '🇨🇳',
      'ja': '🇯🇵',
      'ko': '🇰🇷',
      'ar': '🇸🇦',
      'hi': '🇮🇳',
    };
    return flags[languageCode] ?? '🌐';
  }
}

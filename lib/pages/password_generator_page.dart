import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../services/advanced_password_generator.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  final AdvancedPasswordGenerator _generator = AdvancedPasswordGenerator();
  
  // Password options
  int _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  bool _excludeSimilar = false;
  bool _excludeAmbiguous = false;
  
  // Passphrase options
  int _wordCount = 4;
  String _separator = '-';
  bool _includeNumbersInPassphrase = false;
  bool _capitalizeWords = false;
  
  String _generatedPassword = '';
  List<String> _passwordOptions = [];
  PasswordAnalysis? _analysis;
  bool _isPassphraseMode = false;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  Future<void> _generatePassword() async {
    setState(() => _isGenerating = true);
    
    try {
      if (_isPassphraseMode) {
        _generatedPassword = _generator.generatePassphrase(
          wordCount: _wordCount,
          separator: _separator,
          includeNumbers: _includeNumbersInPassphrase,
          capitalizeWords: _capitalizeWords,
        );
        _passwordOptions = [];
      } else {
        final options = PasswordGeneratorOptions(
          length: _length,
          includeUppercase: _includeUppercase,
          includeLowercase: _includeLowercase,
          includeNumbers: _includeNumbers,
          includeSymbols: _includeSymbols,
          excludeSimilar: _excludeSimilar,
          excludeAmbiguous: _excludeAmbiguous,
        );
        
        _generatedPassword = _generator.generatePassword(options);
        _passwordOptions = _generator.generatePasswordOptions(options, count: 4);
      }
      
      _analysis = _generator.analyzePassword(_generatedPassword);
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate password: $e');
    }
    
    setState(() => _isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Password Generator',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _generatePassword,
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Mode Toggle
          SliverToBoxAdapter(
            child: _buildModeToggle()
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.3),
          ),
          
          // Generated Password Display
          SliverToBoxAdapter(
            child: _buildPasswordDisplay()
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3),
          ),
          
          // Password Analysis
          if (_analysis != null)
            SliverToBoxAdapter(
              child: _buildPasswordAnalysis()
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3),
            ),
          
          // Password Options
          if (_passwordOptions.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildPasswordOptions()
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: 0.3),
            ),
          
          // Settings
          SliverToBoxAdapter(
            child: _buildSettings()
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3),
          ),
          
          const SliverToBoxAdapter(child: Gap(100)),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isPassphraseMode = false);
                _generatePassword();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isPassphraseMode 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isPassphraseMode
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isPassphraseMode = true);
                _generatePassword();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isPassphraseMode 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Passphrase',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isPassphraseMode
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Gap(8),
              Text(
                'Generated ${_isPassphraseMode ? 'Passphrase' : 'Password'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: _isGenerating
                ? const Center(child: CircularProgressIndicator())
                : SelectableText(
                    _generatedPassword,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : () {
                    Clipboard.setData(ClipboardData(text: _generatedPassword));
                    Get.snackbar(
                      'Copied',
                      'Password copied to clipboard',
                      duration: const Duration(seconds: 2),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _generatePassword,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Generate'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordAnalysis() {
    final analysis = _analysis!;
    final strengthColor = _getStrengthColor(analysis.strength);
    
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
            'Password Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Strength',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const Gap(4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: strengthColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        analysis.strength.toString().split('.').last.toUpperCase(),
                        style: TextStyle(
                          color: strengthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${analysis.score}/100',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: strengthColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entropy',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      '${analysis.entropy.toInt()} bits',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          LinearProgressIndicator(
            value: analysis.score / 100,
            backgroundColor: strengthColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          if (analysis.suggestions.isNotEmpty) ...[
            const Gap(16),
            Text(
              'Suggestions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            ...analysis.suggestions.map((suggestion) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alternative Options',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ...List.generate(_passwordOptions.length, (index) {
            final password = _passwordOptions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      password,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _generatedPassword = password);
                      _analysis = _generator.analyzePassword(password);
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettings() {
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
            '${_isPassphraseMode ? 'Passphrase' : 'Password'} Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          if (_isPassphraseMode) ..._buildPassphraseSettings() else ..._buildPasswordSettings(),
        ],
      ),
    );
  }

  List<Widget> _buildPasswordSettings() {
    return [
      // Length Slider
      Text('Length: $_length'),
      Slider(
        value: _length.toDouble(),
        min: 8,
        max: 128,
        divisions: 120,
        onChanged: (value) {
          setState(() => _length = value.toInt());
          _generatePassword();
        },
      ),
      const Gap(16),
      
      // Character Options
      _buildSwitchTile('Uppercase (A-Z)', _includeUppercase, (value) {
        setState(() => _includeUppercase = value);
        _generatePassword();
      }),
      _buildSwitchTile('Lowercase (a-z)', _includeLowercase, (value) {
        setState(() => _includeLowercase = value);
        _generatePassword();
      }),
      _buildSwitchTile('Numbers (0-9)', _includeNumbers, (value) {
        setState(() => _includeNumbers = value);
        _generatePassword();
      }),
      _buildSwitchTile('Symbols (!@#\$)', _includeSymbols, (value) {
        setState(() => _includeSymbols = value);
        _generatePassword();
      }),
      
      const Gap(16),
      const Divider(),
      const Gap(16),
      
      // Advanced Options
      Text(
        'Advanced Options',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const Gap(8),
      _buildSwitchTile('Exclude Similar (il1Lo0O)', _excludeSimilar, (value) {
        setState(() => _excludeSimilar = value);
        _generatePassword();
      }),
      _buildSwitchTile('Exclude Ambiguous ({}[]())', _excludeAmbiguous, (value) {
        setState(() => _excludeAmbiguous = value);
        _generatePassword();
      }),
    ];
  }

  List<Widget> _buildPassphraseSettings() {
    return [
      // Word Count
      Text('Word Count: $_wordCount'),
      Slider(
        value: _wordCount.toDouble(),
        min: 3,
        max: 8,
        divisions: 5,
        onChanged: (value) {
          setState(() => _wordCount = value.toInt());
          _generatePassword();
        },
      ),
      const Gap(16),
      
      // Separator
      const Text('Separator'),
      const Gap(8),
      Row(
        children: [
          ...['-', '_', '.', ' '].map((sep) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _separator = sep);
                _generatePassword();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _separator == sep
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sep == ' ' ? 'Space' : sep,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _separator == sep
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
      const Gap(16),
      
      // Options
      _buildSwitchTile('Include Numbers', _includeNumbersInPassphrase, (value) {
        setState(() => _includeNumbersInPassphrase = value);
        _generatePassword();
      }),
      _buildSwitchTile('Capitalize Words', _capitalizeWords, (value) {
        setState(() => _capitalizeWords = value);
        _generatePassword();
      }),
    ];
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryStrong:
        return Colors.green;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.good:
        return Colors.orange;
      case PasswordStrength.fair:
        return Colors.deepOrange;
      case PasswordStrength.weak:
        return Colors.red;
    }
  }
}

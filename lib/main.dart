import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_fonts.dart';

void main() {
  runApp(const LexiQuestApp());
}

class LexiQuestApp extends StatelessWidget {
  const LexiQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LexiQuest',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ThemePreviewScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// A preview screen to showcase the LexiQuest theme configuration
class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LexiQuest Theme Preview'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Theme(
        data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colors Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Color Palette', style: AppFonts.headlineSmall),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ColorSwatch(
                            'Primary Indigo 600',
                            AppColors.primaryIndigo600,
                          ),
                          _ColorSwatch(
                            'Primary Indigo 500',
                            AppColors.primaryIndigo500,
                          ),
                          _ColorSwatch(
                            'Primary Indigo Dark',
                            AppColors.primaryIndigoDark,
                          ),
                          _ColorSwatch(
                            'Secondary Green',
                            AppColors.secondaryGreen500,
                          ),
                          _ColorSwatch(
                            'Secondary Amber',
                            AppColors.secondaryAmber500,
                          ),
                          _ColorSwatch(
                            'Secondary Red',
                            AppColors.secondaryRed500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Typography Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Typography (Mulish Font)',
                        style: AppFonts.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Text('Display Large', style: AppFonts.displayLarge),
                      Text('Headline Large', style: AppFonts.headlineLarge),
                      Text('Title Large', style: AppFonts.titleLarge),
                      Text('Body Large', style: AppFonts.bodyLarge),
                      Text('Label Large', style: AppFonts.labelLarge),
                      Text('Body Small', style: AppFonts.bodySmall),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Buttons Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Button Styles', style: AppFonts.headlineSmall),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Elevated Button'),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Outlined Button'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Text Button'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Fields Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Input Fields', style: AppFonts.headlineSmall),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.visibility),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Chips Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chips & Tags', style: AppFonts.headlineSmall),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: const Text('Text Annotation'),
                            avatar: CircleAvatar(
                              backgroundColor: AppColors.secondaryGreen500,
                              child: const Text('T'),
                            ),
                          ),
                          Chip(
                            label: const Text('Image Labeling'),
                            avatar: CircleAvatar(
                              backgroundColor: AppColors.secondaryAmber500,
                              child: const Text('I'),
                            ),
                          ),
                          ActionChip(
                            label: const Text('AI Assist'),
                            onPressed: () {},
                            avatar: const Icon(Icons.smart_toy, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('LexiQuest theme is looking great! 🎯'),
            ),
          );
        },
        tooltip: 'Test Theme',
        child: const Icon(Icons.palette),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorSwatch(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutralSlate600_30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              style: AppFonts.labelSmall.copyWith(
                color: _getContrastColor(color),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calculate relative luminance
    final luminance = backgroundColor.computeLuminance();
    // Return white for dark colors, dark for light colors
    return luminance > 0.5 ? AppColors.neutralSlate900 : AppColors.neutralWhite;
  }
}

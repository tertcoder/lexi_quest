import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/widgets/annotation_app_bar.dart';
import 'package:lexi_quest/core/widgets/xp_reward_dialog.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';

class TextAnnotationScreen extends StatefulWidget {
  const TextAnnotationScreen({super.key});

  @override
  State<TextAnnotationScreen> createState() => _TextAnnotationScreenState();
}

class _TextAnnotationScreenState extends State<TextAnnotationScreen> {
  List<AnnotationModel> _annotations = [];
  int _currentIndex = 0;
  String? _selectedLabel;
  final Map<String, List<TextSelection>> _labeledSelections = {};
  int _totalXp = 8750;
  int _currentStreak = 15;

  @override
  void initState() {
    super.initState();
    _loadAnnotations();
  }

  Future<void> _loadAnnotations() async {
    try {
      final String response = await rootBundle.loadString('assets/data/sample_annotations.json');
      final data = json.decode(response);
      final List<dynamic> textAnnotations = data['text_annotations'];

      setState(() {
        _annotations = textAnnotations
            .map((json) => AnnotationModel.fromJson(json))
            .toList();
      });
    } catch (e) {
      debugPrint('Error loading annotations: $e');
    }
  }

  AnnotationModel? get _currentAnnotation {
    if (_annotations.isEmpty || _currentIndex >= _annotations.length) {
      return null;
    }
    return _annotations[_currentIndex];
  }

  void _onLabelSelected(String label) {
    setState(() {
      _selectedLabel = label;
    });
  }

  void _addLabeledText(String text, int start, int end) {
    if (_selectedLabel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a label first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _labeledSelections.putIfAbsent(_selectedLabel!, () => []);
      _labeledSelections[_selectedLabel!]!.add(
        TextSelection(baseOffset: start, extentOffset: end),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Labeled as "$_selectedLabel"'),
        backgroundColor: AppColors.secondaryGreen500,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitAnnotation() async {
    if (_labeledSelections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please label at least one text segment'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final xpEarned = _currentAnnotation?.xpReward ?? 10;
    setState(() {
      _totalXp += xpEarned;
      _currentStreak++;
    });

    await XpRewardDialog.show(
      context,
      xpEarned: xpEarned,
      currentStreak: _currentStreak,
    );

    _nextAnnotation();
  }

  void _nextAnnotation() {
    setState(() {
      if (_currentIndex < _annotations.length - 1) {
        _currentIndex++;
        _labeledSelections.clear();
        _selectedLabel = null;
      } else {
        // All annotations completed
        Navigator.of(context).pop();
      }
    });
  }

  void _skipAnnotation() {
    _nextAnnotation();
  }

  @override
  Widget build(BuildContext context) {
    final annotation = _currentAnnotation;

    if (annotation == null) {
      return Scaffold(
        appBar: AnnotationAppBar(
          title: 'Text Annotation',
          currentXp: _totalXp,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AnnotationAppBar(
        title: 'Text Annotation',
        currentXp: _totalXp,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Task ${_currentIndex + 1} of ${_annotations.length}',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '+${annotation.xpReward} XP',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.secondaryAmber500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / _annotations.length,
                    backgroundColor: AppColors.neutralSlate600_30,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryGreen500,
                    ),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructions
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo600.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryIndigo600.withValues(alpha:0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.primaryIndigo600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Instructions',
                                style: AppFonts.titleSmall.copyWith(
                                  color: AppColors.primaryIndigo600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select a label below, then tap and hold to select text segments to annotate.',
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label Selection
                    Text(
                      'Select Label',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: annotation.labels.map((label) {
                        final isSelected = _selectedLabel == label;
                        return GestureDetector(
                          onTap: () => _onLabelSelected(label),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryIndigo600
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryIndigo600
                                    : AppColors.neutralSlate600_30,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              label,
                              style: AppFonts.bodyMedium.copyWith(
                                color: isSelected
                                    ? AppColors.onPrimary
                                    : AppColors.onBackground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Text Content
                    Text(
                      'Text to Annotate',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.neutralSlate600_30,
                        ),
                      ),
                      child: SelectableText(
                        annotation.content,
                        style: AppFonts.bodyLarge.copyWith(
                          color: AppColors.onBackground,
                          height: 1.6,
                        ),
                        onSelectionChanged: (selection, cause) {
                          if (selection.start != selection.end) {
                            _addLabeledText(
                              annotation.content,
                              selection.start,
                              selection.end,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Labeled Items Summary
                    if (_labeledSelections.isNotEmpty) ...[
                      Text(
                        'Labeled Items (${_labeledSelections.values.fold(0, (sum, list) => sum + list.length)})',
                        style: AppFonts.titleMedium.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._labeledSelections.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryGreen500.withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.secondaryGreen500.withValues(alpha:0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryGreen500,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    entry.key,
                                    style: AppFonts.labelSmall.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${entry.value.length} item(s)',
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: AppColors.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutralSlate900_25,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _skipAnnotation,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: AppColors.neutralSlate600_30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: AppFonts.buttonText.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitAnnotation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryIndigo600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit Annotation',
                        style: AppFonts.buttonText.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

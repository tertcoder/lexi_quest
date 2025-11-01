import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/widgets/annotation_app_bar.dart';
import 'package:lexi_quest/core/widgets/xp_reward_dialog.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';

class BoundingBox {
  final Offset topLeft;
  final Offset bottomRight;
  final String label;
  final Color color;

  BoundingBox({
    required this.topLeft,
    required this.bottomRight,
    required this.label,
    required this.color,
  });
}

class ImageAnnotationScreen extends StatefulWidget {
  const ImageAnnotationScreen({super.key});

  @override
  State<ImageAnnotationScreen> createState() => _ImageAnnotationScreenState();
}

class _ImageAnnotationScreenState extends State<ImageAnnotationScreen> {
  List<AnnotationModel> _annotations = [];
  int _currentIndex = 0;
  String? _selectedLabel;
  final List<BoundingBox> _boundingBoxes = [];
  Offset? _dragStart;
  Offset? _dragCurrent;
  int _totalXp = 8750;
  int _currentStreak = 15;

  final List<Color> _labelColors = [
    AppColors.secondaryGreen500,
    AppColors.secondaryAmber500,
    AppColors.primaryIndigo600,
    AppColors.secondaryRed500,
    const Color(0xFF8B5CF6),
  ];

  @override
  void initState() {
    super.initState();
    _loadAnnotations();
  }

  Future<void> _loadAnnotations() async {
    try {
      final String response = await rootBundle.loadString('assets/data/sample_annotations.json');
      final data = json.decode(response);
      final List<dynamic> imageAnnotations = data['image_annotations'];

      setState(() {
        _annotations = imageAnnotations
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

  Color _getColorForLabel(String label) {
    final index = _currentAnnotation?.labels.indexOf(label) ?? 0;
    return _labelColors[index % _labelColors.length];
  }

  void _onLabelSelected(String label) {
    setState(() {
      _selectedLabel = label;
    });
  }

  void _onPanStart(DragStartDetails details, Size imageSize) {
    if (_selectedLabel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a label first'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _dragStart = details.localPosition;
      _dragCurrent = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_dragStart != null) {
      setState(() {
        _dragCurrent = details.localPosition;
      });
    }
  }

  void _onPanEnd(DragEndDetails details, Size imageSize) {
    if (_dragStart != null && _dragCurrent != null && _selectedLabel != null) {
      // Ensure the box has minimum size
      final dx = (_dragCurrent!.dx - _dragStart!.dx).abs();
      final dy = (_dragCurrent!.dy - _dragStart!.dy).abs();

      if (dx > 20 && dy > 20) {
        setState(() {
          _boundingBoxes.add(
            BoundingBox(
              topLeft: Offset(
                _dragStart!.dx < _dragCurrent!.dx ? _dragStart!.dx : _dragCurrent!.dx,
                _dragStart!.dy < _dragCurrent!.dy ? _dragStart!.dy : _dragCurrent!.dy,
              ),
              bottomRight: Offset(
                _dragStart!.dx > _dragCurrent!.dx ? _dragStart!.dx : _dragCurrent!.dx,
                _dragStart!.dy > _dragCurrent!.dy ? _dragStart!.dy : _dragCurrent!.dy,
              ),
              label: _selectedLabel!,
              color: _getColorForLabel(_selectedLabel!),
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "$_selectedLabel" annotation'),
            backgroundColor: AppColors.secondaryGreen500,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }

    setState(() {
      _dragStart = null;
      _dragCurrent = null;
    });
  }

  Future<void> _submitAnnotation() async {
    if (_boundingBoxes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one bounding box'),
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
        _boundingBoxes.clear();
        _selectedLabel = null;
        _dragStart = null;
        _dragCurrent = null;
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  void _skipAnnotation() {
    _nextAnnotation();
  }

  void _undoLastBox() {
    if (_boundingBoxes.isNotEmpty) {
      setState(() {
        _boundingBoxes.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final annotation = _currentAnnotation;

    if (annotation == null) {
      return Scaffold(
        appBar: AnnotationAppBar(
          title: 'Image Annotation',
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
        title: 'Image Annotation',
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
                            annotation.content,
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select a label, then drag on the image to draw bounding boxes.',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Label',
                          style: AppFonts.titleMedium.copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_boundingBoxes.isNotEmpty)
                          TextButton.icon(
                            onPressed: _undoLastBox,
                            icon: const Icon(Icons.undo, size: 18),
                            label: const Text('Undo'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryIndigo600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: annotation.labels.map((label) {
                        final isSelected = _selectedLabel == label;
                        final color = _getColorForLabel(label);
                        return GestureDetector(
                          onTap: () => _onLabelSelected(label),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? color : AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: color,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  label,
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.onPrimary
                                        : AppColors.onBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Image with Bounding Boxes
                    Text(
                      'Image',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.neutralSlate600_30,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              onPanStart: (details) => _onPanStart(details, Size(constraints.maxWidth, 300)),
                              onPanUpdate: _onPanUpdate,
                              onPanEnd: (details) => _onPanEnd(details, Size(constraints.maxWidth, 300)),
                              child: Stack(
                                children: [
                                  // Image
                                  Image.network(
                                    annotation.imageUrl ?? '',
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 300,
                                        color: AppColors.neutralSlate600_30,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.image_not_supported,
                                              size: 64,
                                              color: AppColors.neutralSlate600,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Sample Image',
                                              style: AppFonts.bodyMedium.copyWith(
                                                color: AppColors.neutralSlate600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  // Existing Bounding Boxes
                                  ..._boundingBoxes.map((box) {
                                    return Positioned(
                                      left: box.topLeft.dx,
                                      top: box.topLeft.dy,
                                      child: Container(
                                        width: box.bottomRight.dx - box.topLeft.dx,
                                        height: box.bottomRight.dy - box.topLeft.dy,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: box.color,
                                            width: 3,
                                          ),
                                          color: box.color.withValues(alpha:0.2),
                                        ),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            color: box.color,
                                            child: Text(
                                              box.label,
                                              style: AppFonts.labelSmall.copyWith(
                                                color: AppColors.onPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  // Current Drag Box
                                  if (_dragStart != null && _dragCurrent != null && _selectedLabel != null)
                                    Positioned(
                                      left: _dragStart!.dx < _dragCurrent!.dx ? _dragStart!.dx : _dragCurrent!.dx,
                                      top: _dragStart!.dy < _dragCurrent!.dy ? _dragStart!.dy : _dragCurrent!.dy,
                                      child: Container(
                                        width: (_dragCurrent!.dx - _dragStart!.dx).abs(),
                                        height: (_dragCurrent!.dy - _dragStart!.dy).abs(),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: _getColorForLabel(_selectedLabel!),
                                            width: 3,
                                          ),
                                          color: _getColorForLabel(_selectedLabel!).withValues(alpha:0.2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Annotations Summary
                    if (_boundingBoxes.isNotEmpty) ...[
                      Text(
                        'Annotations (${_boundingBoxes.length})',
                        style: AppFonts.titleMedium.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...Map.fromEntries(
                        annotation.labels.map((label) {
                          final count = _boundingBoxes.where((box) => box.label == label).length;
                          return MapEntry(label, count);
                        }),
                      ).entries.where((entry) => entry.value > 0).map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getColorForLabel(entry.key).withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getColorForLabel(entry.key).withValues(alpha:0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: _getColorForLabel(entry.key),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  entry.key,
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: AppColors.onBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${entry.value} box${entry.value > 1 ? 'es' : ''}',
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: AppColors.onSurfaceVariant,
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

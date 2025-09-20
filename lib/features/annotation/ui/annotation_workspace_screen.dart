import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import 'package:lexi_quest/core/widgets/primary_button.dart';
import '../bloc/annotation_bloc.dart';
import '../bloc/annotation_event.dart';
import '../bloc/annotation_state.dart';
import '../data/models/annotation_task_model.dart';
import '../data/models/completed_annotation_model.dart';
import '../data/repositories/annotation_demo_data.dart';

/// Annotation workspace screen for actively annotating a task
class AnnotationWorkspaceScreen extends StatefulWidget {
  final AnnotationTask task;

  const AnnotationWorkspaceScreen({super.key, required this.task});

  @override
  State<AnnotationWorkspaceScreen> createState() =>
      _AnnotationWorkspaceScreenState();
}

class _AnnotationWorkspaceScreenState extends State<AnnotationWorkspaceScreen> {
  late TextEditingController _labelController;
  String? _selectedCategory;
  List<AnnotationLabel> _currentLabels = [];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();

    // Start the annotation task
    context.read<AnnotationBloc>().add(StartAnnotationTask(widget.task));
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnnotationBloc, AnnotationState>(
      listener: (context, state) {
        if (state is AnnotationInProgress) {
          _currentLabels = state.currentLabels;
        } else if (state is AnnotationSubmitted) {
          _showSuccessDialog(context, state.submittedAnnotation);
        } else if (state is AnnotationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            title: Text(
              'Annotate Task',
              style: AppFonts.titleLarge.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                context.read<AnnotationBloc>().add(
                  const ClearCurrentAnnotation(),
                );
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: AppColors.onBackground),
            ),
          ),
          body: _buildWorkspaceContent(context, state),
          bottomNavigationBar: _buildBottomToolbar(context, state),
        );
      },
    );
  }

  Widget _buildWorkspaceContent(BuildContext context, AnnotationState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutralSlate600_30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(
                          widget.task.type,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        _getTypeIcon(widget.task.type),
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          _getTypeColor(widget.task.type),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.title,
                            style: AppFonts.titleMedium.copyWith(
                              color: AppColors.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.task.type.displayName,
                            style: AppFonts.labelMedium.copyWith(
                              color: _getTypeColor(widget.task.type),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.task.xpReward != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryAmber500.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '+${widget.task.xpReward} XP',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.secondaryAmber500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Content to Annotate
          Text(
            'Content to Annotate:',
            style: AppFonts.titleSmall.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutralSlate600_30),
            ),
            child: Text(
              widget.task.content,
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.onBackground,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Current Labels
          if (_currentLabels.isNotEmpty) ...[
            Text(
              'Current Labels:',
              style: AppFonts.titleSmall.copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _currentLabels.map((label) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo600.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryIndigo600,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${label.text} (${label.category})',
                            style: AppFonts.labelMedium.copyWith(
                              color: AppColors.primaryIndigo600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              context.read<AnnotationBloc>().add(
                                RemoveAnnotationLabel(label.id),
                              );
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.primaryIndigo600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Add Label Section
          Text(
            'Add Label:',
            style: AppFonts.titleSmall.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutralSlate600_30),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: 'Label Text',
                    hintText: 'Enter text to label',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items:
                      AnnotationDemoData.annotationCategories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canAddLabel() ? _addLabel : null,
                    child: const Text('Add Label'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Space for bottom toolbar
        ],
      ),
    );
  }

  Widget _buildBottomToolbar(BuildContext context, AnnotationState state) {
    final isLoading = state is AnnotationLoading;

    return Container(
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed:
                    isLoading
                        ? null
                        : () {
                          context.read<AnnotationBloc>().add(
                            const ClearCurrentAnnotation(),
                          );
                          Navigator.of(context).pop();
                        },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                text: isLoading ? 'Submitting...' : 'Submit Annotation',
                onPressed:
                    isLoading || _currentLabels.isEmpty
                        ? null
                        : () => _submitAnnotation(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canAddLabel() {
    return _labelController.text.isNotEmpty && _selectedCategory != null;
  }

  void _addLabel() {
    if (!_canAddLabel()) return;

    final label = AnnotationLabel(
      id: 'label_${DateTime.now().millisecondsSinceEpoch}',
      text: _labelController.text,
      startPosition: 0, // Mock position
      endPosition: _labelController.text.length,
      category: _selectedCategory!,
      confidence: 0.95, // Mock confidence
    );

    context.read<AnnotationBloc>().add(AddAnnotationLabel(label));

    // Clear form
    _labelController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  void _submitAnnotation(BuildContext context) {
    context.read<AnnotationBloc>().add(
      SubmitAnnotation(taskId: widget.task.id, labels: _currentLabels),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    CompletedAnnotation annotation,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppAssets.illSuccess, width: 80, height: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Annotation Submitted!',
                    style: AppFonts.titleMedium.copyWith(
                      color: AppColors.secondaryGreen500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You earned ${annotation.xpEarned} XP',
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Return to list
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  String _getTypeIcon(AnnotationType type) {
    switch (type) {
      case AnnotationType.text:
        return AppAssets.icText;
      case AnnotationType.image:
        return AppAssets.icImage;
      case AnnotationType.audio:
        return AppAssets.icAudio;
    }
  }

  Color _getTypeColor(AnnotationType type) {
    switch (type) {
      case AnnotationType.text:
        return AppColors.primaryIndigo600;
      case AnnotationType.image:
        return AppColors.secondaryGreen500;
      case AnnotationType.audio:
        return AppColors.secondaryAmber500;
    }
  }
}

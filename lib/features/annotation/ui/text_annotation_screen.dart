import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/widgets/xp_reward_dialog.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_bloc.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_event.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_state.dart';

class TextAnnotationScreen extends StatefulWidget {
  final String? projectId;

  const TextAnnotationScreen({super.key, this.projectId});

  @override
  State<TextAnnotationScreen> createState() => _TextAnnotationScreenState();
}

class _TextAnnotationScreenState extends State<TextAnnotationScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String? _selectedLabel;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _submitAnnotation(BuildContext context, AnnotationModel annotation) {
    if (_selectedLabel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a label before submitting'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final annotationData = {
      'selected_label': _selectedLabel,
      'content': annotation.content,
      'annotation_id': annotation.id,
    };

    context.read<AnnotationBloc>().add(
      SubmitAnnotation(
        annotationId: annotation.id,
        projectId: widget.projectId,
        data: annotationData,
        xpEarned: annotation.xpReward,
      ),
    );
  }

  void _nextAnnotation(int totalAnnotations) {
    if (_currentIndex < totalAnnotations - 1) {
      _animationController.reverse().then((_) {
        setState(() {
          _currentIndex++;
          _selectedLabel = null;
        });
        _animationController.forward();
      });
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AnnotationBloc()..add(
                widget.projectId != null
                    ? LoadAnnotationsFromProjectTasks(
                      projectId: widget.projectId!,
                      type: AnnotationType.text,
                    )
                    : const LoadAllUnannotatedProjectTasks(
                      type: AnnotationType.text,
                    ),
              ),
      child: BlocConsumer<AnnotationBloc, AnnotationState>(
        listener: (context, state) {
          if (state is AnnotationSubmitted) {
            XpRewardDialog.show(
              context,
              xpEarned: state.xpEarned,
              currentStreak: 0,
            ).then((_) {
              final blocState = context.read<AnnotationBloc>().state;
              if (blocState is AnnotationsLoaded) {
                _nextAnnotation(blocState.annotations.length);
              }
            });
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
          if (state is AnnotationLoading) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryIndigo600,
                ),
              ),
            );
          }

          if (state is AnnotationError) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Annotations',
                        style: AppFonts.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed:
                            () => context.read<AnnotationBloc>().add(
                              const LoadAnnotations(type: AnnotationType.text),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryIndigo600,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is! AnnotationsLoaded || state.annotations.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 64,
                      color: AppColors.neutralSlate600.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Annotations Available',
                      style: AppFonts.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutralSlate600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for new tasks',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final annotations = state.annotations;
          if (_currentIndex >= annotations.length) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.secondaryGreen500,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'All Done!',
                      style: AppFonts.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ve completed all available annotations',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryIndigo600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          final annotation = annotations[_currentIndex];
          final labels = annotation.labels;
          final progress = (_currentIndex + 1) / annotations.length;

          return Scaffold(
            backgroundColor: AppColors.surface,
            body: SafeArea(
              child: Column(
                children: [
                  // Modern Gradient Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryIndigo600,
                          AppColors.primaryIndigo500,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.text_fields,
                              color: AppColors.onPrimary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Text Annotation',
                                style: AppFonts.headlineMedium.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryAmber500,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppColors.neutralWhite,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${annotation.xpReward} XP',
                                    style: AppFonts.labelMedium.copyWith(
                                      color: AppColors.neutralWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Task ${_currentIndex + 1} of ${annotations.length}',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.onPrimary.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: AppColors.neutralWhite
                                          .withValues(alpha: 0.3),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            AppColors.neutralWhite,
                                          ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content with Animation
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Instructions Card
                            if (annotation.instructions != null) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryIndigo600.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primaryIndigo600
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: AppColors.primaryIndigo600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        annotation.instructions!,
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.primaryIndigo600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Content Card
                            Text(
                              'Content',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.neutralSlate600_30,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: SelectableText(
                                annotation.content,
                                style: AppFonts.bodyLarge.copyWith(
                                  height: 1.6,
                                  color: AppColors.onBackground,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Labels Section
                            Text(
                              'Select Label',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children:
                                  labels.map((label) {
                                    final isSelected = _selectedLabel == label;
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedLabel = label;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? AppColors.primaryIndigo600
                                                    : AppColors.background,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? AppColors
                                                          .primaryIndigo600
                                                      : AppColors
                                                          .neutralSlate600_30,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            boxShadow:
                                                isSelected
                                                    ? [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .primaryIndigo600
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ]
                                                    : null,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isSelected)
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    size: 18,
                                                    color: AppColors.onPrimary,
                                                  ),
                                                ),
                                              Text(
                                                label,
                                                style: AppFonts.bodyMedium
                                                    .copyWith(
                                                      color:
                                                          isSelected
                                                              ? AppColors
                                                                  .onPrimary
                                                              : AppColors
                                                                  .onBackground,
                                                      fontWeight:
                                                          isSelected
                                                              ? FontWeight.bold
                                                              : FontWeight.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Modern Action Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          // Skip Button
                          OutlinedButton(
                            onPressed:
                                () => _nextAnnotation(annotations.length),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
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
                          const SizedBox(width: 12),
                          // Submit Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _selectedLabel == null
                                      ? null
                                      : () => _submitAnnotation(
                                        context,
                                        annotation,
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryIndigo600,
                                disabledBackgroundColor:
                                    AppColors.neutralSlate600_30,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: _selectedLabel == null ? 0 : 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle, size: 20,
            color: AppColors.onPrimary,
                                  
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Submit Answer',
                                    style: AppFonts.buttonText.copyWith(
                                      fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../bloc/annotation_bloc.dart';
import '../bloc/annotation_state.dart';
import '../data/models/completed_annotation_model.dart';
import '../data/models/annotation_task_model.dart';

class AnnotationHistoryScreen extends StatelessWidget {
  const AnnotationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnotationBloc, AnnotationState>(
      builder: (context, state) {
        List<CompletedAnnotation> completedAnnotations = [];

        if (state is AnnotationTasksLoaded) {
          completedAnnotations = state.completedAnnotations;
        } else if (state is AnnotationInProgress) {
          completedAnnotations = state.completedAnnotations;
        } else if (state is AnnotationSubmitted) {
          completedAnnotations = state.completedAnnotations;
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Annotation History',
              style: AppFonts.heading1.copyWith(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${completedAnnotations.length} completed',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body:
              completedAnnotations.isEmpty
                  ? _buildEmptyState()
                  : _buildHistoryList(completedAnnotations),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No Completed Annotations',
            style: AppFonts.heading2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete some annotation tasks to see your history here.',
            style: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<CompletedAnnotation> annotations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: annotations.length,
      itemBuilder: (context, index) {
        final annotation = annotations[index];
        return _buildHistoryCard(annotation);
      },
    );
  }

  Widget _buildHistoryCard(CompletedAnnotation annotation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(annotation.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  annotation.type.displayName,
                  style: AppFonts.caption.copyWith(
                    color: _getTypeColor(annotation.type),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(annotation.completedAt),
                style: AppFonts.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            annotation.title,
            style: AppFonts.heading3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            annotation.description,
            style: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(
                'Labels',
                '${annotation.labelsAdded}',
                Icons.label,
              ),
              const SizedBox(width: 12),
              _buildStatChip('XP', '+${annotation.xpEarned}', Icons.star),
              const Spacer(),
              Text(
                '${annotation.timeSpent}min',
                style: AppFonts.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: AppFonts.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(AnnotationType type) {
    switch (type) {
      case AnnotationType.text:
        return AppColors.primaryIndigo600;
      case AnnotationType.image:
        return AppColors.successColor;
      case AnnotationType.audio:
        return AppColors.warningColor;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

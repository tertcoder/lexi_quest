import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_bloc.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_state.dart';
import 'package:lexi_quest/features/projects/bloc/projects_bloc.dart';
import 'package:lexi_quest/features/projects/bloc/projects_event.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';

/// Screen for selecting existing annotations to add to a project
class SelectAnnotationsScreen extends StatefulWidget {
  final Project project;

  const SelectAnnotationsScreen({
    super.key,
    required this.project,
  });

  @override
  State<SelectAnnotationsScreen> createState() => _SelectAnnotationsScreenState();
}

class _SelectAnnotationsScreenState extends State<SelectAnnotationsScreen> {
  String? _selectedAnnotationId; // Changed to single selection
  String _searchQuery = '';

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

  IconData _getTypeIcon(AnnotationType type) {
    switch (type) {
      case AnnotationType.text:
        return Icons.text_fields;
      case AnnotationType.image:
        return Icons.image;
      case AnnotationType.audio:
        return Icons.audiotrack;
    }
  }

  void _toggleSelection(String annotationId) {
    setState(() {
      // Single selection: if already selected, deselect; otherwise select this one
      if (_selectedAnnotationId == annotationId) {
        _selectedAnnotationId = null;
      } else {
        _selectedAnnotationId = annotationId;
      }
    });
  }

  void _addSelectedToProject() {
    if (_selectedAnnotationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an annotation'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Add the selected annotation to the project
    context.read<ProjectsBloc>().add(
      AddTaskToProject(
        projectId: widget.project.id,
        annotationId: _selectedAnnotationId!,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adding task to project...'),
        backgroundColor: AppColors.secondaryGreen500,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Modern Gradient Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTypeColor(widget.project.type),
                      _getTypeColor(widget.project.type).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
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
                        Expanded(
                          child: Text(
                            'Select Annotations',
                            style: AppFonts.headlineMedium.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (_selectedAnnotationId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '1 selected',
                              style: AppFonts.bodySmall.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose annotations to add to "${widget.project.name}"',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search annotations...',
                          hintStyle: AppFonts.bodyMedium.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.onPrimary,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Annotations List
              Expanded(
                child: BlocBuilder<AnnotationBloc, AnnotationState>(
                  builder: (context, state) {
                    if (state is AnnotationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryIndigo600,
                        ),
                      );
                    }

                    if (state is AnnotationError) {
                      return Center(
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
                              'Error loading annotations',
                              style: AppFonts.titleMedium.copyWith(
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
                          ],
                        ),
                      );
                    }

                    if (state is! AnnotationsLoaded) {
                      return const SizedBox();
                    }

                    // Filter annotations by search query
                    final filteredAnnotations = state.annotations.where((annotation) {
                      if (_searchQuery.isEmpty) return true;
                      return annotation.content
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          annotation.labels.any((label) =>
                              label.toLowerCase().contains(_searchQuery.toLowerCase()));
                    }).toList();

                    if (filteredAnnotations.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.neutralSlate600.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No annotations available'
                                  : 'No matching annotations',
                              style: AppFonts.titleMedium.copyWith(
                                color: AppColors.neutralSlate600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Create annotations first to add them to projects'
                                  : 'Try a different search term',
                              style: AppFonts.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredAnnotations.length,
                      itemBuilder: (context, index) {
                        final annotation = filteredAnnotations[index];
                        final isSelected = _selectedAnnotationId == annotation.id;

                        return _buildAnnotationCard(annotation, isSelected);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _selectedAnnotationId != null
            ? FloatingActionButton.extended(
                onPressed: _addSelectedToProject,
                backgroundColor: _getTypeColor(widget.project.type),
                icon: const Icon(Icons.add_task),
                label: Text(
                  'Add 1 Task',
                  style: AppFonts.buttonText.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              )
            : null,
      );
  }

  Widget _buildAnnotationCard(AnnotationModel annotation, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? _getTypeColor(widget.project.type)
              : AppColors.neutralSlate600_30,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleSelection(annotation.id),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getTypeColor(widget.project.type)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? _getTypeColor(widget.project.type)
                          : AppColors.neutralSlate600,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.onPrimary,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor(widget.project.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(widget.project.type),
                    color: _getTypeColor(widget.project.type),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        annotation.content.length > 60
                            ? '${annotation.content.substring(0, 60)}...'
                            : annotation.content,
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: annotation.labels.take(3).map((label) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(widget.project.type)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              label,
                              style: AppFonts.labelSmall.copyWith(
                                color: _getTypeColor(widget.project.type),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // XP Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryAmber500.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: AppColors.secondaryAmber500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${annotation.xpReward}',
                        style: AppFonts.labelSmall.copyWith(
                          color: AppColors.secondaryAmber500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

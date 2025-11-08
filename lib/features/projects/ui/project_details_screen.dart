import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';
import 'package:lexi_quest/features/projects/data/repositories/project_repository.dart';
import 'package:lexi_quest/features/projects/bloc/projects_bloc.dart';
import 'package:lexi_quest/features/projects/bloc/projects_event.dart';
import 'package:lexi_quest/features/projects/bloc/projects_state.dart';
import 'package:lexi_quest/features/projects/ui/widgets/export_dialog.dart';
import 'package:lexi_quest/routes.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';
import 'package:lexi_quest/features/projects/ui/select_annotations_screen.dart';
import 'package:lexi_quest/features/projects/ui/create_annotation_screen.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_bloc.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_event.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  int _selectedTabIndex = 0;

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

  void _startAnnotating(AnnotationType type, String projectId) {
    final queryParams = '?projectId=$projectId';
    switch (type) {
      case AnnotationType.text:
        context.push('${AppRoutes.textAnnotation}$queryParams');
        break;
      case AnnotationType.image:
        context.push('${AppRoutes.imageAnnotation}$queryParams');
        break;
      case AnnotationType.audio:
        context.push('${AppRoutes.audioAnnotation}$queryParams');
        break;
    }
  }

  List<ProjectTask> _getFilteredTasks(List<ProjectTask> tasks) {
    switch (_selectedTabIndex) {
      case 0: // All
        return tasks;
      case 1: // Pending
        return tasks.where((t) => t.annotatedBy == null).toList();
      case 2: // Completed
        return tasks.where((t) => t.annotatedBy != null).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsBloc()..add(LoadProjectDetails(projectId: widget.projectId)),
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryIndigo600,
                ),
              ),
            );
          }

          if (state is ProjectsError) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: Center(
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
                      'Error loading project',
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! ProjectDetailsLoaded) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final project = state.project;
          final tasks = state.tasks;
          final filteredTasks = _getFilteredTasks(tasks);
          final isOwner = project.ownerId == SupabaseConfig.currentUserId;

          return Scaffold(
            backgroundColor: AppColors.surface,
            body: SafeArea(
              child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getTypeColor(project.type),
                    _getTypeColor(project.type).withValues(alpha:0.8),
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
                          project.name,
                          style: AppFonts.titleLarge.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isOwner)
                            IconButton(
                              onPressed: () => _showAddTasksDialog(context, project),
                              icon: const Icon(
                                Icons.add_task,
                                color: AppColors.onPrimary,
                              ),
                              tooltip: 'Add Tasks',
                            ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ExportDialog(
                                  project: project,
                                  tasks: tasks,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.download,
                              color: AppColors.onPrimary,
                            ),
                            tooltip: 'Export Annotations',
                          ),
                          if (isOwner)
                            IconButton(
                              onPressed: () {
                                context.push('${AppRoutes.editProject}/${widget.projectId}');
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.onPrimary,
                              ),
                              tooltip: 'Edit Project',
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    project.description,
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.onPrimary.withValues(alpha:0.9),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    children: [
                      _buildStatChip(
                        Icons.assignment,
                        '${project.completedTasks}/${project.totalTasks}',
                        'Tasks',
                      ),
                      const SizedBox(width: 12),
                      _buildStatChip(
                        Icons.people,
                        '${project.contributors}',
                        'Contributors',
                      ),
                      const SizedBox(width: 12),
                      _buildStatChip(
                        Icons.star,
                        '${project.xpRewardPerTask}',
                        'XP/task',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Progress',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(project.completionPercentage * 100).toStringAsFixed(0)}%',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: project.completionPercentage,
                          backgroundColor: AppColors.neutralWhite.withValues(alpha:0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.neutralWhite,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Modern Pill-Style Tabs
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getTypeColor(project.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildPillTab('All (${tasks.length})', 0, project.type),
                  _buildPillTab('Pending (${tasks.where((t) => t.annotatedBy == null).length})', 1, project.type),
                  _buildPillTab('Done (${tasks.where((t) => t.annotatedBy != null).length})', 2, project.type),
                ],
              ),
            ),

            // Tasks List
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppColors.neutralSlate600.withValues(alpha:0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks in this category',
                            style: AppFonts.titleMedium.copyWith(
                              color: AppColors.neutralSlate600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(filteredTasks[index], isOwner, project.type, project.id);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startAnnotating(project.type, project.id),
        backgroundColor: _getTypeColor(project.type),
        icon: const Icon(Icons.play_arrow),
        label: Text(
          'Start Annotating',
          style: AppFonts.buttonText.copyWith(
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
        },
      ),
    );
  }

  Widget _buildPillTab(String label, int index, AnnotationType type) {
    final isSelected = _selectedTabIndex == index;
    final typeColor = _getTypeColor(type);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neutralWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: typeColor.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppFonts.bodySmall.copyWith(
              color: isSelected ? typeColor : AppColors.onBackground.withValues(alpha: 0.7),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.onPrimary,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: AppFonts.labelSmall.copyWith(
                  color: AppColors.onPrimary.withValues(alpha:0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(ProjectTask task, bool isOwner, AnnotationType type, String projectId) {
    final isCompleted = task.annotatedBy != null;
    final needsValidation = isCompleted && !task.isValidated && isOwner;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: needsValidation
              ? AppColors.secondaryAmber500
              : AppColors.neutralSlate600_30,
          width: needsValidation ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getTypeColor(type).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(type),
            color: _getTypeColor(type),
          ),
        ),
        title: Text(
          task.annotation.content.length > 50
              ? '${task.annotation.content.substring(0, 50)}...'
              : task.annotation.content,
          style: AppFonts.bodyMedium.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              if (isCompleted) ...[
                Icon(
                  task.isValidated ? Icons.verified : Icons.check_circle_outline,
                  size: 16,
                  color: task.isValidated
                      ? AppColors.secondaryGreen500
                      : AppColors.secondaryAmber500,
                ),
                const SizedBox(width: 4),
                Text(
                  task.isValidated ? 'Validated' : 'Needs Review',
                  style: AppFonts.bodySmall.copyWith(
                    color: task.isValidated
                        ? AppColors.secondaryGreen500
                        : AppColors.secondaryAmber500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.pending_outlined,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Pending',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryAmber500.withValues(alpha:0.1),
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
                      '+${task.annotation.xpReward}',
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
        trailing: needsValidation
            ? IconButton(
                onPressed: () => _showValidationDialog(task, projectId),
                icon: const Icon(
                  Icons.rate_review,
                  color: AppColors.secondaryAmber500,
                ),
              )
            : const Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant,
              ),
        onTap: () {
          if (needsValidation) {
            _showValidationDialog(task, projectId);
          } else if (!isCompleted) {
            _startAnnotating(type, projectId);
          }
        },
      ),
    );
  }

  void _showAddTasksDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Add Tasks to Project',
          style: AppFonts.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how to add tasks to your project:',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _buildAddTaskOption(
              dialogContext,
              project,
              icon: Icons.library_add,
              title: 'Select Existing',
              description: 'Choose from existing annotations',
              color: AppColors.primaryIndigo600,
              onTap: () {
                Navigator.pop(dialogContext);
                _navigateToSelectAnnotations(context, project);
              },
            ),
            const SizedBox(height: 12),
            _buildAddTaskOption(
              dialogContext,
              project,
              icon: Icons.add_circle,
              title: 'Create New',
              description: 'Create a new annotation task',
              color: AppColors.secondaryGreen500,
              onTap: () {
                Navigator.pop(dialogContext);
                _navigateToCreateAnnotation(context, project);
              },
            ),
            const SizedBox(height: 12),
            _buildAddTaskOption(
              dialogContext,
              project,
              icon: Icons.upload_file,
              title: 'Bulk Upload',
              description: 'Upload multiple tasks from file',
              color: AppColors.secondaryAmber500,
              onTap: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bulk upload feature coming soon!'),
                    backgroundColor: AppColors.primaryIndigo600,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppFonts.buttonText.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskOption(
    BuildContext context,
    Project project, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSelectAnnotations(BuildContext context, Project project) async {
    // Get the ProjectsBloc before navigation
    final projectsBloc = context.read<ProjectsBloc>();
    
    // Create a bloc that will load available annotations for this project
    final annotationBloc = AnnotationBloc()
      ..add(LoadAvailableAnnotationsForProject(
        projectId: project.id,
        type: project.type,
      ));
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: annotationBloc),
            BlocProvider.value(value: projectsBloc),
          ],
          child: SelectAnnotationsScreen(project: project),
        ),
      ),
    );
    
    // Close the bloc when done
    annotationBloc.close();
  }

  void _navigateToCreateAnnotation(BuildContext context, Project project) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AnnotationBloc(),
          child: CreateAnnotationScreen(
            type: project.type,
            projectId: project.id,
            projectXp: project.xpRewardPerTask,
          ),
        ),
      ),
    );
    
    if (result != null) {
      // Annotation was created, show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Annotation created! Now select it to add to your project.'),
            backgroundColor: AppColors.secondaryGreen500,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Navigate to select annotations screen with the new annotation visible
        _navigateToSelectAnnotations(context, project);
      }
    }
  }

  void _showValidationDialog(ProjectTask task, String projectId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'Validate Task',
          style: AppFonts.titleLarge.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review this completed task:',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutralSlate600_30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Content: ${task.annotation.content}',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (task.annotationData != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Answer: ${task.annotationData}',
                      style: AppFonts.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Do you want to approve or reject this task?',
              style: AppFonts.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: AppFonts.buttonText.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _validateTask(task.id, projectId, false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryRed500,
            ),
            child: Text(
              'Reject',
              style: AppFonts.buttonText.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _validateTask(task.id, projectId, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryGreen500,
            ),
            child: Text(
              'Approve',
              style: AppFonts.buttonText.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateTask(String taskId, String projectId, bool approved) async {
    try {
      final repository = ProjectRepository();
      await repository.validateTask(
        taskId: taskId,
        projectId: projectId,
        approved: approved,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              approved ? 'Task approved!' : 'Task rejected and reset.',
            ),
            backgroundColor: approved
                ? AppColors.secondaryGreen500
                : AppColors.secondaryAmber500,
          ),
        );

        // Reload project details
        context.read<ProjectsBloc>().add(LoadProjectDetails(projectId: projectId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

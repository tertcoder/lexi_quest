import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';
import 'package:lexi_quest/routes.dart';

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
  Project? _project;
  List<ProjectTask> _tasks = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProjectDetails();
  }

  Future<void> _loadProjectDetails() async {
    setState(() => _isLoading = true);

    try {
      // Load project
      final String projectsResponse = await rootBundle.loadString('assets/data/projects.json');
      final projectsData = json.decode(projectsResponse);
      final List<dynamic> projectsJson = projectsData['projects'];
      
      final projectJson = projectsJson.firstWhere(
        (p) => p['id'] == widget.projectId,
        orElse: () => null,
      );

      if (projectJson != null) {
        _project = Project.fromJson(projectJson);

        // Load tasks based on project type
        final String tasksResponse = await rootBundle.loadString('assets/data/sample_annotations.json');
        final tasksData = json.decode(tasksResponse);
        
        String taskKey = '${_project!.type.name}_annotations';
        final List<dynamic> annotationsJson = tasksData[taskKey] ?? [];

        // Create project tasks
        _tasks = annotationsJson.asMap().entries.map((entry) {
          final annotation = AnnotationModel.fromJson(entry.value);
          return ProjectTask(
            id: 'task_${entry.key}',
            projectId: widget.projectId,
            annotation: annotation,
            annotatedBy: entry.key % 3 == 0 ? 'user_007' : null,
            annotatedAt: entry.key % 3 == 0 ? DateTime.now().subtract(Duration(days: entry.key)) : null,
            isValidated: entry.key % 5 == 0,
            validatedBy: entry.key % 5 == 0 ? 'user_006' : null,
            validatedAt: entry.key % 5 == 0 ? DateTime.now().subtract(Duration(days: entry.key - 1)) : null,
          );
        }).toList();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error loading project details: $e');
      setState(() => _isLoading = false);
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

  void _startAnnotating() {
    if (_project == null) return;

    switch (_project!.type) {
      case AnnotationType.text:
        context.push(AppRoutes.textAnnotation);
        break;
      case AnnotationType.image:
        context.push(AppRoutes.imageAnnotation);
        break;
      case AnnotationType.audio:
        context.push(AppRoutes.audioAnnotation);
        break;
    }
  }

  List<ProjectTask> _getFilteredTasks() {
    switch (_selectedTabIndex) {
      case 0: // All
        return _tasks;
      case 1: // Pending
        return _tasks.where((t) => t.annotatedBy == null).toList();
      case 2: // Completed
        return _tasks.where((t) => t.annotatedBy != null).toList();
      default:
        return _tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryIndigo600,
          ),
        ),
      );
    }

    if (_project == null) {
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
                'Project not found',
                style: AppFonts.titleMedium.copyWith(
                  color: AppColors.onBackground,
                ),
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

    final isOwner = _project!.ownerId == 'user_006';
    final filteredTasks = _getFilteredTasks();

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
                    _getTypeColor(_project!.type),
                    _getTypeColor(_project!.type).withValues(alpha:0.8),
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
                          _project!.name,
                          style: AppFonts.titleLarge.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOwner)
                        IconButton(
                          onPressed: () {
                            // TODO: Edit project
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.onPrimary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    _project!.description,
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
                        '${_project!.completedTasks}/${_project!.totalTasks}',
                        'Tasks',
                      ),
                      const SizedBox(width: 12),
                      _buildStatChip(
                        Icons.people,
                        '${_project!.contributors}',
                        'Contributors',
                      ),
                      const SizedBox(width: 12),
                      _buildStatChip(
                        Icons.star,
                        '${_project!.xpRewardPerTask}',
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
                            '${(_project!.completionPercentage * 100).toStringAsFixed(0)}%',
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
                          value: _project!.completionPercentage,
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
                color: _getTypeColor(_project!.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildPillTab('All (${_tasks.length})', 0),
                  _buildPillTab('Pending (${_tasks.where((t) => t.annotatedBy == null).length})', 1),
                  _buildPillTab('Done (${_tasks.where((t) => t.annotatedBy != null).length})', 2),
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
                        return _buildTaskCard(filteredTasks[index], isOwner);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startAnnotating,
        backgroundColor: _getTypeColor(_project!.type),
        icon: const Icon(Icons.play_arrow),
        label: Text(
          'Start Annotating',
          style: AppFonts.buttonText.copyWith(
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPillTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    final typeColor = _getTypeColor(_project!.type);

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

  Widget _buildTaskCard(ProjectTask task, bool isOwner) {
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
            color: _getTypeColor(_project!.type).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(_project!.type),
            color: _getTypeColor(_project!.type),
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
                onPressed: () {
                  // TODO: Navigate to validation screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Validation feature coming soon!'),
                      backgroundColor: AppColors.primaryIndigo600,
                    ),
                  );
                },
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
            // Navigate to validation
          } else if (!isCompleted) {
            _startAnnotating();
          }
        },
      ),
    );
  }
}

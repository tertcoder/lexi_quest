import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/utils/app_assets.dart';
import '../bloc/annotation_bloc.dart';
import '../bloc/annotation_event.dart';
import '../bloc/annotation_state.dart';
import '../data/models/annotation_task_model.dart';
import 'annotation_workspace_screen.dart';
import 'annotation_history_screen.dart';

/// Annotation task list screen - shows available annotation tasks
class AnnotationListScreen extends StatefulWidget {
  const AnnotationListScreen({super.key});

  @override
  State<AnnotationListScreen> createState() => _AnnotationListScreenState();
}

class _AnnotationListScreenState extends State<AnnotationListScreen> {
  @override
  void initState() {
    super.initState();
    // Load annotation tasks when screen is initialized
    context.read<AnnotationBloc>().add(const LoadAnnotationTasks());
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotationListView();
  }
}

class AnnotationListView extends StatelessWidget {
  const AnnotationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Annotation Tasks',
          style: AppFonts.titleLarge.copyWith(color: AppColors.onBackground),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AnnotationHistoryScreen(),
                ),
              );
            },
            icon: Icon(Icons.history, color: AppColors.onBackground),
          ),
        ],
      ),
      body: BlocBuilder<AnnotationBloc, AnnotationState>(
        builder: (context, state) {
          if (state is AnnotationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnnotationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading tasks',
                    style: AppFonts.titleMedium.copyWith(
                      color: AppColors.error,
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AnnotationBloc>().add(
                        const LoadAnnotationTasks(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AnnotationTasksLoaded) {
            final pendingTasks =
                state.tasks
                    .where((task) => task.status == TaskStatus.pending)
                    .toList();
            final inProgressTasks =
                state.tasks
                    .where((task) => task.status == TaskStatus.inProgress)
                    .toList();

            if (pendingTasks.isEmpty && inProgressTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.illEmptyState,
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No tasks available',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for new annotation tasks',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AnnotationBloc>().add(const LoadAnnotationTasks());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // In Progress Tasks
                    if (inProgressTasks.isNotEmpty) ...[
                      Text(
                        'In Progress',
                        style: AppFonts.titleMedium.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...inProgressTasks.map(
                        (task) => TaskCard(
                          task: task,
                          onTap: () => _navigateToWorkspace(context, task),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Available Tasks
                    Text(
                      'Available Tasks',
                      style: AppFonts.titleMedium.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...pendingTasks.map(
                      (task) => TaskCard(
                        task: task,
                        onTap: () => _navigateToWorkspace(context, task),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToWorkspace(BuildContext context, AnnotationTask task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnnotationWorkspaceScreen(task: task),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final AnnotationTask task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(task.type).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        _getTypeIcon(task.type),
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          _getTypeColor(task.type),
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
                            task.title,
                            style: AppFonts.titleSmall.copyWith(
                              color: AppColors.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            task.type.displayName,
                            style: AppFonts.labelMedium.copyWith(
                              color: _getTypeColor(task.type),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (task.xpReward != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryAmber500.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${task.xpReward} XP',
                          style: AppFonts.labelSmall.copyWith(
                            color: AppColors.secondaryAmber500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  task.content.length > 100
                      ? '${task.content.substring(0, 100)}...'
                      : task.content,
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(task.createdAt),
                      style: AppFonts.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          task.status,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.status.displayName,
                        style: AppFonts.labelSmall.copyWith(
                          color: _getStatusColor(task.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppColors.neutralSlate600;
      case TaskStatus.inProgress:
        return AppColors.secondaryAmber500;
      case TaskStatus.completed:
        return AppColors.secondaryGreen500;
      case TaskStatus.reviewed:
        return AppColors.primaryIndigo600;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

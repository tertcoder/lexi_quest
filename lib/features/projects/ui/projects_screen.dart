import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';
import 'package:lexi_quest/features/projects/bloc/projects_bloc.dart';
import 'package:lexi_quest/features/projects/bloc/projects_event.dart';
import 'package:lexi_quest/features/projects/bloc/projects_state.dart';
import 'package:lexi_quest/routes.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _selectedTabIndex = 0;
  String _searchQuery = '';
  AnnotationType? _filterType;

  String get _currentFilter {
    switch (_selectedTabIndex) {
      case 0:
        return 'all';
      case 1:
        return 'owned';
      case 2:
        return 'contributed';
      default:
        return 'all';
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onTypeFilterChanged(AnnotationType? type) {
    setState(() {
      _filterType = type;
    });
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectsBloc()..add(LoadProjects(filter: _currentFilter)),
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          final projectsBloc = context.read<ProjectsBloc>();
          List<Project> projects = [];
          bool isLoading = false;
          String? errorMessage;

          if (state is ProjectsLoading) {
            isLoading = true;
          } else if (state is ProjectsLoaded) {
            projects = state.projects;
          } else if (state is ProjectsError) {
            errorMessage = state.message;
          }

          // Apply local filters (search and type)
          final filteredProjects = projects.where((project) {
            bool matchesSearch = _searchQuery.isEmpty ||
                project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                project.description.toLowerCase().contains(_searchQuery.toLowerCase());

            bool matchesType = _filterType == null ||
                project.type == _filterType;

            return matchesSearch && matchesType;
          }).toList();

          return Scaffold(
            backgroundColor: AppColors.surface,
            body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryIndigo600, AppColors.primaryIndigo500],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Projects',
                        style: AppFonts.headlineMedium.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(AppRoutes.createProject);
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.onPrimary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: _onSearchChanged,
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.onPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search projects...',
                        hintStyle: AppFonts.bodyMedium.copyWith(
                          color: AppColors.onPrimary.withValues(alpha:0.7),
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
                  const SizedBox(height: 16),

                  // Modern Pill-Style Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        _buildPillTab('All', 0, projectsBloc),
                        _buildPillTab('My Projects', 1, projectsBloc),
                        _buildPillTab('Contributed', 2, projectsBloc),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Type Filters
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTypeFilter(null, 'All', Icons.grid_view),
                    const SizedBox(width: 8),
                    _buildTypeFilter(AnnotationType.text, 'Text', Icons.text_fields),
                    const SizedBox(width: 8),
                    _buildTypeFilter(AnnotationType.image, 'Image', Icons.image),
                    const SizedBox(width: 8),
                    _buildTypeFilter(AnnotationType.audio, 'Audio', Icons.audiotrack),
                  ],
                ),
              ),
            ),

            // Projects List
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryIndigo600,
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 64, color: AppColors.secondaryRed500),
                              const SizedBox(height: 16),
                              Text('Error loading projects', style: AppFonts.titleLarge),
                              const SizedBox(height: 8),
                              Text(errorMessage, style: AppFonts.bodyMedium, textAlign: TextAlign.center),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => context.read<ProjectsBloc>().add(LoadProjects(filter: _currentFilter)),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredProjects.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 64,
                                color: AppColors.neutralSlate600.withValues(alpha:0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No projects found',
                                style: AppFonts.titleMedium.copyWith(
                                  color: AppColors.neutralSlate600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedTabIndex == 1
                                    ? 'Create your first project!'
                                    : 'Try adjusting your filters',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<ProjectsBloc>().add(LoadProjects(filter: _currentFilter));
                          },
                          color: AppColors.primaryIndigo600,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredProjects.length,
                            itemBuilder: (context, index) {
                              return _buildProjectCard(filteredProjects[index]);
                            },
                          ),
                        ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
        },
      ),
    );
  }

  Widget _buildPillTab(String label, int index, ProjectsBloc bloc) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          bloc.add(LoadProjects(filter: _currentFilter));
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
                      color: AppColors.neutralSlate900_25.withValues(alpha:0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppFonts.bodyMedium.copyWith(
              color: isSelected ? AppColors.primaryIndigo600 : AppColors.onPrimary.withValues(alpha:0.9),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilter(AnnotationType? type, String label, IconData icon) {
    final isSelected = _filterType == type;
    final color = type != null ? _getTypeColor(type) : AppColors.neutralSlate600;

    return GestureDetector(
      onTap: () => _onTypeFilterChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.neutralSlate600_30,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.onPrimary : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppFonts.bodyMedium.copyWith(
                color: isSelected ? AppColors.onPrimary : AppColors.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    final isOwner = project.ownerId == 'user_006';

    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.projectDetails}/${project.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOwner
                ? AppColors.primaryIndigo600.withValues(alpha:0.3)
                : AppColors.neutralSlate600_30,
            width: isOwner ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutralSlate900_25.withValues(alpha:0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail or Header
            if (project.thumbnailUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  project.thumbnailUrl!,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: _getTypeColor(project.type).withValues(alpha:0.1),
                      child: Center(
                        child: Icon(
                          _getTypeIcon(project.type),
                          size: 48,
                          color: _getTypeColor(project.type),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTypeColor(project.type),
                      _getTypeColor(project.type).withValues(alpha:0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getTypeIcon(project.type),
                    size: 40,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Owner Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: AppFonts.titleMedium.copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOwner)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryIndigo600,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Owner',
                            style: AppFonts.labelSmall.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    project.description,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: AppFonts.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${project.completedTasks}/${project.totalTasks}',
                            style: AppFonts.labelSmall.copyWith(
                              color: AppColors.onBackground,
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
                          backgroundColor: AppColors.neutralSlate600_30,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getTypeColor(project.type),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Stats Row
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${project.contributors}',
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.star_outline,
                        size: 16,
                        color: AppColors.secondaryAmber500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${project.xpRewardPerTask} XP/task',
                        style: AppFonts.bodySmall.copyWith(
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
                          color: _getTypeColor(project.type).withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          project.type.name.toUpperCase(),
                          style: AppFonts.labelSmall.copyWith(
                            color: _getTypeColor(project.type),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tags
                  if (project.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: project.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutralSlate600_30,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#$tag',
                            style: AppFonts.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

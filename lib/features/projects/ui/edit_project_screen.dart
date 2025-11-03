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

class EditProjectScreen extends StatefulWidget {
  final String projectId;

  const EditProjectScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  AnnotationType _selectedType = AnnotationType.text;
  int _xpPerTask = 15;
  final List<String> _tags = [];
  final _tagController = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _initializeForm(Project project) {
    if (!_isInitialized) {
      _nameController.text = project.name;
      _descriptionController.text = project.description;
      _selectedType = project.type;
      _xpPerTask = project.xpRewardPerTask;
      _tags.addAll(project.tags);
      _isInitialized = true;
    }
  }

  void _updateProject(BuildContext context, Project currentProject) {
    if (!_formKey.currentState!.validate()) return;

    final updatedProject = Project(
      id: currentProject.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      ownerId: currentProject.ownerId,
      ownerName: currentProject.ownerName,
      ownerAvatar: currentProject.ownerAvatar,
      type: _selectedType,
      status: currentProject.status,
      visibility: currentProject.visibility,
      totalTasks: currentProject.totalTasks,
      completedTasks: currentProject.completedTasks,
      validatedTasks: currentProject.validatedTasks,
      contributors: currentProject.contributors,
      xpRewardPerTask: _xpPerTask,
      tags: _tags,
      thumbnailUrl: currentProject.thumbnailUrl,
      createdAt: currentProject.createdAt,
      updatedAt: DateTime.now(),
    );

    context.read<ProjectsBloc>().add(UpdateProject(project: updatedProject));
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
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
      create: (context) => ProjectsBloc()..add(LoadProjectDetails(projectId: widget.projectId)),
      child: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Project updated successfully!'),
                backgroundColor: AppColors.secondaryGreen500,
              ),
            );
            context.pop();
          } else if (state is ProjectsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.secondaryRed500,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              appBar: AppBar(
                backgroundColor: AppColors.primaryIndigo600,
                title: const Text('Edit Project'),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is! ProjectDetailsLoaded) {
            return Scaffold(
              backgroundColor: AppColors.surface,
              appBar: AppBar(
                backgroundColor: AppColors.primaryIndigo600,
                title: const Text('Edit Project'),
              ),
              body: const Center(child: Text('Loading project...')),
            );
          }

          final project = state.project;
          _initializeForm(project);

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
                                'Edit Project',
                                style: AppFonts.headlineMedium.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Update your project details',
                          style: AppFonts.bodyMedium.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      
                            // Project Name
                            Text(
                              'Project Name',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              style: AppFonts.bodyMedium.copyWith(
                                color: AppColors.onBackground,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter project name',
                                hintStyle: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                filled: true,
                                fillColor: AppColors.background,
                                prefixIcon: const Icon(
                                  Icons.folder,
                                  color: AppColors.primaryIndigo600,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.neutralSlate600_30,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryIndigo600,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a project name';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(height: 24),
                      
                            // Description
                            Text(
                              'Description',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              style: AppFonts.bodyMedium.copyWith(
                                color: AppColors.onBackground,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter project description',
                                hintStyle: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.neutralSlate600_30,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryIndigo600,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(height: 24),
                      
                            // Type Selection
                            Text(
                              'Annotation Type',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTypeCard(AnnotationType.text),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTypeCard(AnnotationType.image),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTypeCard(AnnotationType.audio),
                                ),
                              ],
                            ),
                      const SizedBox(height: 24),
                      
                            // XP Reward
                            Text(
                              'XP Reward per Task',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.neutralSlate600_30,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'XP Value',
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryAmber500.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 16,
                                              color: AppColors.secondaryAmber500,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '$_xpPerTask XP',
                                              style: AppFonts.titleSmall.copyWith(
                                                color: AppColors.secondaryAmber500,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _xpPerTask.toDouble(),
                                    min: 5,
                                    max: 50,
                                    divisions: 9,
                                    label: '$_xpPerTask XP',
                                    activeColor: AppColors.primaryIndigo600,
                                    onChanged: (value) {
                                      setState(() {
                                        _xpPerTask = value.toInt();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 24),
                      
                            // Tags
                            Text(
                              'Tags',
                              style: AppFonts.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _tagController,
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.onBackground,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Add tag',
                                      hintStyle: AppFonts.bodyMedium.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.background,
                                      prefixIcon: const Icon(
                                        Icons.label,
                                        color: AppColors.primaryIndigo600,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.neutralSlate600_30,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryIndigo600,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryIndigo600,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: _addTag,
                                    icon: const Icon(Icons.add),
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            if (_tags.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _tags.map((tag) {
                                  return Chip(
                                    label: Text(
                                      tag,
                                      style: AppFonts.bodySmall.copyWith(
                                        color: AppColors.primaryIndigo600,
                                      ),
                                    ),
                                    backgroundColor: AppColors.primaryIndigo600.withValues(alpha: 0.1),
                                    deleteIconColor: AppColors.primaryIndigo600,
                                    onDeleted: () => _removeTag(tag),
                                    deleteIcon: const Icon(Icons.close, size: 18),
                                    side: BorderSide(
                                      color: AppColors.primaryIndigo600.withValues(alpha: 0.3),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                            const SizedBox(height: 32),
                            
                            // Update Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _updateProject(context, project),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryIndigo600,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.onPrimary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Update Project',
                                      style: AppFonts.buttonText.copyWith(
                                        color: AppColors.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
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

  Widget _buildTypeCard(AnnotationType type) {
    final isSelected = _selectedType == type;
    final color = _getTypeColor(type);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.neutralSlate600_30,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getTypeIcon(type),
              color: isSelected ? color : AppColors.neutralSlate600,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              type.name.toUpperCase(),
              style: AppFonts.bodySmall.copyWith(
                color: isSelected ? color : AppColors.neutralSlate600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

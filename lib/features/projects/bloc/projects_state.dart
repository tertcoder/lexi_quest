import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';

/// Projects states
abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

/// Loading state
class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

/// Loaded state
class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;

  const ProjectsLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

/// Project details loaded state
class ProjectDetailsLoaded extends ProjectsState {
  final Project project;
  final List<ProjectTask> tasks;

  const ProjectDetailsLoaded({
    required this.project,
    required this.tasks,
  });

  @override
  List<Object?> get props => [project, tasks];
}

/// Error state
class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Project created state
class ProjectCreated extends ProjectsState {
  final Project project;

  const ProjectCreated({required this.project});

  @override
  List<Object?> get props => [project];
}

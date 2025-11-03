import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';

/// Projects events
abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

/// Load projects event
class LoadProjects extends ProjectsEvent {
  final String filter; // 'all', 'owned', 'contributed'

  const LoadProjects({this.filter = 'all'});

  @override
  List<Object?> get props => [filter];
}

/// Create project event
class CreateProject extends ProjectsEvent {
  final Project project;

  const CreateProject({required this.project});

  @override
  List<Object?> get props => [project];
}

/// Update project event
class UpdateProject extends ProjectsEvent {
  final Project project;

  const UpdateProject({required this.project});

  @override
  List<Object?> get props => [project];
}

/// Delete project event
class DeleteProject extends ProjectsEvent {
  final String projectId;

  const DeleteProject({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

/// Load project details event
class LoadProjectDetails extends ProjectsEvent {
  final String projectId;

  const LoadProjectDetails({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

/// Add task to project event
class AddTaskToProject extends ProjectsEvent {
  final String projectId;
  final String annotationId;

  const AddTaskToProject({
    required this.projectId,
    required this.annotationId,
  });

  @override
  List<Object?> get props => [projectId, annotationId];
}

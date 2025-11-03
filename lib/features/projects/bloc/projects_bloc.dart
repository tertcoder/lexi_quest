import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/features/projects/bloc/projects_event.dart';
import 'package:lexi_quest/features/projects/bloc/projects_state.dart';
import 'package:lexi_quest/features/projects/data/repositories/project_repository.dart';

/// Projects BLoC
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository _projectRepository;

  ProjectsBloc({ProjectRepository? projectRepository})
      : _projectRepository = projectRepository ?? ProjectRepository(),
        super(const ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<CreateProject>(_onCreateProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<LoadProjectDetails>(_onLoadProjectDetails);
    on<AddTaskToProject>(_onAddTaskToProject);
  }

  /// Handle load projects
  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      final projects = await _projectRepository.getProjects(filter: event.filter);
      emit(ProjectsLoaded(projects: projects));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  /// Handle create project
  Future<void> _onCreateProject(
    CreateProject event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      final project = await _projectRepository.createProject(event.project);
      emit(ProjectCreated(project: project));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  /// Handle update project
  Future<void> _onUpdateProject(
    UpdateProject event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      await _projectRepository.updateProject(event.project);
      add(const LoadProjects());
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  /// Handle delete project
  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      await _projectRepository.deleteProject(event.projectId);
      add(const LoadProjects());
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  /// Handle load project details
  Future<void> _onLoadProjectDetails(
    LoadProjectDetails event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      final project = await _projectRepository.getProject(event.projectId);
      final tasks = await _projectRepository.getProjectTasks(event.projectId);
      emit(ProjectDetailsLoaded(project: project, tasks: tasks));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  /// Handle add task to project
  Future<void> _onAddTaskToProject(
    AddTaskToProject event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      await _projectRepository.addTaskToProject(
        event.projectId,
        event.annotationId,
      );
      // Reload project details to show the new task
      add(LoadProjectDetails(projectId: event.projectId));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }
}

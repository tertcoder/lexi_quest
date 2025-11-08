import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_event.dart';
import 'package:lexi_quest/features/annotation/bloc/annotation_state.dart';
import 'package:lexi_quest/features/annotation/data/repositories/annotation_repository.dart';

/// Annotation BLoC
class AnnotationBloc extends Bloc<AnnotationEvent, AnnotationState> {
  final AnnotationRepository _annotationRepository;

  AnnotationBloc({AnnotationRepository? annotationRepository})
      : _annotationRepository = annotationRepository ?? AnnotationRepository(),
        super(const AnnotationInitial()) {
    on<LoadAnnotations>(_onLoadAnnotations);
    on<LoadAvailableAnnotationsForProject>(_onLoadAvailableAnnotationsForProject);
    on<LoadAnnotationsFromProjectTasks>(_onLoadAnnotationsFromProjectTasks);
    on<LoadAllUnannotatedProjectTasks>(_onLoadAllUnannotatedProjectTasks);
    on<SubmitAnnotation>(_onSubmitAnnotation);
    on<UploadAnnotationImage>(_onUploadAnnotationImage);
    on<UploadAnnotationAudio>(_onUploadAnnotationAudio);
    on<CreateAnnotation>(_onCreateAnnotation);
  }

  /// Handle load annotations
  Future<void> _onLoadAnnotations(
    LoadAnnotations event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final annotations = await _annotationRepository.getAnnotations(
        type: event.type,
        limit: event.limit,
      );
      emit(AnnotationsLoaded(annotations: annotations));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle load available annotations for project
  Future<void> _onLoadAvailableAnnotationsForProject(
    LoadAvailableAnnotationsForProject event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final annotations = await _annotationRepository.getAvailableAnnotationsForProject(
        projectId: event.projectId,
        type: event.type,
        limit: event.limit,
      );
      emit(AnnotationsLoaded(annotations: annotations));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle load annotations from project tasks
  Future<void> _onLoadAnnotationsFromProjectTasks(
    LoadAnnotationsFromProjectTasks event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final annotations = await _annotationRepository.getAnnotationsFromProjectTasks(
        projectId: event.projectId,
        type: event.type,
      );
      emit(AnnotationsLoaded(annotations: annotations));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle load all unannotated project tasks
  Future<void> _onLoadAllUnannotatedProjectTasks(
    LoadAllUnannotatedProjectTasks event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final annotations = await _annotationRepository.getAllUnannotatedProjectTasks(
        type: event.type,
        limit: event.limit,
      );
      emit(AnnotationsLoaded(annotations: annotations));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle submit annotation
  Future<void> _onSubmitAnnotation(
    SubmitAnnotation event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      await _annotationRepository.submitAnnotation(
        annotationId: event.annotationId,
        projectId: event.projectId,
        data: event.data,
        xpEarned: event.xpEarned,
      );
      emit(AnnotationSubmitted(xpEarned: event.xpEarned));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle upload annotation image
  Future<void> _onUploadAnnotationImage(
    UploadAnnotationImage event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final url = await _annotationRepository.uploadAnnotationImage(event.filePath);
      emit(FileUploaded(url: url));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle upload annotation audio
  Future<void> _onUploadAnnotationAudio(
    UploadAnnotationAudio event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final url = await _annotationRepository.uploadAnnotationAudio(event.filePath);
      emit(FileUploaded(url: url));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }

  /// Handle create annotation
  Future<void> _onCreateAnnotation(
    CreateAnnotation event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());
    try {
      final annotation = await _annotationRepository.createAnnotation(event.annotation);
      emit(AnnotationCreated(annotation: annotation));
    } catch (e) {
      emit(AnnotationError(message: e.toString()));
    }
  }
}

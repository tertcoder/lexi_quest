import 'annotation_task_model.dart';

/// Completed annotation result model
class CompletedAnnotation {
  final String id;
  final String taskId;
  final String userId;
  final String title;
  final String description;
  final AnnotationType type;
  final List<AnnotationLabel> labels;
  final DateTime completedAt;
  final int xpEarned;
  final double accuracy;
  final int labelsAdded;
  final int timeSpent; // in minutes

  const CompletedAnnotation({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.labels,
    required this.completedAt,
    required this.xpEarned,
    required this.accuracy,
    required this.labelsAdded,
    required this.timeSpent,
  });

  CompletedAnnotation copyWith({
    String? id,
    String? taskId,
    String? userId,
    String? title,
    String? description,
    AnnotationType? type,
    List<AnnotationLabel>? labels,
    DateTime? completedAt,
    int? xpEarned,
    double? accuracy,
    int? labelsAdded,
    int? timeSpent,
  }) {
    return CompletedAnnotation(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      labels: labels ?? this.labels,
      completedAt: completedAt ?? this.completedAt,
      xpEarned: xpEarned ?? this.xpEarned,
      accuracy: accuracy ?? this.accuracy,
      labelsAdded: labelsAdded ?? this.labelsAdded,
      timeSpent: timeSpent ?? this.timeSpent,
    );
  }
}

/// Individual annotation label/tag
class AnnotationLabel {
  final String id;
  final String text;
  final int startPosition;
  final int endPosition;
  final String category;
  final double confidence;

  const AnnotationLabel({
    required this.id,
    required this.text,
    required this.startPosition,
    required this.endPosition,
    required this.category,
    required this.confidence,
  });

  AnnotationLabel copyWith({
    String? id,
    String? text,
    int? startPosition,
    int? endPosition,
    String? category,
    double? confidence,
  }) {
    return AnnotationLabel(
      id: id ?? this.id,
      text: text ?? this.text,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
    );
  }
}

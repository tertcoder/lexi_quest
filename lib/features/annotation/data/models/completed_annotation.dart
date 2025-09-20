import 'annotation_task_model.dart';

class CompletedAnnotation {
  final String id;
  final String title;
  final String description;
  final AnnotationType type;
  final String content;
  final List<String> labels;
  final DateTime completedAt;
  final int timeSpent; // in minutes
  final int xpEarned;
  final int labelsAdded;

  const CompletedAnnotation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.content,
    required this.labels,
    required this.completedAt,
    required this.timeSpent,
    required this.xpEarned,
    required this.labelsAdded,
  });

  CompletedAnnotation copyWith({
    String? id,
    String? title,
    String? description,
    AnnotationType? type,
    String? content,
    List<String>? labels,
    DateTime? completedAt,
    int? timeSpent,
    int? xpEarned,
    int? labelsAdded,
  }) {
    return CompletedAnnotation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      content: content ?? this.content,
      labels: labels ?? this.labels,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      xpEarned: xpEarned ?? this.xpEarned,
      labelsAdded: labelsAdded ?? this.labelsAdded,
    );
  }
}

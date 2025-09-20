/// Annotation task model representing a task to be annotated
class AnnotationTask {
  final String id;
  final String title;
  final String content;
  final AnnotationType type;
  final String? imageUrl;
  final String? audioUrl;
  final DateTime createdAt;
  final TaskStatus status;
  final int? xpReward;

  const AnnotationTask({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.imageUrl,
    this.audioUrl,
    required this.createdAt,
    required this.status,
    this.xpReward,
  });

  AnnotationTask copyWith({
    String? id,
    String? title,
    String? content,
    AnnotationType? type,
    String? imageUrl,
    String? audioUrl,
    DateTime? createdAt,
    TaskStatus? status,
    int? xpReward,
  }) {
    return AnnotationTask(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      xpReward: xpReward ?? this.xpReward,
    );
  }
}

/// Types of annotation tasks
enum AnnotationType { text, image, audio }

/// Status of annotation tasks
enum TaskStatus { pending, inProgress, completed, reviewed }

/// Extension to get display names
extension AnnotationTypeExtension on AnnotationType {
  String get displayName {
    switch (this) {
      case AnnotationType.text:
        return 'Text';
      case AnnotationType.image:
        return 'Image';
      case AnnotationType.audio:
        return 'Audio';
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.reviewed:
        return 'Reviewed';
    }
  }
}

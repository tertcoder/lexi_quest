import 'package:equatable/equatable.dart';

/// Represents different types of annotations
enum AnnotationType {
  text,
  image,
  audio,
}

/// Represents an annotation task
class AnnotationModel extends Equatable {
  final String id;
  final AnnotationType type;
  final String content;
  final String? imageUrl;
  final String? audioUrl;
  final List<String> labels;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final int xpReward;

  const AnnotationModel({
    required this.id,
    required this.type,
    required this.content,
    this.imageUrl,
    this.audioUrl,
    required this.labels,
    this.metadata,
    required this.createdAt,
    this.xpReward = 10,
  });

  factory AnnotationModel.fromJson(Map<String, dynamic> json) {
    return AnnotationModel(
      id: json['id'] as String,
      type: AnnotationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnnotationType.text,
      ),
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      xpReward: json['xpReward'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'labels': labels,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'xpReward': xpReward,
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        content,
        imageUrl,
        audioUrl,
        labels,
        metadata,
        createdAt,
        xpReward,
      ];
}

/// Represents a completed annotation submission
class AnnotationSubmission extends Equatable {
  final String annotationId;
  final String userId;
  final Map<String, dynamic> data;
  final DateTime submittedAt;
  final int xpEarned;

  const AnnotationSubmission({
    required this.annotationId,
    required this.userId,
    required this.data,
    required this.submittedAt,
    required this.xpEarned,
  });

  @override
  List<Object?> get props => [
        annotationId,
        userId,
        data,
        submittedAt,
        xpEarned,
      ];
}

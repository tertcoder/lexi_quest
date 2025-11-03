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
  final String? instructions;
  final String? imageUrl;
  final String? audioUrl;
  final List<String> labels;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final int xpReward;
  final String? createdBy;

  const AnnotationModel({
    required this.id,
    required this.type,
    required this.content,
    this.instructions,
    this.imageUrl,
    this.audioUrl,
    required this.labels,
    this.metadata,
    required this.createdAt,
    this.xpReward = 10,
    this.createdBy,
  });

  factory AnnotationModel.fromJson(Map<String, dynamic> json) {
    return AnnotationModel(
      id: json['id'] as String,
      type: AnnotationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnnotationType.text,
      ),
      content: json['content'] as String,
      instructions: json['instructions'] as String?,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      xpReward: json['xp_reward'] as int? ?? 10,
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'type': type.name,
      'content': content,
      'instructions': instructions,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'labels': labels,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'xp_reward': xpReward,
      'created_by': createdBy,
    };
    
    // Only include id if it's not empty (for updates)
    if (id.isNotEmpty) {
      json['id'] = id;
    }
    
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        content,
        instructions,
        imageUrl,
        audioUrl,
        labels,
        metadata,
        createdAt,
        xpReward,
        createdBy,
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

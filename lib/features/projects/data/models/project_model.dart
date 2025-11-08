import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';

/// Project status enum
enum ProjectStatus {
  active,
  completed,
  paused,
  draft,
}

/// Project visibility
enum ProjectVisibility {
  public_,
  private_,
  unlisted,
}

/// Represents a dataset/project for annotation
class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String ownerName;
  final String? ownerAvatar;
  final AnnotationType type;
  final ProjectStatus status;
  final ProjectVisibility visibility;
  final int totalTasks;
  final int completedTasks;
  final int validatedTasks;
  final int contributors;
  final int xpRewardPerTask;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? thumbnailUrl;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    this.ownerAvatar,
    required this.type,
    this.status = ProjectStatus.active,
    this.visibility = ProjectVisibility.public_,
    required this.totalTasks,
    this.completedTasks = 0,
    this.validatedTasks = 0,
    this.contributors = 0,
    this.xpRewardPerTask = 10,
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
    this.thumbnailUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ownerId: json['owner_id'] as String,
      ownerName: json['owner_name'] as String? ?? '',
      ownerAvatar: json['owner_avatar'] as String?,
      type: AnnotationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnnotationType.text,
      ),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.active,
      ),
      visibility: ProjectVisibility.values.firstWhere(
        (e) => e.name == json['visibility'],
        orElse: () => ProjectVisibility.public_,
      ),
      totalTasks: json['total_tasks'] as int? ?? 0,
      completedTasks: json['completed_tasks'] as int? ?? 0,
      validatedTasks: json['validated_tasks'] as int? ?? 0,
      contributors: json['contributors'] as int? ?? 0,
      xpRewardPerTask: json['xp_reward_per_task'] as int? ?? 10,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'description': description,
      'owner_id': ownerId,
      'type': type.name,
      'status': status.name,
      'visibility': visibility.name,
      'total_tasks': totalTasks,
      'completed_tasks': completedTasks,
      'validated_tasks': validatedTasks,
      'contributors': contributors,
      'xp_reward_per_task': xpRewardPerTask,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'thumbnail_url': thumbnailUrl,
    };
    
    // Only include id if it's not empty (for updates)
    if (id.isNotEmpty) {
      json['id'] = id;
    }
    
    return json;
  }

  /// Calculate completion percentage
  double get completionPercentage {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  /// Calculate validation percentage
  double get validationPercentage {
    if (completedTasks == 0) return 0.0;
    return validatedTasks / completedTasks;
  }

  /// Check if user is owner
  bool isOwner(String userId) => ownerId == userId;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        ownerId,
        ownerName,
        ownerAvatar,
        type,
        status,
        visibility,
        totalTasks,
        completedTasks,
        validatedTasks,
        contributors,
        xpRewardPerTask,
        tags,
        createdAt,
        updatedAt,
        thumbnailUrl,
      ];
}

/// Represents a task within a project
class ProjectTask extends Equatable {
  final String id;
  final String projectId;
  final AnnotationModel annotation;
  final String? annotatedBy;
  final DateTime? annotatedAt;
  final bool isValidated;
  final String? validatedBy;
  final DateTime? validatedAt;
  final Map<String, dynamic>? annotationData;
  final String validationStatus; // 'pending', 'approved', 'rejected'

  const ProjectTask({
    required this.id,
    required this.projectId,
    required this.annotation,
    this.annotatedBy,
    this.annotatedAt,
    this.isValidated = false,
    this.validatedBy,
    this.validatedAt,
    this.annotationData,
    this.validationStatus = 'pending',
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase and snake_case
    final annotationJson = json['annotation'] ?? json['annotations'];
    
    if (annotationJson == null) {
      throw Exception('ProjectTask requires an annotation');
    }
    
    return ProjectTask(
      id: json['id'] as String,
      projectId: (json['project_id'] ?? json['projectId']) as String,
      annotation: AnnotationModel.fromJson(annotationJson as Map<String, dynamic>),
      annotatedBy: (json['annotated_by'] ?? json['annotatedBy']) as String?,
      annotatedAt: (json['annotated_at'] ?? json['annotatedAt']) != null 
          ? DateTime.parse((json['annotated_at'] ?? json['annotatedAt']) as String) 
          : null,
      isValidated: (json['is_validated'] ?? json['isValidated']) as bool? ?? false,
      validatedBy: (json['validated_by'] ?? json['validatedBy']) as String?,
      validatedAt: (json['validated_at'] ?? json['validatedAt']) != null 
          ? DateTime.parse((json['validated_at'] ?? json['validatedAt']) as String) 
          : null,
      annotationData: (json['annotation_data'] ?? json['annotationData']) as Map<String, dynamic>?,
      validationStatus: (json['validation_status'] ?? json['validationStatus']) as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'annotation': annotation.toJson(),
      'annotatedBy': annotatedBy,
      'annotatedAt': annotatedAt?.toIso8601String(),
      'isValidated': isValidated,
      'validatedBy': validatedBy,
      'validatedAt': validatedAt?.toIso8601String(),
      'annotationData': annotationData,
      'validationStatus': validationStatus,
    };
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        annotation,
        annotatedBy,
        annotatedAt,
        isValidated,
        validatedBy,
        validatedAt,
        annotationData,
        validationStatus,
      ];
}

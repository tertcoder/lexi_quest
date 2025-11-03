import 'dart:io';
import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';

/// Annotation repository
class AnnotationRepository extends BaseRepository {
  /// Get annotations by type
  Future<List<AnnotationModel>> getAnnotations({
    AnnotationType? type,
    int limit = 20,
  }) async {
    return handleError(() async {
      var query = client.from('annotations').select();
      
      if (type != null) {
        query = query.eq('type', type.name);
      }
      
      final response = await query.limit(limit);
      
      return (response as List)
          .map((json) => AnnotationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  /// Get available annotations for a project (only created by current user and not yet assigned)
  Future<List<AnnotationModel>> getAvailableAnnotationsForProject({
    required String projectId,
    required AnnotationType type,
    int limit = 50,
  }) async {
    return handleError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');

      // Get all annotation IDs already assigned to this project
      final assignedTasks = await client
          .from('project_tasks')
          .select('annotation_id')
          .eq('project_id', projectId);

      final assignedIds = (assignedTasks as List)
          .map((task) => task['annotation_id'] as String)
          .toList();

      // Get annotations created by current user that match type
      var query = client
          .from('annotations')
          .select()
          .eq('type', type.name)
          .eq('created_by', userId); // Only show annotations created by current user

      // Exclude annotations already assigned to this project
      if (assignedIds.isNotEmpty) {
        query = query.not('id', 'in', '(${assignedIds.join(',')})');
      }

      final response = await query.limit(limit).order('created_at', ascending: false);

      return (response as List)
          .map((json) => AnnotationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }
  
  /// Get annotation by ID
  Future<AnnotationModel> getAnnotation(String annotationId) async {
    return handleError(() async {
      final response = await client
          .from('annotations')
          .select()
          .eq('id', annotationId)
          .single();
      
      return AnnotationModel.fromJson(response);
    });
  }

  /// Get annotations from project tasks (for annotation screens)
  Future<List<AnnotationModel>> getAnnotationsFromProjectTasks({
    required String projectId,
    required AnnotationType type,
  }) async {
    return handleError(() async {
      // Get unannotated tasks for this project
      final response = await client
          .from('project_tasks')
          .select('annotations(*)')
          .eq('project_id', projectId)
          .isFilter('annotated_by', null); // Only unannotated tasks

      return (response as List)
          .map((task) {
            final annotationJson = task['annotations'] as Map<String, dynamic>;
            return AnnotationModel.fromJson(annotationJson);
          })
          .where((annotation) => annotation.type == type)
          .toList();
    });
  }
  
  /// Submit annotation
  Future<void> submitAnnotation({
    required String annotationId,
    String? projectId,
    required Map<String, dynamic> data,
    required int xpEarned,
  }) async {
    return handleVoidError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');
      
      await client.rpc('submit_annotation', params: {
        'p_annotation_id': annotationId,
        'p_project_id': projectId,
        'p_user_id': userId,
        'p_data': data,
        'p_xp_earned': xpEarned,
      });
    });
  }
  
  /// Create annotation
  Future<AnnotationModel> createAnnotation(AnnotationModel annotation) async {
    return handleError(() async {
      final response = await client
          .from('annotations')
          .insert(annotation.toJson())
          .select()
          .single();
      
      return AnnotationModel.fromJson(response);
    });
  }
  
  /// Upload annotation image
  Future<String> uploadAnnotationImage(String filePath) async {
    return handleError(() async {
      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await client.storage
          .from('annotation-images')
          .upload(fileName, file);
      
      return client.storage
          .from('annotation-images')
          .getPublicUrl(fileName);
    });
  }
  
  /// Upload annotation audio
  Future<String> uploadAnnotationAudio(String filePath) async {
    return handleError(() async {
      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp3';
      
      await client.storage
          .from('annotation-audio')
          .upload(fileName, file);
      
      return client.storage
          .from('annotation-audio')
          .getPublicUrl(fileName);
    });
  }
}

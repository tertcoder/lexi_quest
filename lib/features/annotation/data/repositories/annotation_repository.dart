import 'dart:io';

import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';

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

  /// Get available annotations for a project (only created by current user and not in ANY project_task)
  Future<List<AnnotationModel>> getAvailableAnnotationsForProject({
    required String projectId,
    required AnnotationType type,
    int limit = 50,
  }) async {
    return handleError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');

      // Get ALL annotation IDs that are in ANY project_task
      final allAssignedTasks = await client
          .from('project_tasks')
          .select('annotation_id');

      final assignedIds = (allAssignedTasks as List)
          .map((task) => task['annotation_id'] as String)
          .toSet() // Use Set to remove duplicates
          .toList();

      // Get annotations created by current user that match type
      var query = client
          .from('annotations')
          .select()
          .eq('type', type.name)
          .eq('created_by', userId); // Only show annotations created by current user

      // Exclude annotations already in ANY project_task
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
          .where((task) => task['annotations'] != null) // Filter out null annotations
          .map((task) {
            final annotationJson = task['annotations'] as Map<String, dynamic>;
            return AnnotationModel.fromJson(annotationJson);
          })
          .where((annotation) => annotation.type == type)
          .toList();
    });
  }

  /// Get all unannotated project tasks (for home page quick actions)
  Future<List<AnnotationModel>> getAllUnannotatedProjectTasks({
    required AnnotationType type,
    int limit = 50,
  }) async {
    return handleError(() async {
      // Get ALL unannotated tasks from ALL projects
      final response = await client
          .from('project_tasks')
          .select('annotations(*)')
          .isFilter('annotated_by', null) // Only unannotated tasks
          .limit(limit);

      return (response as List)
          .where((task) => task['annotations'] != null) // Filter out null annotations
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
      
      // Instead of calling the RPC function, do direct database operations
      // This bypasses the problematic database function
      
      // 1. Insert submission
      await client.from('submissions').insert({
        'annotation_id': annotationId,
        'project_id': projectId,
        'user_id': userId,
        'data': data,
        'xp_earned': xpEarned,
      });
      
      // 2. Update project_tasks only if project_id is provided
      if (projectId != null) {
        // Check if user is project owner
        final projectResponse = await client
            .from('projects')
            .select('owner_id, completed_tasks')
            .eq('id', projectId)
            .single();
        
        final isOwner = projectResponse['owner_id'] == userId;
        
        // Auto-approve if owner, otherwise set to pending
        final validationStatus = isOwner ? 'approved' : 'pending';
        
        await client
            .from('project_tasks')
            .update({
              'annotated_by': userId,
              'annotated_at': DateTime.now().toIso8601String(),
              'annotation_data': data,
              'validation_status': validationStatus,
              if (isOwner) 'validated_by': userId,
              if (isOwner) 'validated_at': DateTime.now().toIso8601String(),
            })
            .eq('project_id', projectId)
            .eq('annotation_id', annotationId);
        
        // 3. Update project completed tasks count (only if approved)
        if (isOwner) {
          await client
              .from('projects')
              .update({
                'completed_tasks': (projectResponse['completed_tasks'] as int) + 1,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', projectId);
        }
      }
      
      // 4. Update user annotations_completed count
      final userStatsResponse = await client
          .from('users')
          .select('annotations_completed')
          .eq('id', userId)
          .single();
      
      await client
          .from('users')
          .update({
            'annotations_completed': (userStatsResponse['annotations_completed'] as int) + 1,
            'last_active_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      
      // 5. Update user XP
      final userResponse = await client
          .from('users')
          .select('total_xp, level, current_level_xp, next_level_xp')
          .eq('id', userId)
          .single();
      
      int newTotalXp = (userResponse['total_xp'] as int) + xpEarned;
      int newLevel = userResponse['level'] as int;
      int newCurrentXp = (userResponse['current_level_xp'] as int) + xpEarned;
      int nextLevelXp = userResponse['next_level_xp'] as int;
      
      // Check for level up
      while (newCurrentXp >= nextLevelXp) {
        newLevel++;
        newCurrentXp -= nextLevelXp;
        nextLevelXp += 100;
        
        // Log level up activity
        await client.from('activities').insert({
          'user_id': userId,
          'activity_type': 'level_up',
          'title': 'Reached Level $newLevel',
          'description': 'Keep up the great work!',
        });
      }
      
      // Update user with new XP and level
      await client
          .from('users')
          .update({
            'total_xp': newTotalXp,
            'level': newLevel,
            'current_level_xp': newCurrentXp,
            'next_level_xp': nextLevelXp,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      
      // 6. Log annotation completion activity
      await client.from('activities').insert({
        'user_id': userId,
        'activity_type': 'annotation',
        'title': 'Completed Annotation',
        'description': 'Great work!',
        'xp_earned': xpEarned,
      });
      
      // 7. Manually refresh leaderboard (call the function if it works, or skip)
      try {
        await client.rpc('refresh_leaderboard');
      } catch (e) {
        // If refresh fails, that's okay - leaderboard will update eventually
        print('Leaderboard refresh skipped: $e');
      }
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

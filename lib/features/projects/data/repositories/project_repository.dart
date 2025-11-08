import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';

/// Project repository
class ProjectRepository extends BaseRepository {
  /// Get all projects with filter
  Future<List<Project>> getProjects({String filter = 'all'}) async {
    return handleError(() async {
      final userId = SupabaseConfig.currentUserId;
      
      // For contributed filter, we need to get projects where user has completed tasks
      if (filter == 'contributed') {
        // Get distinct project IDs where user has annotated tasks
        final contributedProjectIds = await client
            .from('project_tasks')
            .select('project_id')
            .eq('annotated_by', userId!)
            .then((response) => (response as List)
                .map((item) => item['project_id'] as String)
                .toSet()
                .toList());
        
        // If no contributions, return empty list
        if (contributedProjectIds.isEmpty) {
          return [];
        }
        
        // Get projects where user has contributed
        final response = await client
            .from('projects')
            .select('*, users!owner_id(username, avatar_url)')
            .inFilter('id', contributedProjectIds)
            .order('created_at', ascending: false);
        
        return (response as List).map((json) {
          final projectData = Map<String, dynamic>.from(json);
          if (json['users'] != null) {
            projectData['owner_name'] = json['users']['username'] ?? '';
            projectData['owner_avatar'] = json['users']['avatar_url'];
          } else {
            projectData['owner_name'] = '';
            projectData['owner_avatar'] = null;
          }
          projectData.remove('users');
          return Project.fromJson(projectData);
        }).toList();
      }
      
      // For 'all' and 'owned' filters
      var query = client
          .from('projects')
          .select('*, users!owner_id(username, avatar_url)');
      
      if (filter == 'owned') {
        query = query.eq('owner_id', userId!);
      }
      // 'all' filter doesn't need additional conditions
      
      final response = await query.order('created_at', ascending: false);
      
      return (response as List).map((json) {
        final projectData = Map<String, dynamic>.from(json);
        // Extract user data from join
        if (json['users'] != null) {
          projectData['owner_name'] = json['users']['username'] ?? '';
          projectData['owner_avatar'] = json['users']['avatar_url'];
        } else {
          projectData['owner_name'] = '';
          projectData['owner_avatar'] = null;
        }
        projectData.remove('users');
        
        return Project.fromJson(projectData);
      }).toList();
    });
  }
  
  /// Get project by ID
  Future<Project> getProject(String projectId) async {
    return handleError(() async {
      final response = await client
          .from('projects')
          .select('*, users!owner_id(username, avatar_url)')
          .eq('id', projectId)
          .single();
      
      // Transform response
      final projectData = Map<String, dynamic>.from(response);
      projectData['ownerName'] = response['users']['username'];
      projectData['ownerAvatar'] = response['users']['avatar_url'];
      projectData.remove('users');
      
      return Project.fromJson(projectData);
    });
  }
  
  /// Create project
  Future<Project> createProject(Project project) async {
    return handleError(() async {
      final response = await client
          .from('projects')
          .insert(project.toJson())
          .select()
          .single();
      
      return Project.fromJson(response);
    });
  }
  
  /// Update project
  Future<void> updateProject(Project project) async {
    return handleVoidError(() async {
      await client
          .from('projects')
          .update(project.toJson())
          .eq('id', project.id);
    });
  }
  
  /// Delete project
  Future<void> deleteProject(String projectId) async {
    return handleVoidError(() async {
      await client
          .from('projects')
          .delete()
          .eq('id', projectId);
    });
  }
  
  /// Get project tasks
  Future<List<ProjectTask>> getProjectTasks(String projectId) async {
    return handleError(() async {
      final response = await client
          .from('project_tasks')
          .select('*, annotations(*)')
          .eq('project_id', projectId);
      
      return (response as List).where((json) {
        // Filter out tasks where annotation is null (deleted or missing)
        return json['annotations'] != null;
      }).map((json) {
        final taskData = Map<String, dynamic>.from(json);
        taskData['annotation'] = json['annotations'];
        taskData.remove('annotations');
        return ProjectTask.fromJson(taskData);
      }).toList();
    });
  }

  /// Get unannotated project tasks (for annotation screens)
  Future<List<ProjectTask>> getUnannotatedProjectTasks(String projectId) async {
    return handleError(() async {
      final response = await client
          .from('project_tasks')
          .select('*, annotations(*)')
          .eq('project_id', projectId)
          .isFilter('annotated_by', null); // Only tasks not yet annotated
      
      return (response as List).map((json) {
        final taskData = Map<String, dynamic>.from(json);
        taskData['annotation'] = json['annotations'];
        taskData.remove('annotations');
        return ProjectTask.fromJson(taskData);
      }).toList();
    });
  }
  
  /// Add task to project
  Future<void> addTaskToProject(String projectId, String annotationId) async {
    return handleVoidError(() async {
      await client.from('project_tasks').insert({
        'project_id': projectId,
        'annotation_id': annotationId,
      });
      
      // Update total tasks count - get current count and increment
      final project = await client
          .from('projects')
          .select('total_tasks')
          .eq('id', projectId)
          .single();
      
      await client
          .from('projects')
          .update({'total_tasks': (project['total_tasks'] as int) + 1})
          .eq('id', projectId);
    });
  }

  /// Validate task (approve or reject)
  Future<void> validateTask({
    required String taskId,
    required String projectId,
    required bool approved,
  }) async {
    return handleVoidError(() async {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('No user logged in');

      final status = approved ? 'approved' : 'rejected';

      // Update task validation status
      await client.from('project_tasks').update({
        'validation_status': status,
        'validated_by': userId,
        'validated_at': DateTime.now().toIso8601String(),
        'is_validated': approved,
      }).eq('id', taskId);

      // If approved, increment completed_tasks
      if (approved) {
        final project = await client
            .from('projects')
            .select('completed_tasks')
            .eq('id', projectId)
            .single();

        await client.from('projects').update({
          'completed_tasks': (project['completed_tasks'] as int) + 1,
        }).eq('id', projectId);
      }

      // If rejected, reset the task
      if (!approved) {
        await client.from('project_tasks').update({
          'annotated_by': null,
          'annotated_at': null,
          'annotation_data': null,
        }).eq('id', taskId);
      }
    });
  }
}

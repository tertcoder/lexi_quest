import 'package:lexi_quest/core/data/repositories/base_repository.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';
import 'package:lexi_quest/core/config/supabase_config.dart';

/// Project repository
class ProjectRepository extends BaseRepository {
  /// Get all projects with filter
  Future<List<Project>> getProjects({String filter = 'all'}) async {
    return handleError(() async {
      final userId = SupabaseConfig.currentUserId;
      
      var query = client
          .from('projects')
          .select('*, users!owner_id(username, avatar_url)');
      
      // Apply filter
      if (filter == 'owned') {
        query = query.eq('owner_id', userId!);
      } else if (filter == 'contributed') {
        // For now, show all projects (can be enhanced later with contributors table)
        query = query.neq('owner_id', userId!);
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
      
      return (response as List).map((json) {
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
      
      // Update total tasks count
      await client
          .from('projects')
          .update({'total_tasks': client.rpc('increment')})
          .eq('id', projectId);
    });
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';

/// Export formats
enum ExportFormat {
  json,
  csv,
  txt,
}

/// Service for exporting annotated data
class ExportService {
  /// Export project annotations to JSON
  Future<String> exportToJson(Project project, List<ProjectTask> tasks) async {
    final data = {
      'project': {
        'id': project.id,
        'name': project.name,
        'description': project.description,
        'type': project.type.name,
        'created_at': project.createdAt.toIso8601String(),
        'total_tasks': project.totalTasks,
        'completed_tasks': project.completedTasks,
        'validated_tasks': project.validatedTasks,
      },
      'annotations': tasks.map((task) {
        return {
          'task_id': task.id,
          'content': task.annotation.content,
          'type': task.annotation.type.name,
          'annotated_by': task.annotatedBy,
          'annotated_at': task.annotatedAt?.toIso8601String(),
          'is_validated': task.isValidated,
          'validated_by': task.validatedBy,
          'validated_at': task.validatedAt?.toIso8601String(),
          'labels': task.annotation.labels,
        };
      }).toList(),
      'metadata': {
        'exported_at': DateTime.now().toIso8601String(),
        'total_annotations': tasks.length,
        'completed_annotations': tasks.where((t) => t.annotatedBy != null).length,
        'validated_annotations': tasks.where((t) => t.isValidated).length,
      },
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export project annotations to CSV
  Future<String> exportToCsv(Project project, List<ProjectTask> tasks) async {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('Task ID,Content,Type,Annotated By,Annotated At,Is Validated,Validated By,Validated At,Labels');
    
    // Rows
    for (final task in tasks) {
      final labels = task.annotation.labels != null ? task.annotation.labels!.join(';') : '';
      buffer.writeln([
        task.id,
        _escapeCsv(task.annotation.content),
        task.annotation.type.name,
        task.annotatedBy ?? '',
        task.annotatedAt != null ? task.annotatedAt!.toIso8601String() : '',
        task.isValidated,
        task.validatedBy ?? '',
        task.validatedAt != null ? task.validatedAt!.toIso8601String() : '',
        _escapeCsv(labels),
      ].join(','));
    }
    
    return buffer.toString();
  }

  /// Export project annotations to TXT
  Future<String> exportToTxt(Project project, List<ProjectTask> tasks) async {
    final buffer = StringBuffer();
    
    buffer.writeln('=' * 80);
    buffer.writeln('PROJECT: ${project.name}');
    buffer.writeln('=' * 80);
    buffer.writeln('Description: ${project.description}');
    buffer.writeln('Type: ${project.type.name}');
    buffer.writeln('Total Tasks: ${project.totalTasks}');
    buffer.writeln('Completed: ${project.completedTasks}');
    buffer.writeln('Validated: ${project.validatedTasks}');
    buffer.writeln('Exported: ${DateTime.now()}');
    buffer.writeln('=' * 80);
    buffer.writeln();
    
    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      buffer.writeln('TASK ${i + 1}/${tasks.length}');
      buffer.writeln('-' * 80);
      buffer.writeln('ID: ${task.id}');
      buffer.writeln('Content: ${task.annotation.content}');
      buffer.writeln('Type: ${task.annotation.type.name}');
      if (task.annotatedBy != null) {
        buffer.writeln('Annotated By: ${task.annotatedBy}');
        buffer.writeln('Annotated At: ${task.annotatedAt}');
      }
      if (task.isValidated) {
        buffer.writeln('Validated By: ${task.validatedBy}');
        buffer.writeln('Validated At: ${task.validatedAt}');
      }
      if (task.annotation.labels != null && task.annotation.labels!.isNotEmpty) {
        buffer.writeln('Labels: ${task.annotation.labels!.join(", ")}');
      }
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  /// Save and share exported file
  Future<void> exportAndShare({
    required Project project,
    required List<ProjectTask> tasks,
    required ExportFormat format,
  }) async {
    String content;
    String extension;

    switch (format) {
      case ExportFormat.json:
        content = await exportToJson(project, tasks);
        extension = 'json';
        break;
      case ExportFormat.csv:
        content = await exportToCsv(project, tasks);
        extension = 'csv';
        break;
      case ExportFormat.txt:
        content = await exportToTxt(project, tasks);
        extension = 'txt';
        break;
    }

    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final fileName = '${_sanitizeFileName(project.name)}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final file = File('${directory.path}/$fileName');

    // Write content to file
    await file.writeAsString(content);

    // Share file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Export: ${project.name}',
      text: 'Annotated data from ${project.name}',
    );
  }

  /// Escape CSV special characters
  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Sanitize filename
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Get export statistics
  Map<String, dynamic> getExportStats(List<ProjectTask> tasks) {
    final completed = tasks.where((t) => t.annotatedBy != null).length;
    final validated = tasks.where((t) => t.isValidated).length;
    final pending = tasks.where((t) => t.annotatedBy == null).length;

    return {
      'total': tasks.length,
      'completed': completed,
      'validated': validated,
      'pending': pending,
      'completion_rate': tasks.isEmpty ? 0.0 : (completed / tasks.length * 100),
      'validation_rate': completed == 0 ? 0.0 : (validated / completed * 100),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/services/export_service.dart';
import 'package:lexi_quest/features/projects/data/models/project_model.dart';

class ExportDialog extends StatefulWidget {
  final Project project;
  final List<ProjectTask> tasks;

  const ExportDialog({
    super.key,
    required this.project,
    required this.tasks,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.json;
  bool _isExporting = false;
  final _exportService = ExportService();

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      await _exportService.exportAndShare(
        project: widget.project,
        tasks: widget.tasks,
        format: _selectedFormat,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export successful!'),
            backgroundColor: AppColors.secondaryGreen500,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.secondaryRed500,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _exportService.getExportStats(widget.tasks);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryIndigo600.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.download,
                    color: AppColors.primaryIndigo600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export Annotations',
                        style: AppFonts.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.project.name,
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStatRow('Total Tasks', '${stats['total']}'),
                  const SizedBox(height: 8),
                  _buildStatRow('Completed', '${stats['completed']}'),
                  const SizedBox(height: 8),
                  _buildStatRow('Validated', '${stats['validated']}'),
                  const SizedBox(height: 8),
                  _buildStatRow(
                    'Completion Rate',
                    '${stats['completion_rate'].toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Format Selection
            Text(
              'Export Format',
              style: AppFonts.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFormatOption(
              ExportFormat.json,
              'JSON',
              'Structured data format, ideal for developers',
              Icons.code,
            ),
            const SizedBox(height: 8),
            _buildFormatOption(
              ExportFormat.csv,
              'CSV',
              'Spreadsheet format, ideal for data analysis',
              Icons.table_chart,
            ),
            const SizedBox(height: 8),
            _buildFormatOption(
              ExportFormat.txt,
              'TXT',
              'Plain text format, human-readable',
              Icons.text_snippet,
            ),
            const SizedBox(height: 24),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isExporting ? null : _handleExport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryIndigo600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isExporting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Export & Share',
                        style: AppFonts.buttonText.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFonts.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppFonts.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFormatOption(
    ExportFormat format,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedFormat == format;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFormat = format;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryIndigo600.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryIndigo600
                : AppColors.neutralSlate600_30,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryIndigo600
                    : AppColors.neutralSlate600_30,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.onPrimary
                    : AppColors.neutralSlate600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.primaryIndigo600
                          : AppColors.onBackground,
                    ),
                  ),
                  Text(
                    description,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryIndigo600,
              ),
          ],
        ),
      ),
    );
  }
}

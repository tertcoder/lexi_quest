import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/features/profile/bloc/profile_bloc.dart';
import 'package:lexi_quest/features/profile/bloc/profile_state.dart';
import 'package:lexi_quest/core/services/celebration_service.dart';

/// Global celebration manager that wraps the app
/// Only shows celebrations once per event, not on every screen
class CelebrationManager extends StatefulWidget {
  final Widget child;

  const CelebrationManager({
    super.key,
    required this.child,
  });

  @override
  State<CelebrationManager> createState() => _CelebrationManagerState();
}

class _CelebrationManagerState extends State<CelebrationManager> {
  // Track which celebrations have been shown to avoid duplicates
  final Set<String> _shownCelebrations = {};

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) {
        // Only listen when it's a celebration state
        return current is ProfileLevelUp || current is ProfileTaskCompleted;
      },
      listener: (context, state) async {
        if (state is ProfileLevelUp) {
          // Create unique ID for this celebration
          final celebrationId = 'levelup_${state.newLevel}_${state.xpEarned}';
          
          // Only show if not already shown
          if (!_shownCelebrations.contains(celebrationId)) {
            _shownCelebrations.add(celebrationId);
            
            await CelebrationService.showLevelUpCelebration(
              context: context,
              newLevel: state.newLevel,
              xpEarned: state.xpEarned,
            );
            
            // Remove from set after showing to allow future celebrations
            Future.delayed(const Duration(seconds: 5), () {
              _shownCelebrations.remove(celebrationId);
            });
          }
        } else if (state is ProfileTaskCompleted) {
          // Create unique ID for this celebration
          final celebrationId = 'task_${state.xpEarned}_${DateTime.now().millisecondsSinceEpoch}';
          
          // Only show if not already shown
          if (!_shownCelebrations.contains(celebrationId)) {
            _shownCelebrations.add(celebrationId);
            
            await CelebrationService.showTaskCompletionCelebration(
              context: context,
              taskName: state.taskName ?? 'Task',
              xpEarned: state.xpEarned,
              projectName: state.projectName,
            );
            
            // Remove from set after showing to allow future celebrations
            Future.delayed(const Duration(seconds: 5), () {
              _shownCelebrations.remove(celebrationId);
            });
          }
        }
      },
      child: widget.child,
    );
  }
}

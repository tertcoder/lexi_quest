import 'package:flutter_bloc/flutter_bloc.dart';
import 'gamification_event.dart';
import 'gamification_state.dart';
import '../data/repositories/gamification_demo_data.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  GamificationBloc() : super(GamificationInitial()) {
    on<LoadGamificationData>(_onLoadGamificationData);
    on<RefreshLeaderboard>(_onRefreshLeaderboard);
    on<UnlockBadge>(_onUnlockBadge);
    on<AddXP>(_onAddXP);
    on<UpdateStreak>(_onUpdateStreak);
    on<ResetStreak>(_onResetStreak);
  }

  Future<void> _onLoadGamificationData(
    LoadGamificationData event,
    Emitter<GamificationState> emit,
  ) async {
    emit(GamificationLoading());

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      final userProgress = GamificationDemoData.getUserProgress();
      final allBadges = GamificationDemoData.getAllBadges();
      final unlockedBadges = GamificationDemoData.getUnlockedBadges();
      final leaderboard = GamificationDemoData.getLeaderboard();
      final weeklyStats = GamificationDemoData.getWeeklyStats();

      emit(
        GamificationLoaded(
          userProgress: userProgress,
          allBadges: allBadges,
          unlockedBadges: unlockedBadges,
          leaderboard: leaderboard,
          weeklyStats: weeklyStats,
        ),
      );
    } catch (e) {
      emit(GamificationError('Failed to load gamification data: $e'));
    }
  }

  Future<void> _onRefreshLeaderboard(
    RefreshLeaderboard event,
    Emitter<GamificationState> emit,
  ) async {
    if (state is GamificationLoaded) {
      final currentState = state as GamificationLoaded;

      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 300));

        final updatedLeaderboard = GamificationDemoData.getLeaderboard();

        emit(currentState.copyWith(leaderboard: updatedLeaderboard));
      } catch (e) {
        emit(GamificationError('Failed to refresh leaderboard: $e'));
      }
    }
  }

  Future<void> _onUnlockBadge(
    UnlockBadge event,
    Emitter<GamificationState> emit,
  ) async {
    if (state is GamificationLoaded) {
      final currentState = state as GamificationLoaded;

      // Find the badge to unlock
      final badgeToUnlock = currentState.allBadges.firstWhere(
        (badge) => badge.id == event.badgeId,
      );

      if (!badgeToUnlock.isUnlocked) {
        final unlockedBadge = badgeToUnlock.copyWith(
          unlockedAt: DateTime.now(),
        );

        // Update the badge lists
        final updatedAllBadges =
            currentState.allBadges.map((badge) {
              return badge.id == event.badgeId ? unlockedBadge : badge;
            }).toList();

        final updatedUnlockedBadges = [
          ...currentState.unlockedBadges,
          unlockedBadge,
        ];

        // Update user progress
        final updatedProgress = currentState.userProgress.copyWith(
          unlockedBadgeIds: [
            ...currentState.userProgress.unlockedBadgeIds,
            event.badgeId,
          ],
        );

        final updatedState = currentState.copyWith(
          userProgress: updatedProgress,
          allBadges: updatedAllBadges,
          unlockedBadges: updatedUnlockedBadges,
        );

        emit(BadgeUnlocked(badge: unlockedBadge, previousState: updatedState));
      }
    }
  }

  Future<void> _onAddXP(AddXP event, Emitter<GamificationState> emit) async {
    if (state is GamificationLoaded) {
      final currentState = state as GamificationLoaded;
      final currentProgress = currentState.userProgress;

      final newTotalXP = currentProgress.totalXP + event.xpAmount;
      final newLevel = _calculateLevel(newTotalXP);
      final leveledUp = newLevel > currentProgress.level;

      final newXPToNextLevel = _getXPForLevel(newLevel + 1) - newTotalXP;

      final updatedProgress = currentProgress.copyWith(
        currentXP: currentProgress.currentXP + event.xpAmount,
        totalXP: newTotalXP,
        level: newLevel,
        xpToNextLevel: newXPToNextLevel,
      );

      final updatedState = currentState.copyWith(userProgress: updatedProgress);

      emit(
        XPAdded(
          xpAmount: event.xpAmount,
          leveledUp: leveledUp,
          newLevel: leveledUp ? newLevel : null,
          previousState: updatedState,
        ),
      );
    }
  }

  Future<void> _onUpdateStreak(
    UpdateStreak event,
    Emitter<GamificationState> emit,
  ) async {
    if (state is GamificationLoaded) {
      final currentState = state as GamificationLoaded;
      final currentProgress = currentState.userProgress;

      final now = DateTime.now();
      final lastActivity = currentProgress.lastActivityDate;
      final daysSinceLastActivity = now.difference(lastActivity).inDays;

      int newStreak = currentProgress.currentStreak;

      if (daysSinceLastActivity == 1) {
        // Continue streak
        newStreak = currentProgress.currentStreak + 1;
      } else if (daysSinceLastActivity == 0) {
        // Same day, maintain streak
        newStreak = currentProgress.currentStreak;
      } else {
        // Break in streak, reset to 1
        newStreak = 1;
      }

      final newBestStreak =
          newStreak > currentProgress.bestStreak
              ? newStreak
              : currentProgress.bestStreak;

      final updatedProgress = currentProgress.copyWith(
        currentStreak: newStreak,
        bestStreak: newBestStreak,
        lastActivityDate: now,
      );

      emit(currentState.copyWith(userProgress: updatedProgress));
    }
  }

  Future<void> _onResetStreak(
    ResetStreak event,
    Emitter<GamificationState> emit,
  ) async {
    if (state is GamificationLoaded) {
      final currentState = state as GamificationLoaded;

      final updatedProgress = currentState.userProgress.copyWith(
        currentStreak: 0,
      );

      emit(currentState.copyWith(userProgress: updatedProgress));
    }
  }

  int _calculateLevel(int totalXP) {
    int level = 1;
    while (_getXPForLevel(level + 1) <= totalXP) {
      level++;
    }
    return level;
  }

  int _getXPForLevel(int level) {
    return (level * level * 100) + (level * 50);
  }
}

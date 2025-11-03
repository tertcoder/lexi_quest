import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/features/leaderboard/bloc/leaderboard_event.dart';
import 'package:lexi_quest/features/leaderboard/bloc/leaderboard_state.dart';
import 'package:lexi_quest/features/leaderboard/data/repositories/leaderboard_repository.dart';

/// Leaderboard BLoC
class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _leaderboardRepository;
  StreamSubscription? _leaderboardSubscription;

  LeaderboardBloc({LeaderboardRepository? leaderboardRepository})
      : _leaderboardRepository = leaderboardRepository ?? LeaderboardRepository(),
        super(const LeaderboardInitial()) {
    on<LoadLeaderboard>(_onLoadLeaderboard);
    on<RefreshLeaderboard>(_onRefreshLeaderboard);
    on<SubscribeToLeaderboard>(_onSubscribeToLeaderboard);
  }

  /// Handle load leaderboard
  Future<void> _onLoadLeaderboard(
    LoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(const LeaderboardLoading());
    try {
      final entries = await _leaderboardRepository.getLeaderboard(limit: event.limit);
      emit(LeaderboardLoaded(entries: entries));
    } catch (e) {
      emit(LeaderboardError(message: e.toString()));
    }
  }

  /// Handle refresh leaderboard
  Future<void> _onRefreshLeaderboard(
    RefreshLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      await _leaderboardRepository.refreshLeaderboard();
      add(const LoadLeaderboard());
    } catch (e) {
      emit(LeaderboardError(message: e.toString()));
    }
  }

  /// Handle subscribe to leaderboard (realtime)
  Future<void> _onSubscribeToLeaderboard(
    SubscribeToLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    await _leaderboardSubscription?.cancel();
    
    await emit.forEach(
      _leaderboardRepository.subscribeToLeaderboard(limit: event.limit),
      onData: (entries) => LeaderboardLoaded(entries: entries),
      onError: (error, stackTrace) => LeaderboardError(message: error.toString()),
    );
  }

  @override
  Future<void> close() {
    _leaderboardSubscription?.cancel();
    return super.close();
  }
}

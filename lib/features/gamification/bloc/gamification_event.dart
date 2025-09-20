import 'package:equatable/equatable.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();

  @override
  List<Object> get props => [];
}

class LoadGamificationData extends GamificationEvent {}

class RefreshLeaderboard extends GamificationEvent {}

class UnlockBadge extends GamificationEvent {
  final String badgeId;

  const UnlockBadge(this.badgeId);

  @override
  List<Object> get props => [badgeId];
}

class AddXP extends GamificationEvent {
  final int xpAmount;

  const AddXP(this.xpAmount);

  @override
  List<Object> get props => [xpAmount];
}

class UpdateStreak extends GamificationEvent {}

class ResetStreak extends GamificationEvent {}

enum BadgeCategory { achievement, milestone, streak, special }

enum BadgeRarity { common, rare, epic, legendary }

class Badge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final BadgeCategory category;
  final BadgeRarity rarity;
  final int requiredValue;
  final String requirement;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.rarity,
    required this.requiredValue,
    required this.requirement,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    BadgeCategory? category,
    BadgeRarity? rarity,
    int? requiredValue,
    String? requirement,
    DateTime? unlockedAt,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      requiredValue: requiredValue ?? this.requiredValue,
      requirement: requirement ?? this.requirement,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

extension BadgeCategoryExtension on BadgeCategory {
  String get displayName {
    switch (this) {
      case BadgeCategory.achievement:
        return 'Achievement';
      case BadgeCategory.milestone:
        return 'Milestone';
      case BadgeCategory.streak:
        return 'Streak';
      case BadgeCategory.special:
        return 'Special';
    }
  }
}

extension BadgeRarityExtension on BadgeRarity {
  String get displayName {
    switch (this) {
      case BadgeRarity.common:
        return 'Common';
      case BadgeRarity.rare:
        return 'Rare';
      case BadgeRarity.epic:
        return 'Epic';
      case BadgeRarity.legendary:
        return 'Legendary';
    }
  }
}

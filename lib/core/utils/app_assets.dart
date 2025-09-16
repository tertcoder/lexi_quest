/// Centralized asset path management for the LexiQuest app.
///
/// This class provides static constants for all asset paths used throughout
/// the application, organized by type (images, SVGs, data files).
///
/// Example usage:
/// ```dart
/// Image.asset(AppAssets.logo)
/// SvgPicture.asset(AppAssets.icHome)
/// ```
class AppAssets {
  // Private constructor to prevent instantiation
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _svgsPath = 'assets/svgs';
  static const String _dataPath = 'assets/data';

  // Logo
  static const String logo = '$_imagesPath/logo.png';

  // Badge assets
  static const String badgeBronze = '$_imagesPath/badges/badge_bronze.png';
  static const String badgeSilver = '$_imagesPath/badges/badge_silver.png';
  static const String badgeGold = '$_imagesPath/badges/badge_gold.png';
  static const String badgeDiamond = '$_imagesPath/badges/badge_diamond.png';

  // Achievement icons
  static const String achievementFirst =
      '$_imagesPath/achievements/first_annotation.png';
  static const String achievementSpeed =
      '$_imagesPath/achievements/speed_annotator.png';
  static const String achievementAccuracy =
      '$_imagesPath/achievements/accuracy_expert.png';

  // Onboarding images
  static const String onboardingWelcome = '$_imagesPath/onboarding/welcome.png';
  static const String onboardingAnnotation =
      '$_imagesPath/onboarding/annotation_demo.png';
  static const String onboardingProgress =
      '$_imagesPath/onboarding/progress_tracking.png';

  // Sample documents
  static const String sampleTextDocument =
      '$_imagesPath/samples/sample_text.png';
  static const String samplePdfDocument = '$_imagesPath/samples/sample_pdf.png';

  // SVG Icons - Navigation
  static const String icHome = '$_svgsPath/icons/ic_home.svg';
  static const String icAnnotation = '$_svgsPath/icons/ic_annotation.svg';
  static const String icProfile = '$_svgsPath/icons/ic_profile.svg';
  static const String icStatistics = '$_svgsPath/icons/ic_statistics.svg';
  static const String icSettings = '$_svgsPath/icons/ic_settings.svg';

  // SVG Icons - Actions
  static const String icAdd = '$_svgsPath/icons/ic_add.svg';
  static const String icEdit = '$_svgsPath/icons/ic_edit.svg';
  static const String icDelete = '$_svgsPath/icons/ic_delete.svg';
  static const String icSave = '$_svgsPath/icons/ic_save.svg';
  static const String icShare = '$_svgsPath/icons/ic_share.svg';
  static const String icDownload = '$_svgsPath/icons/ic_download.svg';

  // SVG Icons - Interface
  static const String icClose = '$_svgsPath/icons/ic_close.svg';
  static const String icBack = '$_svgsPath/icons/ic_back.svg';
  static const String icNext = '$_svgsPath/icons/ic_next.svg';
  static const String icSearch = '$_svgsPath/icons/ic_search.svg';
  static const String icFilter = '$_svgsPath/icons/ic_filter.svg';
  static const String icSort = '$_svgsPath/icons/ic_sort.svg';

  // Illustrations
  static const String illEmptyState =
      '$_svgsPath/illustrations/empty_state.svg';
  static const String illError = '$_svgsPath/illustrations/error.svg';
  static const String illSuccess = '$_svgsPath/illustrations/success.svg';
  static const String illLoading = '$_svgsPath/illustrations/loading.svg';

  // Data files
  static const String sampleAnnotations = '$_dataPath/sample_annotations.json';
  static const String achievementsData = '$_dataPath/achievements.json';
  static const String levelsData = '$_dataPath/levels.json';

  // Helper methods

  /// Returns the appropriate badge asset based on the badge type
  static String getBadgeAsset(BadgeType type) {
    switch (type) {
      case BadgeType.bronze:
        return badgeBronze;
      case BadgeType.silver:
        return badgeSilver;
      case BadgeType.gold:
        return badgeGold;
      case BadgeType.diamond:
        return badgeDiamond;
    }
  }

  /// Returns the appropriate achievement icon based on achievement type
  static String getAchievementAsset(AchievementType type) {
    switch (type) {
      case AchievementType.firstAnnotation:
        return achievementFirst;
      case AchievementType.speedAnnotator:
        return achievementSpeed;
      case AchievementType.accuracyExpert:
        return achievementAccuracy;
    }
  }
}

/// Enum for badge types
enum BadgeType { bronze, silver, gold, diamond }

/// Enum for achievement types
enum AchievementType { firstAnnotation, speedAnnotator, accuracyExpert }

/// LexiQuest Asset Management
/// Centralized asset path definitions for easy maintenance and refactoring
class AppAssets {
  // Private constructor to prevent instantiation
  AppAssets._();
  
  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _svgsPath = 'assets/svgs';
  static const String _dataPath = 'assets/data';
  
  /// Image Assets
  class Images {
    Images._();
    
    // Icons
    static const String _iconsPath = '$_imagesPath/icons';
    
    // Illustrations
    static const String _illustrationsPath = '$_imagesPath/illustrations';
    static const String onboardingWelcome = '$_illustrationsPath/onboarding_welcome.png';
    static const String onboardingAnnotation = '$_illustrationsPath/onboarding_annotation.png';
    static const String onboardingGamification = '$_illustrationsPath/onboarding_gamification.png';
    static const String emptyStateAnnotations = '$_illustrationsPath/empty_state_annotations.png';
    static const String emptyStateRewards = '$_illustrationsPath/empty_state_rewards.png';
    
    // Badges & Achievements
    static const String _badgesPath = '$_imagesPath/badges';
    static const String badgeBronze = '$_badgesPath/badge_bronze.png';
    static const String badgeSilver = '$_badgesPath/badge_silver.png';
    static const String badgeGold = '$_badgesPath/badge_gold.png';
    static const String badgeDiamond = '$_badgesPath/badge_diamond.png';
    static const String badgeFirstAnnotation = '$_badgesPath/badge_first_annotation.png';
    static const String badgeStreakMaster = '$_badgesPath/badge_streak_master.png';
    static const String badgeAiExpert = '$_badgesPath/badge_ai_expert.png';
    
    // Sample Annotation Images
    static const String _annotationsPath = '$_imagesPath/annotations';
    static const String sampleTextDocument = '$_annotationsPath/sample_text_document.png';
    static const String sampleImage1 = '$_annotationsPath/sample_image_1.jpg';
    static const String sampleImage2 = '$_annotationsPath/sample_image_2.jpg';
    static const String sampleImageWithObjects = '$_annotationsPath/sample_image_with_objects.jpg';
  }
  
  /// SVG Assets
  class Svgs {
    Svgs._();
    
    // Icons
    static const String _iconsPath = '$_svgsPath/icons';
    static const String icHome = '$_iconsPath/ic_home.svg';
    static const String icAnnotation = '$_iconsPath/ic_annotation.svg';
    static const String icProfile = '$_iconsPath/ic_profile.svg';
    static const String icRewards = '$_iconsPath/ic_rewards.svg';
    static const String icLeaderboard = '$_iconsPath/ic_leaderboard.svg';
    static const String icHistory = '$_iconsPath/ic_history.svg';
    static const String icAiAssist = '$_iconsPath/ic_ai_assist.svg';
    static const String icManualAnnotation = '$_iconsPath/ic_manual_annotation.svg';
    static const String icTextAnnotation = '$_iconsPath/ic_text_annotation.svg';
    static const String icImageAnnotation = '$_iconsPath/ic_image_annotation.svg';
    static const String icSettings = '$_iconsPath/ic_settings.svg';
    static const String icLogout = '$_iconsPath/ic_logout.svg';
    static const String icTheme = '$_iconsPath/ic_theme.svg';
    
    // Illustrations
    static const String _illustrationsPath = '$_svgsPath/illustrations';
    static const String illWelcome = '$_illustrationsPath/ill_welcome.svg';
    static const String illAnnotationWorkspace = '$_illustrationsPath/ill_annotation_workspace.svg';
    static const String illGamificationConcept = '$_illustrationsPath/ill_gamification_concept.svg';
    static const String illEmptyAnnotations = '$_illustrationsPath/ill_empty_annotations.svg';
    static const String illEmptyRewards = '$_illustrationsPath/ill_empty_rewards.svg';
    static const String illSuccess = '$_illustrationsPath/ill_success.svg';
    static const String illError = '$_illustrationsPath/ill_error.svg';
  }
  
  /// Data Assets
  class Data {
    Data._();
    
    // Sample datasets
    static const String sampleTextAnnotations = '$_dataPath/sample_text_annotations.json';
    static const String sampleImageLabels = '$_dataPath/sample_image_labels.csv';
    static const String mockUsers = '$_dataPath/mock_users.json';
    static const String appConfig = '$_dataPath/app_config.json';
    
    // Annotation templates
    static const String textAnnotationTemplate = '$_dataPath/text_annotation_template.json';
    static const String imageAnnotationTemplate = '$_dataPath/image_annotation_template.json';
  }
  
  /// Helper methods for asset management
  class Utils {
    Utils._();
    
    /// Get badge asset based on badge type
    static String getBadgeAsset(BadgeType type) {
      switch (type) {
        case BadgeType.bronze:
          return Images.badgeBronze;
        case BadgeType.silver:
          return Images.badgeSilver;
        case BadgeType.gold:
          return Images.badgeGold;
        case BadgeType.diamond:
          return Images.badgeDiamond;
        case BadgeType.firstAnnotation:
          return Images.badgeFirstAnnotation;
        case BadgeType.streakMaster:
          return Images.badgeStreakMaster;
        case BadgeType.aiExpert:
          return Images.badgeAiExpert;
      }
    }
    
    /// Get annotation type icon
    static String getAnnotationIcon(AnnotationType type) {
      switch (type) {
        case AnnotationType.text:
          return Svgs.icTextAnnotation;
        case AnnotationType.image:
          return Svgs.icImageAnnotation;
        case AnnotationType.manual:
          return Svgs.icManualAnnotation;
        case AnnotationType.aiAssisted:
          return Svgs.icAiAssist;
      }
    }
  }
}

/// Badge types for the gamification system
enum BadgeType {
  bronze,
  silver,
  gold,
  diamond,
  firstAnnotation,
  streakMaster,
  aiExpert,
}

/// Annotation types for the app
enum AnnotationType {
  text,
  image,
  manual,
  aiAssisted,
}
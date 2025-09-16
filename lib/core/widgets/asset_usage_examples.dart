import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_assets.dart';

/// Example usage of LexiQuest assets in Flutter widgets
class AssetUsageExamples extends StatelessWidget {
  const AssetUsageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset Usage Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SVG Icons Example
            const Text(
              'SVG Icons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Using SVG assets (requires flutter_svg package)
                SvgPicture.asset(
                  AppAssets.Svgs.icHome,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                SvgPicture.asset(
                  AppAssets.Svgs.icAnnotation,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 16),
                SvgPicture.asset(
                  AppAssets.Svgs.icProfile,
                  width: 24,
                  height: 24,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Image Assets Example
            const Text(
              'Badge Images:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Using Image assets
                Image.asset(
                  AppAssets.Images.badgeBronze,
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.brown,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Image.asset(
                  AppAssets.Images.badgeGold,
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Illustration Example
            const Text(
              'Illustrations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Image.asset(
                AppAssets.Images.onboardingWelcome,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Welcome Illustration Placeholder',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Dynamic Badge Example
            const Text(
              'Dynamic Badge Selection:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  BadgeType.values.map((badgeType) {
                    return Column(
                      children: [
                        Image.asset(
                          AppAssets.Utils.getBadgeAsset(badgeType),
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: _getBadgeColor(badgeType),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          badgeType.name,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            // Asset as Background Example
            const Text(
              'Background Image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.Images.sampleTextDocument),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sample Document',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ready for annotation',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Code Examples
            const Text(
              'Usage Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// SVG Icon\nSvgPicture.asset(AppAssets.Svgs.icHome)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '// Image Asset\nImage.asset(AppAssets.Images.badgeGold)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '// Background Image\nDecorationImage(\n  image: AssetImage(AppAssets.Images.onboardingWelcome)\n)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(BadgeType type) {
    switch (type) {
      case BadgeType.bronze:
        return Colors.brown;
      case BadgeType.silver:
        return Colors.grey;
      case BadgeType.gold:
        return Colors.amber;
      case BadgeType.diamond:
        return Colors.cyan;
      default:
        return Colors.blue;
    }
  }
}

# LexiQuest Assets

This directory contains all static assets for the LexiQuest application.

## Directory Structure

### 📁 `images/`

Contains raster images (PNG, JPG, WebP) used throughout the app.

- **`icons/`** - App icons, navigation icons, feature icons
- **`illustrations/`** - Onboarding illustrations, empty states, hero images
- **`badges/`** - Gamification badges (Bronze, Silver, Gold, Diamond)
- **`annotations/`** - Sample images for annotation practice

### 📁 `svgs/`

Contains vector graphics (SVG) for scalable icons and illustrations.

- **`icons/`** - SVG icons for UI elements
- **`illustrations/`** - SVG illustrations for modern, crisp graphics

### 📁 `data/`

Contains data files like JSON, CSV for sample datasets.

- Sample annotation datasets
- Configuration files
- Mock data for development

### 📁 `fonts/`

Contains custom font files (if not using Google Fonts).

## Asset Naming Conventions

### Images

- Use lowercase with underscores: `login_illustration.png`
- Include size suffix for variants: `logo_small.png`, `logo_large.png`
- Use descriptive names: `badge_bronze.png`, `annotation_text_sample.jpg`

### SVGs

- Use lowercase with underscores: `home_icon.svg`
- Prefix with category: `ic_annotation.svg`, `ill_welcome.svg`

### File Format Recommendations

- **Icons**: SVG (preferred) or PNG with @2x, @3x variants
- **Illustrations**: SVG for simple graphics, PNG/WebP for complex images
- **Photos**: WebP (preferred) or JPG for better compression
- **Badges/Awards**: PNG with transparency or SVG

## Usage in Code

```dart
// For images
Image.asset('assets/images/badges/badge_gold.png')

// For SVGs (with flutter_svg package)
SvgPicture.asset('assets/svgs/icons/ic_annotation.svg')

// Using AssetImage
decoration: DecorationImage(
  image: AssetImage('assets/images/illustrations/welcome.png'),
)
```

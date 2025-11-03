# 🎯 LexiQuest - AI Data Annotation Platform

A powerful, gamified data annotation platform built with Flutter and Supabase. LexiQuest enables teams to collaboratively annotate text, images, and audio data for machine learning projects while earning XP, badges, and competing on leaderboards.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## ✨ Features

### 🎮 Gamification
- **XP System** - Earn experience points for completing annotations
- **Level Progression** - Advance through levels as you contribute
- **Badges & Achievements** - Unlock rewards for milestones
- **Streak Tracking** - Maintain daily annotation streaks
- **Live Leaderboard** - Compete with other annotators in real-time

### 📝 Annotation Types
- **Text Annotation** - Label text segments, sentiment analysis, NER
- **Image Annotation** - Bounding boxes, image classification
- **Audio Annotation** - Transcription, audio classification

### 🚀 Project Management
- **Create Projects** - Set up annotation projects with custom labels
- **Project Dashboard** - Track progress, completion rates, validation status
- **Task Distribution** - Automatic task assignment to contributors
- **Export Data** - Download annotated datasets in JSON, CSV, or TXT formats

### 👥 Collaboration
- **Multi-user Support** - Team-based annotation workflows
- **Validation System** - Quality control through peer validation
- **Real-time Updates** - Live leaderboard and activity feeds
- **User Profiles** - Track individual contributions and stats

### 🔐 Authentication & Security
- **Secure Auth** - Email/password authentication via Supabase
- **Password Reset** - Forgot password functionality
- **Profile Management** - Edit profile, change password
- **Row Level Security** - Supabase RLS policies for data protection

### 📊 ML-Ready Exports
- **JSON Format** - Structured data for deep learning frameworks
- **CSV Format** - Compatible with scikit-learn, pandas
- **TXT Format** - Human-readable documentation
- **Validation Filtering** - Export only validated, high-quality data
- **Training Ready** - Direct compatibility with PyTorch, TensorFlow, Hugging Face

---

## 🏗️ Architecture

### Clean Architecture with BLoC Pattern

```
┌─────────────────────────────────────────────┐
│              UI Layer (Screens)              │
│  - Signup, Login, Profile, Projects, etc.   │
└──────────────────┬──────────────────────────┘
                   │ Events
┌──────────────────▼──────────────────────────┐
│           BLoC Layer (State Mgmt)            │
│  - AuthBloc, ProfileBloc, ProjectsBloc      │
└──────────────────┬──────────────────────────┘
                   │ Method Calls
┌──────────────────▼──────────────────────────┐
│        Repository Layer (Data Access)        │
│  - AuthRepo, UserRepo, ProjectRepo          │
└──────────────────┬──────────────────────────┘
                   │ API Calls
┌──────────────────▼──────────────────────────┐
│           Supabase Backend                   │
│  - PostgreSQL, Auth, Storage, Realtime      │
└─────────────────────────────────────────────┘
```

### Tech Stack
- **Frontend**: Flutter 3.0+
- **State Management**: flutter_bloc
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Realtime)
- **Navigation**: go_router
- **UI**: Custom theme with Material Design 3

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Supabase account
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/tertcoder/lexi_quest.git
cd lexi_quest
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Run the SQL setup script: `supabase_complete_setup.sql`
   - Enable Realtime for tables: `leaderboard`, `activities`, `projects`
   - Create storage buckets: `avatars`, `project-thumbnails`, `annotation-images`, `annotation-audio`

4. **Configure Supabase credentials**
   
   Update `lib/core/config/supabase_config.dart`:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

5. **Run the app**
```bash
flutter run
```

---

## 📱 Screenshots

### Authentication & Onboarding
- Welcome screen with gradient design
- Signup with email validation
- Login with forgot password option

### Main Features
- Home dashboard with personalized greeting
- Projects list with filtering and search
- Project details with progress tracking
- Annotation screens (text, image, audio)
- Live leaderboard with rankings
- User profile with stats and badges

### Data Export
- Export dialog with format selection
- Statistics preview before export
- Native share integration

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── config/          # Supabase configuration
│   ├── data/            # Base repository
│   ├── services/        # Export service, utilities
│   ├── theme/           # App colors, fonts, themes
│   ├── utils/           # Constants, helpers
│   └── widgets/         # Reusable UI components
│
├── features/
│   ├── auth/            # Authentication
│   │   ├── bloc/        # AuthBloc
│   │   ├── data/        # AuthRepository
│   │   └── ui/          # Login, Signup, Forgot Password
│   │
│   ├── profile/         # User Profile
│   │   ├── bloc/        # ProfileBloc
│   │   ├── data/        # UserRepository, UserProfile model
│   │   └── ui/          # Profile, Edit Profile
│   │
│   ├── projects/        # Project Management
│   │   ├── bloc/        # ProjectsBloc
│   │   ├── data/        # ProjectRepository, Project model
│   │   └── ui/          # Projects list, Create, Edit, Details
│   │
│   ├── annotation/      # Annotation System
│   │   ├── bloc/        # AnnotationBloc
│   │   ├── data/        # AnnotationRepository, models
│   │   └── ui/          # Text, Image, Audio annotation screens
│   │
│   ├── leaderboard/     # Leaderboard
│   │   ├── bloc/        # LeaderboardBloc
│   │   ├── data/        # LeaderboardRepository
│   │   └── ui/          # Leaderboard screen
│   │
│   ├── home/            # Home Dashboard
│   │   ├── data/        # ActivityRepository
│   │   └── ui/          # Home screen
│   │
│   └── settings/        # Settings
│       └── ui/          # Settings, Change Password
│
├── routes.dart          # App navigation
└── main.dart            # App entry point
```

---

## 🗄️ Database Schema

### Core Tables
- **users** - User profiles with XP, levels, badges
- **projects** - Annotation projects
- **annotations** - Annotation tasks
- **user_annotations** - User submissions
- **leaderboard** - Real-time rankings
- **activities** - Activity feed
- **badges** - Achievement system
- **user_badges** - User achievements

### Key Features
- Row Level Security (RLS) policies
- Real-time subscriptions
- Automatic triggers for XP calculation
- Storage buckets for media files

---

## 📊 ML Training Guide

LexiQuest exports are **100% ready for machine learning**! 

See [ML_TRAINING_GUIDE.md](ML_TRAINING_GUIDE.md) for:
- Python training examples (scikit-learn, PyTorch, TensorFlow)
- Data quality filtering
- Framework compatibility
- Production deployment

### Quick Example
```python
import json
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

# Load exported data
with open('export.json', 'r') as f:
    data = json.load(f)

# Extract validated annotations
X = [ann['content'] for ann in data['annotations'] if ann['is_validated']]
y = [ann['labels'][0] for ann in data['annotations'] if ann['is_validated']]

# Train model
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
vectorizer = TfidfVectorizer()
X_train_vec = vectorizer.fit_transform(X_train)
model = LogisticRegression()
model.fit(X_train_vec, y_train)
```

---

## 🎯 Key Features Implementation

### ✅ Completed Features
- [x] User authentication (signup, login, logout)
- [x] Forgot password & password reset
- [x] User profiles with stats
- [x] Edit profile & change password
- [x] Project CRUD operations
- [x] Text annotation
- [x] Image annotation
- [x] Audio annotation
- [x] Real-time leaderboard
- [x] XP and leveling system
- [x] Badge system
- [x] Streak tracking
- [x] Export annotations (JSON, CSV, TXT)
- [x] Project statistics
- [x] Search and filtering

### 🔄 Optional Enhancements
- [ ] Email preferences
- [ ] Push notifications
- [ ] Dark mode
- [ ] Multi-language support
- [ ] Social features (follow, comments)
- [ ] Advanced analytics dashboard

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

---

## 📦 Dependencies

### Core
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  go_router: ^12.0.0
  
  # Export functionality
  path_provider: ^2.1.1
  share_plus: ^7.2.1
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## 🚢 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Bon Tertius Tuyishimire** - *Initial work* - [Linkedin Profile](https://www.linkedin.com/in/bon-tertius-tuyishimire-1a997321a)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the powerful backend platform
- The open-source community

--- 

## 🗺️ Roadmap

### Version 2.0
- [ ] Mobile app optimization
- [ ] Offline annotation support
- [ ] Advanced export formats (COCO, YOLO)
- [ ] API for external integrations
- [ ] Team management features
- [ ] Advanced analytics

### Version 3.0
- [ ] AI-assisted annotation
- [ ] Auto-labeling suggestions
- [ ] Quality prediction models
- [ ] Advanced collaboration tools

---

**Built with ❤️ using Flutter & Supabase**

⭐ Star this repo if you find it helpful!

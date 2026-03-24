# 📁 GIS Dashboard - Project Structure

This document provides a comprehensive overview of the GIS Dashboard project structure, including all directories, files, and their purposes.

## 📋 Table of Contents

1. [Root Directory Structure](#root-directory-structure)
2. [Documentation Structure](#documentation-structure)
3. [Source Code Structure](#source-code-structure)
4. [Configuration Files](#configuration-files)
5. [Build and Deployment](#build-and-deployment)
6. [Platform-Specific Directories](#platform-specific-directories)

---

## 📂 Root Directory Structure

```
GIS_Dashboard/
│
├── docs/                    # 📚 System documentation
│   ├── README.md           # Documentation index
│   ├── architecture.md     # System architecture
│   ├── api.md              # API documentation
│   ├── deployment.md       # Deployment guide
│   ├── database-schema.md  # Database schema
│   └── troubleshooting.md  # Troubleshooting guide
│
├── docker/                  # 🐳 Docker configuration
│   ├── Dockerfile          # Multi-stage build for web
│   ├── docker-compose.yml  # Docker Compose config
│   ├── nginx/
│   │   └── nginx.conf     # Nginx server config
│   └── README.md          # Docker documentation
│
├── scripts/                 # 🔧 Deployment/maintenance scripts
│   ├── deploy.sh          # Deployment automation
│   ├── backup.sh          # Backup script
│   └── migrate.sh         # Migration script
│
├── .github/                 # 🔄 CI/CD + templates
│   ├── workflows/
│   │   └── ci.yml         # GitHub Actions CI
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md  # Bug report template
│   │   └── feature_request.md  # Feature request template
│   ├── PULL_REQUEST_TEMPLATE.md  # PR template
│   └── copilot-instructions.md
│
├── lib/                     # 💻 Source code (main directory)
│   ├── core/              # Shared utilities
│   ├── features/          # Feature modules
│   ├── config/            # Configuration
│   └── main.dart          # Entry point
│
├── test/                   # 🧪 Test files
│   └── widget_test.dart
│
├── assets/                 # 🎨 Static assets
│   ├── icons/             # App icons
│   ├── images/             # Images
│   └── processing/        # Processing assets
│
├── android/                 # 🤖 Android platform
├── ios/                     # 🍎 iOS platform
├── web/                     # 🌐 Web platform
├── windows/                 # 🪟 Windows platform
├── linux/                   # 🐧 Linux platform
├── macos/                   # 🍎 macOS platform
│
├── .env.example            # 🔐 Environment variables template
├── .gitignore              # Git ignore rules
├── README.md               # 📖 Main project README
├── CHANGELOG.md            # 📝 Version history
├── CONTRIBUTING.md         # 🤝 Contribution guidelines
├── LICENSE                 # ⚖️ License file
├── PROJECT_STRUCTURE.md    # 📁 This file
├── pubspec.yaml            # 📦 Flutter dependencies
├── pubspec.lock            # 🔒 Locked dependencies
└── analysis_options.yaml   # 🔍 Dart analyzer config
```

---

## 📚 Documentation Structure

### `docs/` Directory

Comprehensive system documentation for developers, contributors, and users.

| File | Purpose |
|------|---------|
| `README.md` | Documentation index and navigation |
| `architecture.md` | System architecture, design patterns, data flow |
| `api.md` | API endpoints, request/response formats, examples |
| `deployment.md` | Build and deployment instructions for all platforms |
| `database-schema.md` | Data structures, models, relationships |
| `troubleshooting.md` | Common issues, solutions, debugging tips |

**See**: [docs/README.md](docs/README.md) for detailed documentation guide.

---

## 💻 Source Code Structure

### `lib/` Directory

Main source code directory following Clean Architecture principles.

```
lib/
├── core/                      # Shared utilities and services
│   ├── common/               # Constants, widgets, screens
│   ├── network/              # HTTP client, interceptors
│   ├── service/             # Data service layer
│   └── utils/                # Utility functions
│
├── features/                 # Feature modules (domain-data-presentation)
│   ├── map/                  # Interactive GIS map
│   ├── filter/               # Filtering system
│   ├── summary/              # Statistical dashboard
│   ├── epi_center/           # EPI center details
│   ├── epi_center_finder/    # Location-based EPI center search
│   ├── session_plan/         # Session planning
│   ├── micro_plan/           # Microplanning tools
│   ├── zero_dose_dashboard/  # Zero-dose tracking
│   └── gis_methodology/      # Methodology documentation
│
├── config/                   # Configuration files
│   └── env_config.dart       # Environment configuration
│
└── main.dart                 # Application entry point
```

### Feature Module Structure

Each feature follows a consistent structure:

```
feature_name/
├── data/                     # Data layer
│   └── repository.dart       # Data repository implementation
│
├── domain/                   # Domain layer
│   ├── models/              # Domain models
│   └── state.dart           # State classes
│
└── presentation/             # Presentation layer
    ├── controllers/         # State management (Riverpod)
    ├── screens/             # UI screens
    └── widgets/             # Reusable widgets
```

**See**: [docs/architecture.md](docs/architecture.md) for detailed architecture documentation.

---

## ⚙️ Configuration Files

### Root Level Configuration

| File | Purpose |
|------|---------|
| `.env.example` | Environment variables template (copy to `.env`) |
| `.gitignore` | Git ignore patterns |
| `pubspec.yaml` | Flutter dependencies and project metadata |
| `pubspec.lock` | Locked dependency versions |
| `analysis_options.yaml` | Dart analyzer configuration |

### Environment Configuration

**`.env.example`** - Template for environment variables:
- URL configuration (scheme, hosts, paths)
- API configuration (timeouts, retries)
- Feature flags
- Logging configuration

**⚠️ Important**: Copy `.env.example` to `.env` and configure with actual values. Never commit `.env` to version control.

---

## 🐳 Docker Structure

### `docker/` Directory

Docker configuration for containerized deployment.

```
docker/
├── Dockerfile              # Multi-stage build (Flutter + Nginx)
├── docker-compose.yml     # Docker Compose configuration
├── nginx/
│   └── nginx.conf        # Nginx server configuration
└── README.md             # Docker documentation
```

**See**: [docker/README.md](docker/README.md) for detailed Docker documentation.

---

## 🔧 Scripts Structure

### `scripts/` Directory

Automation scripts for deployment, backup, and migration.

| Script | Purpose | Usage |
|--------|---------|-------|
| `deploy.sh` | Automated deployment for all platforms | `./scripts/deploy.sh [platform] [build_type]` |
| `backup.sh` | Backup important project files | `./scripts/backup.sh` |
| `migrate.sh` | Migration after dependency updates | `./scripts/migrate.sh` |

**Features**:
- Color-coded output
- Error handling
- Progress logging
- Platform validation

---

## 🔄 CI/CD Structure

### `.github/` Directory

GitHub Actions workflows and issue/PR templates.

```
.github/
├── workflows/
│   └── ci.yml                    # CI/CD pipeline
│       ├── Code analysis
│       ├── Tests
│       ├── Android build
│       └── iOS build
│
├── ISSUE_TEMPLATE/
│   ├── bug_report.md            # Bug report template
│   └── feature_request.md       # Feature request template
│
└── PULL_REQUEST_TEMPLATE.md     # Pull request template
```

**CI/CD Pipeline**:
- Code analysis and linting
- Automated testing
- Multi-platform builds
- Coverage reporting

---

## 📱 Platform-Specific Directories

### Android (`android/`)

- Gradle build configuration
- AndroidManifest.xml
- App signing configuration
- Native Android code

### iOS (`ios/`)

- Xcode project files
- Info.plist configuration
- Native iOS code (Swift)
- CocoaPods dependencies

### Web (`web/`)

- HTML entry point
- Web-specific assets
- PWA configuration

### Desktop Platforms

- **Windows** (`windows/`): Windows-specific configuration
- **Linux** (`linux/`): Linux-specific configuration
- **macOS** (`macos/`): macOS-specific configuration

---

## 📦 Assets Structure

### `assets/` Directory

Static assets used by the application.

```
assets/
├── icons/              # App icons (SVG, PNG)
├── images/            # Images
└── processing/        # Processing-related assets
```

---

## 🧪 Testing Structure

### `test/` Directory

Test files for unit tests, widget tests, and integration tests.

```
test/
└── widget_test.dart   # Example widget test
```

**Testing**:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for end-to-end flows

---

## 📝 Documentation Files

### Root Level Documentation

| File | Purpose |
|------|---------|
| `README.md` | Main project documentation, getting started guide |
| `CHANGELOG.md` | Version history, release notes |
| `CONTRIBUTING.md` | Contribution guidelines, coding standards |
| `LICENSE` | Project license (MIT) |
| `PROJECT_STRUCTURE.md` | This file - project structure overview |

---

## 🔍 Key Files Reference

### Essential Files for Development

1. **`pubspec.yaml`** - Dependencies and project configuration
2. **`.env.example`** - Environment variables template
3. **`lib/main.dart`** - Application entry point
4. **`README.md`** - Getting started guide
5. **`docs/architecture.md`** - Architecture documentation

### Essential Files for Deployment

1. **`docker/Dockerfile`** - Docker build configuration
2. **`scripts/deploy.sh`** - Deployment automation
3. **`docs/deployment.md`** - Deployment guide
4. **`.github/workflows/ci.yml`** - CI/CD pipeline

### Essential Files for Contribution

1. **`CONTRIBUTING.md`** - Contribution guidelines
2. **`.github/ISSUE_TEMPLATE/`** - Issue templates
3. **`.github/PULL_REQUEST_TEMPLATE.md`** - PR template
4. **`docs/README.md`** - Documentation guide

---

## 📊 Project Statistics

- **Language**: Dart (Flutter)
- **Architecture**: Clean Architecture
- **State Management**: Riverpod
- **Platforms**: Android, iOS, Web, Windows, Linux, macOS
- **Documentation**: Comprehensive (6 main docs + templates)
- **CI/CD**: GitHub Actions
- **Containerization**: Docker

---

## 🚀 Quick Navigation

- **Getting Started**: [README.md](README.md)
- **Architecture**: [docs/architecture.md](docs/architecture.md)
- **API Reference**: [docs/api.md](docs/api.md)
- **Deployment**: [docs/deployment.md](docs/deployment.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Docker**: [docker/README.md](docker/README.md)
- **Documentation Index**: [docs/README.md](docs/README.md)

---

## 📌 Notes

- All documentation follows Markdown format
- Code follows Dart/Flutter style guidelines
- Scripts are bash-compatible (Unix/Linux/macOS)
- Docker configuration supports multi-stage builds
- CI/CD pipeline runs on every push and PR

---

**Last Updated**: January 2025  
**Project Version**: 1.0.0

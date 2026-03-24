# Contributing to GIS Dashboard

Thank you for your interest in contributing to the GIS Dashboard project! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Follow the project's coding standards
- Test your changes thoroughly

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK
- Git
- IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/pinjor/GIS_Dashboard.git
   cd GIS_Dashboard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Development Workflow

### Branch Naming

Use descriptive branch names:
- `feature/epi-center-finder` - New features
- `fix/map-loading-issue` - Bug fixes
- `docs/update-readme` - Documentation
- `refactor/state-management` - Code refactoring

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: Add EPI Center Finder feature
fix: Resolve map loading issue
docs: Update API documentation
refactor: Improve state management
test: Add unit tests for repository
chore: Update dependencies
```

### Pull Request Process

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, readable code
   - Follow existing code style
   - Add comments for complex logic
   - Update documentation if needed

3. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: Add your feature description"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Provide clear description
   - Reference related issues
   - Add screenshots if UI changes
   - Ensure all checks pass

## Coding Standards

### Dart Style Guide

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide:

- Use `lowerCamelCase` for variables and functions
- Use `UpperCamelCase` for classes
- Use `lowercase_with_underscores` for file names
- Prefer `final` over `var` when possible
- Use meaningful variable names

### Architecture

- Follow Clean Architecture principles
- Use feature-driven structure
- Separate concerns (domain, data, presentation)
- Use dependency injection (Riverpod)

### Code Organization

```
lib/
├── core/          # Shared code
├── features/      # Feature modules
└── main.dart      # Entry point
```

### State Management

- Use Riverpod for state management
- Keep state immutable (use Freezed)
- Separate business logic from UI
- Use StateNotifier for complex state

### Error Handling

- Handle errors gracefully
- Provide user-friendly error messages
- Log errors for debugging
- Use try-catch for async operations

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for high test coverage
- Test edge cases and error scenarios

## Documentation

### Code Comments

- Add comments for complex logic
- Document public APIs
- Explain "why" not "what"
- Keep comments up to date

### Documentation Files

- Update README.md for major changes
- Update CHANGELOG.md for releases
- Add to docs/ for new features
- Keep API documentation current

## Testing Guidelines

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

- Test one thing at a time
- Use descriptive test names
- Arrange-Act-Assert pattern
- Mock external dependencies

## Review Process

1. **Automated Checks**
   - Code must pass `flutter analyze`
   - All tests must pass
   - No linter errors

2. **Code Review**
   - At least one approval required
   - Address review comments
   - Keep PRs focused and small

3. **Merge**
   - Squash commits if needed
   - Update CHANGELOG.md
   - Tag release if applicable

## Reporting Issues

### Bug Reports

Include:
- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Device/platform information
- Screenshots/logs if applicable

### Feature Requests

Include:
- Use case description
- Proposed solution
- Alternatives considered
- Impact assessment

## Questions?

- Check existing documentation
- Search existing issues
- Ask in discussions
- Contact maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to GIS Dashboard! 🎉

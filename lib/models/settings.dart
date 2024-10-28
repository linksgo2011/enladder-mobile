enum ThemeOption {
  light, // Light
  sepia, // Sepia
  dark, // Dark
}

enum FontSizeOption {
  small, // Small (120%)
  medium, // Medium (160%)
  large, // Large (200%)
}

extension ThemeOptionExtension on ThemeOption {
  String get label {
    switch (this) {
      case ThemeOption.light:
        return "日间模式";
      case ThemeOption.sepia:
        return "护眼模式";
      case ThemeOption.dark:
        return "夜间模式";
    }
  }
}

extension FontSizeExtension on FontSizeOption {
  String get value {
    switch (this) {
      case FontSizeOption.small:
        return "120%";
      case FontSizeOption.medium:
        return "160%";
      case FontSizeOption.large:
        return "200%";
    }
  }

  String get label {
    switch (this) {
      case FontSizeOption.small:
        return "小";
      case FontSizeOption.medium:
        return "中";
      case FontSizeOption.large:
        return "大";
    }
  }
}

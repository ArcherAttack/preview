import 'package:flutter/material.dart';

/// Утилита для адаптивного дизайна
/// Поддерживает все размеры экранов от iPhone SE до iPhone 17 Pro Max
/// и от мини Android устройств до Samsung Z Fold
class ResponsiveHelper {
  static const double _iphoneSEMinWidth = 320.0;
  static const double _iphoneSEMinHeight = 568.0;
  
  static const double _zFoldUnfoldedWidth = 512.0;
  
  /// Получить размер экрана
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  /// Получить ширину экрана
  static double getWidth(BuildContext context) {
    return getScreenSize(context).width;
  }
  
  /// Получить высоту экрана
  static double getHeight(BuildContext context) {
    return getScreenSize(context).height;
  }
  
  /// Проверка, является ли устройство планшетом
  static bool isTablet(BuildContext context) {
    final width = getWidth(context);
    return width >= 600;
  }
  
  /// Проверка, является ли устройство складным (foldable)
  static bool isFoldable(BuildContext context) {
    final width = getWidth(context);
    return width >= _zFoldUnfoldedWidth;
  }
  
  /// Проверка, является ли устройство маленьким (iPhone SE, мини Android)
  static bool isSmallDevice(BuildContext context) {
    final width = getWidth(context);
    final height = getHeight(context);
    return width <= _iphoneSEMinWidth || height <= _iphoneSEMinHeight;
  }
  
  /// Получить адаптивный размер шрифта
  static double getResponsiveFontSize(BuildContext context, {
    double? small,      // Для маленьких устройств (iPhone SE, мини Android)
    required double base, // Базовый размер
    double? large,      // Для больших устройств (планшеты, Z Fold)
  }) {
    if (isSmallDevice(context) && small != null) {
      return small;
    }
    if (isTablet(context) && large != null) {
      return large;
    }
    if (isFoldable(context) && large != null) {
      return large;
    }
    return base;
  }
  
  /// Получить адаптивный padding
  static EdgeInsets getResponsivePadding(BuildContext context, {
    EdgeInsets? small,
    required EdgeInsets base,
    EdgeInsets? large,
  }) {
    if (isSmallDevice(context) && small != null) {
      return small;
    }
    if (isTablet(context) && large != null) {
      return large;
    }
    if (isFoldable(context) && large != null) {
      return large;
    }
    return base;
  }
  
  /// Получить адаптивный размер иконки
  static double getResponsiveIconSize(BuildContext context, {
    double? small,
    required double base,
    double? large,
  }) {
    if (isSmallDevice(context) && small != null) {
      return small;
    }
    if (isTablet(context) && large != null) {
      return large;
    }
    if (isFoldable(context) && large != null) {
      return large;
    }
    return base;
  }
  
  /// Получить количество колонок для GridView
  static int getResponsiveColumns(BuildContext context, {
    int? small,
    required int base,
    int? large,
  }) {
    if (isSmallDevice(context) && small != null) {
      return small;
    }
    if (isTablet(context) && large != null) {
      return large;
    }
    if (isFoldable(context) && large != null) {
      return large;
    }
    return base;
  }
  
  /// Получить адаптивную ширину (в процентах от ширины экрана)
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return getWidth(context) * (percentage / 100);
  }
  
  /// Получить адаптивную высоту (в процентах от высоты экрана)
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return getHeight(context) * (percentage / 100);
  }
  
  /// Получить адаптивный размер для SizedBox
  static double getResponsiveSpacing(BuildContext context, {
    double? small,
    required double base,
    double? large,
  }) {
    if (isSmallDevice(context) && small != null) {
      return small;
    }
    if (isTablet(context) && large != null) {
      return large;
    }
    if (isFoldable(context) && large != null) {
      return large;
    }
    return base;
  }
  
  /// Получить адаптивный размер для BorderRadius
  static BorderRadius getResponsiveBorderRadius(BuildContext context, {
    double? small,
    required double base,
    double? large,
  }) {
    double radius;
    if (isSmallDevice(context) && small != null) {
      radius = small;
    } else if ((isTablet(context) || isFoldable(context)) && large != null) {
      radius = large;
    } else {
      radius = base;
    }
    return BorderRadius.circular(radius);
  }
  
  /// Получить адаптивный размер для AppBar высоты
  static double getResponsiveAppBarHeight(BuildContext context) {
    if (isSmallDevice(context)) {
      return 48.0;
    }
    if (isTablet(context) || isFoldable(context)) {
      return 64.0;
    }
    return 56.0;
  }
  
  /// Получить адаптивный размер для кнопок
  static double getResponsiveButtonHeight(BuildContext context) {
    if (isSmallDevice(context)) {
      return 40.0;
    }
    if (isTablet(context) || isFoldable(context)) {
      return 56.0;
    }
    return 48.0;
  }
  
  /// Получить адаптивный размер для текста в зависимости от ориентации
  static double getResponsiveTextSize(BuildContext context, {
    required double portrait,
    double? landscape,
  }) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape && landscape != null) {
      return landscape;
    }
    return portrait;
  }
  
  /// Получить максимальную ширину контента для планшетов
  static double getMaxContentWidth(BuildContext context) {
    if (isTablet(context) || isFoldable(context)) {
      return 1200.0;
    }
    return double.infinity;
  }
  
  /// Получить адаптивный размер для ListTile
  static double getResponsiveListTileHeight(BuildContext context) {
    if (isSmallDevice(context)) {
      return 56.0;
    }
    if (isTablet(context) || isFoldable(context)) {
      return 72.0;
    }
    return 64.0;
  }
}


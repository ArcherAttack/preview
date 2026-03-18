import 'package:flutter/material.dart';
import 'package:grainlogist/utils/screen_reload_manager.dart';

/// Миксин для экранов, которые могут перезагружать свои данные
/// Автоматически регистрирует экран в ScreenReloadManager при создании
/// и удаляет регистрацию при уничтожении
mixin ReloadableScreenMixin<T extends StatefulWidget> on State<T> {
  /// Имя маршрута экрана (должно быть переопределено в дочернем классе)
  String get routeName;

  /// Метод перезагрузки данных экрана
  /// Может принимать опциональные параметры для кастомизации перезагрузки
  Future<void> reloadData({Map<String, dynamic>? params});

  /// Флаг, указывающий нужно ли перезагружать даже если данные пустые
  bool get reloadEvenIfEmpty => true;

  /// Вызывается при инициализации экрана
  @override
  void initState() {
    super.initState();
    _registerScreen();
  }

  /// Вызывается при уничтожении экрана
  @override
  void dispose() {
    _unregisterScreen();
    super.dispose();
  }

  /// Регистрация экрана в менеджере перезагрузки
  void _registerScreen() {
    ScreenReloadManager().registerScreenReload(routeName, ({Map<String, dynamic>? params}) async {
      if (mounted) {
        await reloadData(params: params);
      }
    });
  }

  /// Удаление регистрации экрана
  void _unregisterScreen() {
    ScreenReloadManager().unregisterScreenReload(routeName);
  }

  /// Вспомогательный метод для безопасной перезагрузки с проверкой mounted
  Future<void> safeReload({Map<String, dynamic>? params}) async {
    if (!mounted) return;
    await reloadData(params: params);
  }
}

/// Базовый класс для экранов с данными, которые нужно перезагружать
/// Предоставляет стандартную реализацию для работы с состоянием загрузки
abstract class ReloadableScreenState<T extends StatefulWidget> extends State<T> 
    with ReloadableScreenMixin {
  
  bool _isLoading = false;
  bool _hasData = false;
  Object? _lastError;

  /// Флаг загрузки данных
  bool get isLoading => _isLoading;
  
  /// Флаг наличия данных
  bool get hasData => _hasData;
  
  /// Последняя ошибка
  Object? get lastError => _lastError;

  /// Установить состояние загрузки
  void setLoading(bool loading) {
    if (!mounted) return;
    setState(() {
      _isLoading = loading;
    });
  }

  /// Установить наличие данных
  void setHasData(bool hasData) {
    if (!mounted) return;
    setState(() {
      _hasData = hasData;
    });
  }

  /// Установить ошибку
  void setError(Object? error) {
    if (!mounted) return;
    setState(() {
      _lastError = error;
    });
  }

  /// Очистить ошибку
  void clearError() {
    if (!mounted) return;
    setState(() {
      _lastError = null;
    });
  }

  /// Стандартная реализация перезагрузки с проверкой условий
  @override
  Future<void> reloadData({Map<String, dynamic>? params}) async {
    // Если данные пустые и reloadEvenIfEmpty = false, не перезагружаем
    if (!reloadEvenIfEmpty && !hasData && !isLoading) {
      return;
    }

    await performReload(params: params);
  }

  /// Абстрактный метод, который должен быть реализован в дочерних классах
  /// Здесь происходит фактическая загрузка данных
  Future<void> performReload({Map<String, dynamic>? params});
}


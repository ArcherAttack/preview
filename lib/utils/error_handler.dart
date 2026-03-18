import 'package:flutter/material.dart';
import 'package:grainlogist/services/error_log_service.dart';

/// Глобальный обработчик ошибок для приложения
class ErrorHandler {
  static final ErrorLogService _errorLogger = ErrorLogService();

  /// Обработать ошибку и показать пользователю понятное сообщение
  static Future<void> handleError(
    BuildContext? context,
    Object error,
    StackTrace? stackTrace, {
    String? source,
    String? userMessage,
    bool showSnackBar = true,
    Map<String, dynamic>? additionalData,
  }) async {
    final errorSource = source ?? 'Unknown';
    
    // Логируем полную ошибку в файл
    final location = await _errorLogger.logError(
      errorSource,
      error,
      stackTrace,
      additionalData,
    );
    
    // Показываем пользователю только место ошибки
    if (context != null && showSnackBar) {
      final message = userMessage ?? 'Ошибка в $location. Обратитесь в тех.поддержку';
      
      if (context.mounted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: GestureDetector(
              onTap: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.down,
          ),
        );
      }
    }
  }

  /// Обработать ошибку API
  static Future<void> handleApiError(
    BuildContext? context,
    String endpoint,
    Object error,
    int? statusCode,
    String? responseBody,
    StackTrace? stackTrace, {
    String? userMessage,
    bool showSnackBar = true,
  }) async {
    final location = await _errorLogger.logApiError(
      endpoint,
      error,
      statusCode,
      responseBody,
      stackTrace,
    );
    
    if (context != null && showSnackBar) {
      String message;
      
      if (userMessage != null) {
        message = userMessage;
      } else if (statusCode == 401) {
        message = 'Ошибка авторизации. Пожалуйста, войдите заново';
      } else if (statusCode == 403) {
        message = 'Доступ запрещен';
      } else if (statusCode == 404) {
        message = 'Данные не найдены';
      } else if (statusCode != null && statusCode >= 500) {
        message = 'Ошибка сервера. Попробуйте позже';
      } else {
        message = 'Ошибка при загрузке данных из $location. Обратитесь в тех.поддержку';
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Обернуть функцию в try-catch с обработкой ошибок
  static Future<T?> safeCall<T>(
    BuildContext? context,
    Future<T> Function() function, {
    String? source,
    String? userMessage,
    T? defaultValue,
    bool showSnackBar = true,
  }) async {
    try {
      return await function();
    } catch (error, stackTrace) {
      await handleError(
        context,
        error,
        stackTrace,
        source: source,
        userMessage: userMessage,
        showSnackBar: showSnackBar,
      );
      return defaultValue;
    }
  }
}


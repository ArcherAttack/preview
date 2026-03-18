import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grainlogist/utils/api_config.dart';
import 'package:grainlogist/api/cookies_api.dart';

/// API для работы с документами ETRN
class EtrnApi {
  final ApiConfig _apiConfig = ApiConfig();
  final CookiesApi _cookiesApi = CookiesApi();
  final http.Client client = http.Client();

  /// Получает данные документа ETRN по ID
  /// 
  /// [token] - токен авторизации
  /// [idEtrn] - ID документа ETRN
  /// 
  /// Возвращает Map с данными документа или null при ошибке
  Future<Map<String, dynamic>?> getEtrnDocument({
    required String token,
    required String idEtrn,
  }) async {
    try {
      final cookies = await _cookiesApi.checkBaseCookie();
      final baseUrl = await _apiConfig.getBaseUrl();
      final url = Uri.parse('$baseUrl/etrn/mobile/$idEtrn');

      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Cookie': cookies,
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'] as Map<String, dynamic>?;
        } else {
          throw Exception(data['error']?.toString() ?? 'Ошибка получения документа');
        }
      } else {
        throw Exception('Ошибка HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка получения документа ETRN: ${e.toString()}');
    }
  }

  /// Получает список документов ETRN для текущего пользователя
  /// 
  /// [token] - токен авторизации
  /// [page] - номер страницы (по умолчанию 1)
  /// 
  /// Возвращает список документов
  Future<List<Map<String, dynamic>>> getEtrnDocumentsList({
    required String token,
    int page = 1,
  }) async {
    try {
      final cookies = await _cookiesApi.checkBaseCookie();
      final baseUrl = await _apiConfig.getBaseUrl();
      final url = Uri.parse('$baseUrl/etrn/mobile').replace(
        queryParameters: {'page': page.toString()},
      );

      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Cookie': cookies,
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final list = data['data'] as List<dynamic>? ?? [];
          return list.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
        } else {
          throw Exception(data['error']?.toString() ?? 'Ошибка получения списка документов');
        }
      } else {
        throw Exception('Ошибка HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка получения списка документов ETRN: ${e.toString()}');
    }
  }
}

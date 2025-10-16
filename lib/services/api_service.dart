import 'dart:convert';
import 'package:http/http.dart' as http;

/// 환경 변수에서 읽어오도록 변경
class ApiService {
  static const String baseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.example.com/expo-backend.php');

  /// 중복 확인
  static Future<bool> checkDuplicate(String boothId, String identifier) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'checkDuplicate',
        'boothId': boothId,
        'identifier': identifier,
      }),
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['success'] == true) {
      return data['exists'] as bool;
    }
    throw Exception(data['message'] ?? 'Duplicate check failed');
  }

  /// 부스 정보 조회
  static Future<Map<String, dynamic>> getBoothInfo(String boothId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'getBoothInfo',
        'boothId': boothId,
      }),
    );
    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// 등록 및 방문 기록
  static Future<bool> registerAndVisit({
    required String boothId,
    required String type,
    required String identifier,
    String? name,
    String? contact,
    bool privacyConsent = false,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'registerAndVisit',
        'boothId': boothId,
        'type': type,
        'identifier': identifier,
        'name': name,
        'contact': contact,
        'privacyConsent': privacyConsent,
      }),
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['success'] == true) {
      return true;
    }
    throw Exception(data['message'] ?? 'Registration failed');
  }
}

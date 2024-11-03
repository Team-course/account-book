import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<double> fetchMonthlyExpense() async {
    final response = await http.get(Uri.parse('$baseUrl/your-api-endpoint'));

    if (response.statusCode == 200) {
      // 응답 본문을 파싱하여 필요한 데이터를 추출
      final data = json.decode(response.body);
      return data['monthlyExpense'];  // 예시: 응답 JSON에서 monthlyExpense 값 가져오기
    } else {
      throw Exception('Failed to load monthly expense');
    }
  }
}
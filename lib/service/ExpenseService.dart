import 'package:account_book/MonthlyExpense_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class ExpenseService{
  final String baseUrl = 'http://10.0.2.2:8080/api/finance/account';

  Future<double> fetchTotalExpense(int userId, String startDate, String endDate) async{

    final uri = Uri.parse('$baseUrl/$userId/spending-summary').replace(
      queryParameters: {
        'startDate':startDate,
        'endDate':endDate,
      },
    );
    try {
      final response = await http.get(uri);

      print('Response status: ${response.statusCode}'); // 응답 상태 코드 출력
      print('Response body: ${response.body}'); // 응답 본문 출력

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['totalExpense'];
      }
      else {
        throw Exception("데이터 로드 실패: ${response.statusCode}");
      }
    }catch(e){
      print('Error: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> fetchMonthlyExpense(int userId, String startDate, String endDate) async {
    final uri = Uri.parse('$baseUrl/$userId/spending-summary').replace(
      queryParameters: {
        'startDate': startDate,
        'endDate': endDate,
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("데이터 로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }
}
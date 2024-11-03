import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'myAccount_page.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'service/ExpenseService.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 위한 import
import 'navigation_bar.dart'; // NavigationMenu를 위한 import

class MonthlyExpense_page extends StatefulWidget {
  @override
  _MonthlyExpense_pageState createState() => _MonthlyExpense_pageState();
}

class _MonthlyExpense_pageState extends State<MonthlyExpense_page> {
  final ExpenseService expenseService = ExpenseService();
  double monthlyExpense = 0.0;
  List<dynamic> categoryExpense = []; // 지출 항목 리스트 추가
  int userId = 1; // 사용자 ID
  int currentMonth = DateTime.now().month; // 현재 월 가져오기

  @override
  void initState() {
    super.initState();
    loadMonthlyExpense(userId); // 페이지 초기화 시 총 지출 및 지출 항목 불러오기
  }

  Future<void> loadMonthlyExpense(int userId) async {
    String startDate = DateFormat('yyyy-MM-01').format(DateTime.now()); // 월의 첫째 날
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // 오늘 날짜

    var result = await expenseService.fetchMonthlyExpense(userId, startDate, endDate);
    setState(() {
      monthlyExpense = result['totalExpense'];
      categoryExpense = result['categoryExpense'];
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int month = now.month;
    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);

    Map<String, List<Map<String,dynamic>>> groupedExpenses={};
    for(var expense in categoryExpense){
      String date = expense['date'];
      if(!groupedExpenses.containsKey(date)){
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }

    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 월 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Color(0xFF989898)), // 왼쪽 아이콘
                  onPressed: () {
                    // 왼쪽 아이콘 클릭 시 동작
                  },
                ),
                SizedBox(width: 0), // 아이콘과 텍스트 사이의 간격을 0으로 설정
                Text(
                  '$currentMonth 월',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(width: 0), // 텍스트와 오른쪽 아이콘 사이의 간격을 0으로 설정
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Color(0xFF989898)), // 오른쪽 아이콘
                  onPressed: () {
                    // 오른쪽 아이콘 클릭 시 동작
                  },
                ),
              ],
            ),
            SizedBox(height: 16), // 위쪽 여백

            // 총 지출 표시
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 17), // 기본 텍스트 스타일
                    children: [
                      TextSpan(
                        text: '지출:   ', // "지출: " 텍스트
                        style: TextStyle(color: Color(0xFF989898)), // 색상 설정
                      ),
                      TextSpan(
                        text: '${formattedMonthlyExpense} 원', // 문자열 앞에 '-' 추가
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), // 색상을 검정색으로 설정
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10), // 위쪽 여백
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 17), // 기본 텍스트 스타일
                    children: [
                      TextSpan(
                        text: '수입:   ', // "수입: " 텍스트
                        style: TextStyle(color: Color(0xFF989898)), // 색상 설정
                      ),
                      TextSpan(
                        text: '2,451,000 원', // 수입 금액 설정
                          style: TextStyle(color: Color(0xFF0EACCE), fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // 위쪽 여백

            // 지출 내용 리스트 제목
            Text(
              '지출 내역',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF707070)),
            ),
            SizedBox(height: 25), // 위쪽 여백

            // 지출 내역을 ListView로 표시
            Expanded(
              child: ListView(
                children: groupedExpenses.entries.map((entry) {
                  String date = entry.key;
                  List<Map<String, dynamic>> expensesForDate = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 날짜를 제목으로 표시
                      Text(
                        '${DateTime.parse(date).day}일', // 날짜에서 '일' 부분만 추출
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF989898)),
                      ),
                      ...expensesForDate.map((expense) => ListTile(
                        leading: Icon(Icons.category), // 원하는 아이콘으로 변경 가능
                        title: Text(expense['category']),
                        trailing: Text(
                          '-${expense['amount']} 원',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), // 글자 크기와 볼드 설정
                        ),
                      )),
                      Divider(
                        color: Color(0xFF989898), // 원하는 색상으로 변경
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            // 버튼 추가: 내역, 달력, 고정
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5A6A6D), // 배경색 설정
                    foregroundColor: Colors.white, // 텍스트 색상 설정
                  ),
                  onPressed: () {
                    // 내역 버튼 클릭 시 동작
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyExpense_page()));
                  },
                  child: Text("내역"),
                ),
                SizedBox(width: 10), // 버튼 사이의 간격 조정
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEDEDED), // 배경색 설정
                    foregroundColor: Colors.black, // 텍스트 색상 설정 (필요에 따라 조정)
                  ),
                  onPressed: () {
                    // 달력 버튼 클릭 시 동작
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage())); // CalendarPage는 실제 구현된 페이지여야 함
                  },
                  child: Text("달력"),
                ),
                SizedBox(width: 10), // 버튼 사이의 간격 조정
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEDEDED), // 배경색 설정
                    foregroundColor: Colors.black, // 텍스트 색상 설정 (필요에 따라 조정)
                  ),
                  onPressed: () {
                    // 고정 버튼 클릭 시 동작
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => FixedPage())); // FixedPage는 실제 구현된 페이지여야 함
                  },
                  child: Text("고정"),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MonthlyExpense_page(),
  ));
}



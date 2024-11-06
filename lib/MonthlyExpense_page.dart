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

  void previousMonth(){
    setState(() {
      currentMonth = (currentMonth-1)<1?12:currentMonth-1;
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = (currentMonth + 1) > 12 ? 1 : currentMonth + 1;
    });
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

  Widget _buildHeader() {
    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);

    return Container(
      // padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: previousMonth,
                icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
              ),
              Text(
                '$currentMonth월',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: nextMonth,
                icon: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('지출: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                '${formattedMonthlyExpense} 원',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('수입: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                ' 원',
                style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Map<String, List<Map<String,dynamic>>> groupedExpenses={};
    for(var expense in categoryExpense){
      String date = expense['date'];
      if(!groupedExpenses.containsKey(date)){
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             _buildHeader(),

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



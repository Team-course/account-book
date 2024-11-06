import 'package:account_book/MonthlyExpense_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'myAccount_page.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'service/ExpenseService.dart';
import 'asset_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageApp createState() => HomePageApp();
}

class HomePageApp extends State<HomePage> {
  final ExpenseService expenseService = ExpenseService();

  // 동적 텍스트
  String currentMoney = "5,760,000 원";
  double monthlyExpense =0.0;
  double todayExpense = 0.0;
  String financial_schedule= " 교통비 ";
  int containerCount = 3;  // 동적으로 변하는 아이템 수

  List<Map<String,String>>bankAccounts = [
    {'bank': '다원은행', 'balance': '1,500,000 원'},
    {'bank': '정인은행', 'balance': '2,200,000 원'},
    {'bank': '경미은행', 'balance': '2,060,000 원'},
  ];
  @override
  void initState(){
    super.initState();
    loadTotalExpense(1);
    loadTodayExpense(1);
  }

  Future<void> loadTotalExpense(int userId) async{
    DateTime now = DateTime.now();
    String startDate = DateFormat('yyyy-MM-01').format(now); // 현재 월의 첫째 날
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));

    double expense = await expenseService.fetchTotalExpense(userId,startDate,endDate);
    setState(() {
      monthlyExpense = expense;
    });
  }

  Future<void> loadTodayExpense(int userId) async{
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    double expense = await expenseService.fetchTotalExpense(userId, today, today);
    setState(() {
      todayExpense = expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 금액 포맷팅
    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);
    String formattedTodayExpense = NumberFormat('#,##0').format(todayExpense);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(title: Text("Home Page")),
        body: Column(
          children: [
            // 첫 번째 컨테이너
            Container(
              width: 350,
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "입출금 계좌",
                        style: TextStyle(fontSize: 17,
                        color: Color(0xFF989898)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            currentMoney,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SecondPage()),
                            );
                          },style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBEE8F1), // 버튼 배경색 설정
                        ),
                          child: Text("송금"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // 동적 아이템 생성 부분
                    Expanded(
                      child: ListView.builder(
                        itemCount: bankAccounts.length,  // 아이템 수
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.account_balance, size: 50),  // 그림 아이콘
                              Text(
                                bankAccounts[index]['bank']!,  // 은행 이름
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                bankAccounts[index]['balance']!,  // 은행 잔액
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  print("Button $index clicked");
                                },
                                child: Text(
                                  ">",
                                  style: TextStyle(
                                    fontSize: 18, // 크기 조정
                                    color: Colors.black, // 색상 설정
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 두 번째 컨테이너
            Container(
              width: 350,
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,  // 컨테이너 배경을 흰색으로 설정
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "이번 달 지출",
                        style: TextStyle(fontSize: 17,
                        color: Color(0xFF989898))
                    ),
                    SizedBox(height: 10),
                    // 두 번째 컨테이너의 동적 아이템 생성 부분
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$formattedMonthlyExpense 원',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AssetPage()),
                            );
                          },
                          child: Text(
                            ">",
                            style: TextStyle(
                              fontSize: 18, // 크기 조정
                              color: Colors.black, // 색상 설정
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: containerCount, // 아이템 수
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                              children: [
                                Icon(Icons.receipt, size: 40, color: Colors.green),
                              SizedBox(width:10),
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,// 그림 아이콘
                              children: [
                                Text("오늘의 지출"),
                                Text(
                                  '$formattedTodayExpense 원'
                                  ),
                                ],
                              ),
                              ],
                              ),
                              TextButton(
                                onPressed: () {
                                  print("Button $index clicked");
                                },
                                child: Text(
                                  ">",
                                  style: TextStyle(
                                    fontSize: 18, // 크기 조정
                                    color: Colors.black, // 색상 설정
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),

                    // 두 번째 ListView
                    Expanded(
                      child: ListView.builder(
                        itemCount: containerCount, // 아이템 수
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ // 그림 아이콘
                              Row(
                              children: [
                                Icon(Icons.calendar_month_outlined, size: 40, color: Colors.blue),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("금융일정"),
                                  Text(
                                    financial_schedule
                                    ),
                                  ],
                                ),
                              ],
                              ),
                              TextButton(
                                onPressed: () {
                                  print("Button $index clicked");
                                },
                                child: Text(
                                  ">",
                                  style: TextStyle(
                                    fontSize: 18, // 크기 조정
                                    color: Colors.black, // 색상 설정
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    // 추가적인 칸
                    Container(
                      height: 50, // 추가 칸의 높이
                      decoration: BoxDecoration(
                        color: Color(0xFFBEE8F1), // 배경색을 #BEE8F1로 설정
                        borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
                      ), // 배경색을 회색으로 설정
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0), // 왼쪽 여백
                            child: Text(
                              "카드 지출",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF989898)),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0), // 오른쪽 여백
                                child: Text(
                                  '$formattedMonthlyExpense', // 동적 문자열
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward), // 화살표 아이콘
                                onPressed: () {
                                  // 버튼 클릭 시 동작할 내용
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


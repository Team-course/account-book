import 'package:flutter/material.dart';
import 'myAccount_page.dart';

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
  // 동적 텍스트
  String currentMoney = "- 원";
  String monthlyExpense = " -원";
  String todayExpense = " - 원";
  String financial_schedule= " 교통비 ";
  int containerCount = 3;  // 동적으로 변하는 아이템 수

  @override
  Widget build(BuildContext context) {
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
                        style: TextStyle(fontSize: 17),
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
                          },
                          child: Text("송금"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // 동적 아이템 생성 부분
                    Expanded(
                      child: ListView.builder(
                        itemCount: containerCount,  // 아이템 수
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.image, size: 50),  // 그림 아이콘
                              Text("아이템 $index"),  // 동적 텍스트
                              ElevatedButton(
                                onPressed: () {
                                  print("Button $index clicked");
                                },
                                child: Icon(Icons.arrow_forward),  // 동적 버튼
                              ),
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
                        style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    // 두 번째 컨테이너의 동적 아이템 생성 부분
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthlyExpense,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SecondPage()),
                            );
                          },
                          child: Icon(Icons.arrow_forward)
                        ),
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
                              Icon(Icons.image, size: 50),
                              SizedBox(width:10),
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,// 그림 아이콘
                              children: [
                                Text("오늘의 지출"),
                                Text(
                                  todayExpense
                                  ),
                                ],
                              ),
                              ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print("Button $index clicked");
                                },
                                child: Icon(Icons.arrow_forward), // '>' 모양 아이콘
                              ),
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
                                Icon(Icons.image, size: 50),
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
                              ElevatedButton(
                                onPressed: () {
                                  print("Button ${index + containerCount} clicked");
                                },
                                child: Icon(Icons.arrow_forward), // '>' 모양 아이콘
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    // 추가적인 칸
                    Container(
                      height: 50, // 추가 칸의 높이
                      color: Colors.grey[200], // 배경색을 회색으로 설정
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0), // 왼쪽 여백
                            child: Text(
                              "카드 지출",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0), // 오른쪽 여백
                                child: Text(
                                  "5000원", // 동적 문자열
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

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Page")),
      body: Center(child: Text("This is the second page")),
    );
  }
}


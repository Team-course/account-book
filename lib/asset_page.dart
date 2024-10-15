import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For the donut chart

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final CalendarController controller = Get.put(CalendarController()); // controller 초기화

  // Transactions list for "내역" tab
  final List<Map<String, String>> transactions = [
    {'date': '24일', 'title': '카카오페이', 'amount': '-21,000원'},
    {'date': '24일', 'title': '송금 내역', 'amount': '-11,000원'},
    {'date': '24일', 'title': '네이버페이', 'amount': '-14,000원'},
    {'date': '23일', 'title': '송금 내역', 'amount': '+51,000원'},
    {'date': '23일', 'title': '네이버페이', 'amount': '-21,000원'},
    {'date': '23일', 'title': '카카오페이', 'amount': '-34,000원'},
  ];

  // Data for fixed expenses (used in both chart and list)
  final List<FixedExpense> fixedExpenses = [
    FixedExpense('보험', 192000, Colors.blue),
    FixedExpense('적금', 50000, Colors.lightBlue),
    FixedExpense('통신비', 92000, Colors.lightBlueAccent),
    FixedExpense('교통비', 55000, Colors.cyan),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildContentTab(
                      context, '9월', '1,230,500원', '2,310,200원', true),
                  _buildCalendarTab(context), // 수정된 달력 탭
                  _buildFixedExpenseTab(context),
                ],
              ),
            ),
            Container(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(text: '내역'),
                  Tab(text: '달력'),
                  Tab(text: '고정'),
                ],
              ),
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  // 내역 탭
  Widget _buildContentTab(BuildContext context, String month, String expense,
      String income, bool showTransactions) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('지출: ',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(expense,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Text('수입: ',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(income,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        if (showTransactions)
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final currentTransaction = transactions[index];
                final previousTransaction =
                index > 0 ? transactions[index - 1] : null;

                final showDate = previousTransaction == null ||
                    currentTransaction['date'] != previousTransaction['date'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          currentTransaction['date']!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    _buildTransactionItem(
                      context,
                      currentTransaction['title']!,
                      currentTransaction['amount']!,
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  // 달력 탭
  Widget _buildCalendarTab(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                controller.previousMonth(); // 이전 달로 이동
              },
              icon: Icon(Icons.arrow_back_ios, size: 15, color: Colors.black),
            ),
            Flexible(
              child: Center(
                child: Obx(
                      () => Text(
                    '${controller.month}월', // 동적으로 현재 달 표시
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                controller.nextMonth(); // 다음 달로 이동
              },
              icon: Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < controller.week.length; i++)
              Flexible(
                child: Text(
                  controller.week[i],
                  style: TextStyle(
                    color: i == 0 ? Colors.red : i == controller.week.length - 1 ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        Expanded( // 이 부분이 달력의 6주를 화면에 맞게 조정해줍니다
          child: Column(
            children: [
              for (var i = 0; i < 6; i++) Expanded(child: calendarDay(i)), // 6주를 적절히 화면에 맞춤
            ],
          ),
        ),
      ],
    );
  }

  // 주별로 일자를 출력하는 위젯
  Widget calendarDay(int num) {
    int iz = num * 7;
    int yz = (num + 1) * 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var i = iz; i < yz; i++)
          if (i < controller.days.length) // 인덱스가 days 리스트의 길이를 초과하지 않도록 체크
            Obx(() {
              final dayData = controller.days[i];
              final isInMonth = dayData["inMonth"];
              final income = dayData["income"];
              final expense = dayData["expense"];

              return Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isInMonth ? Colors.white : Colors.white, // 월에 속하지 않는 칸의 색상 지정
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayData["day"].toString(), // 일자 출력
                        style: TextStyle(
                          fontSize: 14,
                          color: isInMonth ? Colors.black : Colors.grey, // 월에 속하지 않는 일자는 회색 처리
                        ),
                      ),
                      if (isInMonth) ...[
                        SizedBox(height: 5),
                        if(income !=0)
                          Text(
                            '+ ${dayData["income"]}원',
                            style: TextStyle(fontSize: 8, color: Colors.green), // 수입 표시
                          )
                        else
                          Text(
                            '    ',
                            style: TextStyle(fontSize: 8, color: Colors.white), // 수입 표시
                          ),
                        if (expense != 0)
                          Text(
                            '- ${dayData["expense"]}원',
                            style: TextStyle(fontSize: 8, color: Colors.red), // 지출 표시
                          )
                        else
                          Text(
                            '    ',
                            style: TextStyle(fontSize: 8, color: Colors.white), // 수입 표시
                          ),
                      ],
                    ],
                  ),
                ),
              );
            })
          else
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(''), // 빈칸을 채우기
              ),
            ),
      ],
    );
  }

  // 고정 탭 (도넛 차트와 확장 가능한 리스트)
  Widget _buildFixedExpenseTab(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '9월',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('지출: ',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('1,230,500원',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Text('수입: ',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('2,310,200원',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<FixedExpense, String>(
                      dataSource: fixedExpenses,
                      pointColorMapper: (FixedExpense data, _) => data.color,
                      xValueMapper: (FixedExpense data, _) => data.category,
                      yValueMapper: (FixedExpense data, _) => data.amount,
                      innerRadius: '60%',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildFixedExpenseItem('보험', '192,000원', Colors.blue),
                    _buildFixedExpenseItem('적금', '50,000원', Colors.lightBlue),
                    _buildExpandableExpenseItem(
                        '통신비',
                        '92,000원',
                        [
                          _buildSubExpenseItem('인터넷', '20,000원'),
                          _buildSubExpenseItem('휴대폰', '72,000원'),
                        ],
                        Colors.lightBlueAccent),
                    _buildFixedExpenseItem('교통비', '55,000원', Colors.cyan),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 고정 지출 항목 위젯
  Widget _buildFixedExpenseItem(
      String title, String amount, Color circleColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: circleColor,
        radius: 10,
      ),
      title: Text(title),
      trailing: Text(amount),
    );
  }

  // 확장 가능한 지출 항목
  Widget _buildExpandableExpenseItem(
      String title, String amount, List<Widget> subItems, Color circleColor) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: circleColor,
        radius: 10,
      ),
      title: Text(title),
      trailing: Text(amount),
      children: subItems,
    );
  }

  // 서브 지출 항목 위젯
  Widget _buildSubExpenseItem(String subTitle, String subAmount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        title: Text(subTitle),
        trailing: Text(subAmount),
      ),
    );
  }

  // 내역 항목
  Widget _buildTransactionItem(
      BuildContext context, String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.sync_alt, color: Colors.grey),
          radius: 10,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('이체 | 입출금통장'),
        trailing: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: amount.startsWith('-') ? Colors.black : Colors.blue,
          ),
        ),
      ),
    );
  }
}

// CalendarController 정의
class CalendarController extends GetxController {
  // 현재 월을 저장하는 Rx 변수
  RxInt month = DateTime.now().month.obs;

  // 요일 데이터
  List<String> week = ['일', '월', '화', '수', '목', '금', '토'];

  // 현재 월에 해당하는 날짜 리스트
  RxList days = <Map<String, dynamic>>[].obs;

  // Sample transaction data mapped by day
  Map<int, Map<String, dynamic>> dailyTransactions = {
    23: {'income': 51000, 'expense': 56000},
    24: {'income': 0, 'expense': 46000},
    // Add other days with income and expense data as needed
  };

  @override
  void onInit() {
    super.onInit();
    _generateDays(month.value);
  }

  // 이전 달로 이동하는 함수
  void previousMonth() {
    month.value = (month.value == 1) ? 12 : month.value - 1;
    _generateDays(month.value);
  }

  // 다음 달로 이동하는 함수
  void nextMonth() {
    month.value = (month.value == 12) ? 1 : month.value + 1;
    _generateDays(month.value);
  }

  // 날짜 데이터를 생성하는 함수
  void _generateDays(int month) {
    days.clear();
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, month, 1);
    int lastDay = DateTime(DateTime.now().year, month + 1, 0).day;
    int startingWeekday = firstDayOfMonth.weekday % 7; // 첫 날이 무슨 요일인지 계산 (일요일 = 0)

    // 첫 번째 주 앞쪽에 빈칸 추가
    for (var i = 0; i < startingWeekday; i++) {
      days.add({
        "day": '',
        "inMonth": false,
        "income": 0,
        "expense": 0,
      });
    }

    // 현재 월의 날짜들 추가
    for (var i = 1; i <= lastDay; i++) {
      // 해당 날짜에 거래가 있으면 추가
      var transaction = dailyTransactions[i] ?? {"income": 0, "expense": 0};
      days.add({
        "year": DateTime.now().year,
        "month": month,
        "day": i,
        "inMonth": true,
        "income": transaction["income"],
        "expense": transaction["expense"],
      });
    }

    // 마지막 주의 빈칸 수 계산
    int remainingDays = 7 - (days.length % 7);
    if (remainingDays != 7) {
      for (var i = 0; i < remainingDays; i++) {
        days.add({
          "day": '',
          "inMonth": false,
          "income": 0,
          "expense": 0,
        });
      }
    }
  }
}

// Model class for fixed expense data
class FixedExpense {
  FixedExpense(this.category, this.amount, this.color);

  final String category;
  final double amount;
  final Color color;
}

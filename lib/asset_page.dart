import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'service/ExpenseService.dart';
import 'package:intl/intl.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> with TickerProviderStateMixin {
  final ExpenseService expenseService = ExpenseService();
  late TabController _tabController;
  final CalendarController contentTabController = CalendarController();
  final CalendarController calendarTabController = CalendarController();
  final CalendarController fixedTabController = CalendarController();
  final CalendarController expenseController = CalendarController();

  double monthlyExpense = 0.0;
  List<dynamic> categoryExpense = []; // 지출 항목 리스트 추가
  int userId = 1; // 사용자 ID
  DateTime selectedDate = DateTime.now();

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
    loadMonthlyExpense(userId,selectedDate);
    expenseController.loadMonthlyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadMonthlyExpense(int userId, DateTime selectedDate) async {

    String startDate = DateFormat('yyyy-MM-01').format(selectedDate); // 월의 첫째 날
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // 오늘 날짜

    var result = await expenseService.fetchMonthlyExpense(userId, startDate, endDate);

    setState(() {
      monthlyExpense = result['totalExpense'];
      categoryExpense = result['categoryExpense'];
    });
  }

  // 각 날짜별 거래 데이터 (수입, 지출)
  Map<int, Map<String, dynamic>> dailyTransactions = {};

  // 현재 월에 해당하는 날짜 리스트
  //RxList days = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> days = <Map<String, dynamic>>[].obs;

  // 월의 날짜 데이터 가져오기
  Future<void> loadMonthlyData() async {
    // 현재 월을 저장하는 Rx 변수
    //RxInt month = DateTime.now().month.obs;
    RxInt month = calendarTabController.month; // 달력 탭의 선택된 월을 사용
    int userId = 1;

    // 현재 월에 해당하는 시작일과 종료일 계산
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, month.value, 1);
    DateTime lastDayOfMonth = DateTime(DateTime.now().year, month.value + 1, 0);

    String startDate = '${firstDayOfMonth.toIso8601String().split('T')[0]}'; // YYYY-MM-DD 형식
    String endDate = '${lastDayOfMonth.toIso8601String().split('T')[0]}'; // YYYY-MM-DD 형식

    // 고정된 시작일과 종료일
    // String startDate = '2024-10-01'; // YYYY-MM-DD 형식
    // String endDate = '2024-10-31';   // YYYY-MM-DD 형식

    print('Start Date: $startDate'); // 디버깅용 출력
    print('End Date: $endDate'); // 디버깅용 출력

    try{
      var monthlyData = await expenseService.fetchMonthlyExpense(userId, startDate, endDate);

      // 날짜별 지출 데이터 초기화
      Map<int, double> dailyExpenses = {}; // 날짜별 지출을 저장할 맵

      // 카테고리별 지출 데이터 처리
      if (monthlyData.containsKey('categoryExpense')) {
        for (var entry in monthlyData['categoryExpense']) {
          // 날짜를 파싱하고 해당 날짜에 대한 지출을 누적
          String date = entry['date'];
          double amount = entry['amount']?.toDouble() ?? 0.0; // null 체크

          int day = DateTime.parse(date).day;

          // 날짜별로 누적 지출 금액 저장
          dailyExpenses[day] = (dailyExpenses[day] ?? 0) + amount; // 기존 금액에 더하기
        }
      }

      // days 리스트 초기화 후 날짜 생성
      days.clear();
      dailyTransactions.clear();
      for (var i = 1; i <= 31; i++) {
        double expense = dailyExpenses[i] ?? 0.0; // 해당 날짜의 지출이 없으면 0으로 설정

        // dailyTransactions에 데이터 추가
        dailyTransactions[i] = {
          'income': 0, // 수입은 기본적으로 0으로 설정
          'expense': expense, // 각 날짜의 지출
        };

        // // dailyTransactions 업데이트
        // dailyTransactions[i] = {
        //   'income': 0, // 기본적으로 수입은 0
        //   'expense': expense, // 각 날짜의 지출
        // };

        dailyTransactions = {
          23: {'income': 30000, 'expense': 0}, // 23일에 income 30000 추가
          28: {'income': 63000, 'expense': 0}, // 28일에 income 63000 추가
        };

        days.add({
          'day': i,
          'inMonth': true,
          'income': dailyTransactions[i]?['income'] ?? 0, // 수입은 기본적으로 0으로 설정
          'expense': expense, // 각 날짜의 지출
        });
      }

      setState(() {});

      // 날짜별 총 지출 출력
      print("날짜별 총 지출:");
      dailyTransactions.forEach((day, transaction) {
        print("날짜: ${day}, 총 지출: ${transaction['expense']}");
      });
    }catch(e,stackTrace){
      print("Error: $e");
      print("Stack Trace: $stackTrace");
    }
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
                  _buildContentTab(context),
                  _buildCalendarTab(context),
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

  // 중복되는 상단 정보를 공통으로 출력하는 함수
  Widget _buildHeader(CalendarController controller, String expense, String income) {

    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);
    DateTime selectedDate = DateTime.now();  // 기본값을 현재 날짜로 설정
    DateTime previousMonth = DateTime(selectedDate.year, selectedDate.month - 1);
    DateTime nextMonth = DateTime(selectedDate.year, selectedDate.month + 1);


    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    controller.previousMonth();
                    loadMonthlyData();
                    // loadMonthlyExpense(userId,previousMonth);
                  });
                  // controller.previousMonth();
                  // loadMonthlyData();
                  // loadMonthlyExpense(userId,previousMonth);
                },
                icon: Icon(Icons.arrow_back_ios, size: 10, color: Colors.black),
              ),
              Text(
                '${controller.month}월',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    controller.nextMonth();
                    loadMonthlyData();
                    loadMonthlyExpense(userId,nextMonth);
                  });
                  // controller.nextMonth();
                  // loadMonthlyData();
                  // loadMonthlyExpense(userId,nextMonth);
                },
                icon: Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              Text('지출: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('${formattedMonthlyExpense} 원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Text('수입: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(income, style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }


  // 내역 탭
  Widget _buildContentTab(BuildContext context) {

    Map<String, List<Map<String,dynamic>>> groupedExpenses={};

    for(var expense in categoryExpense){
      String date = expense['date'];
      if(!groupedExpenses.containsKey(date)){
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }

    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);

    return Column(
      children: [
        _buildHeader(contentTabController, '$formattedMonthlyExpense 원', '2,310,200원'),
        Expanded(
          child: ListView(
            children: groupedExpenses.entries.map((entry) {
              String date = entry.key;
              List<Map<String, dynamic>> expensesForDate = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      '${DateTime.parse(date).day}일', // 날짜에서 '일' 부분만 추출
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  ...expensesForDate.map((expense) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝으로 배치
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(Icons.category, color: Colors.grey), // 왼쪽에 아이콘 추가
                                SizedBox(width: 25), // 아이콘과 카테고리 사이 간격
                                Text(
                                  expense['category'],
                                  style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              '-${expense['amount']} 원',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 4), // 카테고리와 '이체/입출금통장' 사이 간격
                        Row(
                          children: [
                            SizedBox(width: 70), // 아이콘과 카테고리 간격 만큼 띄우기
                            Text(
                              '이체/입출금통장', // 추가할 텍스트
                              style: TextStyle(fontSize: 14, color: Colors.grey), // 작은 글씨와 회색
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(
                    color: Color(0xFF989898),
                    thickness: 0.5,
                    indent: 16.0,
                    endIndent: 16.0,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 달력 탭
  Widget _buildCalendarTab(BuildContext context) {
    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);

    return Column(
      children: [
        _buildHeader(calendarTabController, '$formattedMonthlyExpense 원', '2,310,200원'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

          ],
        ),
        SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < calendarTabController.week.length; i++)
              Flexible(
                child: Text(
                  calendarTabController.week[i],
                  style: TextStyle(
                    color: i == 0
                        ? Colors.red
                        : i == calendarTabController.week.length - 1
                        ? Colors.blue
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: Obx(() => Column(
            children: [
              for (var i = 0; i < 6; i++) Expanded(child: calendarDay(i)), // 6주를 적절히 화면에 맞춤
            ],
          )),
        ),
      ],
    );
  }

  // 고정 탭 (도넛 차트와 확장 가능한 리스트)
  Widget _buildFixedExpenseTab(BuildContext context) {
    String formattedMonthlyExpense = NumberFormat('#,##0').format(monthlyExpense);

    return Column(
      children: [
        _buildHeader(fixedTabController, '$formattedMonthlyExpense 원', '2,310,200원'),
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
                    _buildExpandableExpenseItem(
                        '보험',
                        '192,000원',
                        [
                          _buildSubExpenseItem('생명보험', '120,000원'),
                          _buildSubExpenseItem('건강보험', '72,000원'),
                        ],
                        Colors.blue),
                    _buildExpandableExpenseItem(
                        '적금',
                        '50,000원',
                        [
                          _buildSubExpenseItem('정기적금', '30,000원'),
                          _buildSubExpenseItem('자유적립식', '20,000원'),
                        ],
                        Colors.lightBlue),
                    _buildExpandableExpenseItem(
                        '통신비',
                        '92,000원',
                        [
                          _buildSubExpenseItem('인터넷', '20,000원'),
                          _buildSubExpenseItem('휴대폰', '72,000원'),
                        ],
                        Colors.lightBlueAccent),
                    _buildExpandableExpenseItem(
                        '교통비',
                        '55,000원',
                        [
                          _buildSubExpenseItem('지하철', '30,000원'),
                          _buildSubExpenseItem('버스', '25,000원'),
                        ],
                        Colors.cyan),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  // 주별로 일자를 출력하는 위젯
  Widget calendarDay(int num) {
    int iz = num * 7;
    int yz = (num + 1) * 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var i = iz; i < yz; i++)
          if (i < calendarTabController.days.length) // 인덱스가 days 리스트의 길이를 초과하지 않도록 체크
            Obx(() {
              final dayData = calendarTabController.days[i];
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
                        if (income != 0)
                          Text(
                            '+ ${dayData["income"]}원',
                            style: TextStyle(fontSize: 8, color: Colors.green), // 수입 표시
                          )
                        else
                          Text(
                            '    ',
                            style: TextStyle(fontSize: 8, color: Colors.white), // 수입 표시
                          ),
                        if (expense.isNotEmpty)
                          Text(
                            '- ${dayData["expense"]}',
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
}

// CalendarController 정의
class CalendarController extends GetxController {
  final ExpenseService expenseService = ExpenseService();

  // 현재 월을 저장하는 Rx 변수
  RxInt month = DateTime.now().month.obs;

  // 요일 데이터
  List<String> week = ['일', '월', '화', '수', '목', '금', '토'];

  // 현재 월에 해당하는 날짜 리스트
  //RxList days = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> days = <Map<String, dynamic>>[].obs;

  // 각 날짜별 거래 데이터 (수입, 지출)
  //Map<int, Map<String, dynamic>> dailyTransactions = {};
  // 각 날짜별 거래 데이터 (수입, 지출)
  Map<int, Map<String, dynamic>> dailyTransactions = {
    23: {'income': 30000, 'expense': 0}, // 23일에 income 30000 추가
    28: {'income': 63000, 'expense': 0}, // 28일에 income 63000 추가
  };


  // 월의 날짜 데이터 가져오기
  Future<void> loadMonthlyData() async {
    int userId = 1;

    // 현재 월에 해당하는 시작일과 종료일 계산
    // DateTime firstDayOfMonth = DateTime(DateTime.now().year, month.value, 1);
    // DateTime lastDayOfMonth = DateTime(DateTime.now().year, month.value + 1, 0);
    //
    // String startDate = '${firstDayOfMonth.toIso8601String().split('T')[0]}'; // YYYY-MM-DD 형식
    // String endDate = '${lastDayOfMonth.toIso8601String().split('T')[0]}'; // YYYY-MM-DD 형식

    // 고정된 시작일과 종료일
    // String startDate = '2024-10-01'; // YYYY-MM-DD 형식
    // String endDate = '2024-10-31';   // YYYY-MM-DD 형식

    DateTime firstDayOfMonth = DateTime(DateTime.now().year, month.value, 1);
    DateTime lastDayOfMonth = DateTime(DateTime.now().year, month.value + 1, 0);

    String startDate = '${firstDayOfMonth.toIso8601String().split('T')[0]}'; // YYYY-MM-DD 형식
    String endDate = '${lastDayOfMonth.toIso8601String().split('T')[0]}'; // YYYY-MM-DD 형식


    print('Start Date: $startDate'); // 디버깅용 출력
    print('End Date: $endDate'); // 디버깅용 출력

    try{
      var monthlyData = await expenseService.fetchMonthlyExpense(userId, startDate, endDate);

    // 날짜별 지출 데이터 초기화
    Map<int, double> dailyExpenses = {}; // 날짜별 지출을 저장할 맵

    // 카테고리별 지출 데이터 처리
    if (monthlyData.containsKey('categoryExpense')) {
      for (var entry in monthlyData['categoryExpense']) {
        // 날짜를 파싱하고 해당 날짜에 대한 지출을 누적
        String date = entry['date'];
        double amount = entry['amount']?.toDouble() ?? 0.0; // null 체크

        int day = DateTime.parse(date).day;
        // 날짜별로 누적 지출 금액 저장
        dailyExpenses[day] = (dailyExpenses[day] ?? 0) + amount; // 기존 금액에 더하기
      }
      }

    // days 리스트 초기화 후 날짜 생성
    days.clear();
    for (var i = 1; i <= 31; i++) {

      double expense = dailyExpenses[i] ?? 0; // 해당 날짜의 지출이 없으면 0으로 설정

      String expenseDisplay = expense > 0 ? "${expense}원" : "";

      // 만약 dailyTransactions[i]에 이미 값이 있으면 income 값을 유지하고 expense만 업데이트
      if (dailyTransactions.containsKey(i)) {
        dailyTransactions[i]!['expense'] = expense;
      } else {
        // 새로운 날짜에 대해 초기화
        dailyTransactions[i] = {
          'income': 0, // 기본적으로 수입은 0으로 설정
          'expense': expense, // 각 날짜의 지출
        };
      }
      //dailyTransactions에 데이터 추가
      // dailyTransactions[i] = {
      //   'income': 0, // 수입은 기본적으로 0으로 설정
      //   'expense': expense, // 각 날짜의 지출
      // };

      days.add({
        'day': i,
        'inMonth': true,
        'income': dailyTransactions[i]?['income'] ?? 0, // 수입은 기본적으로 0으로 설정
        'expense': expenseDisplay
        //dailyExpenses[i]??0.0, // 각 날짜의 지출
      });
    }

    // 날짜별 총 지출 출력
    print("날짜별 총 지출:");
    dailyTransactions.forEach((day, transaction) {
      print("날짜: ${day}, 총 지출: ${transaction['expense']}");
    });
  }catch(e,stackTrace){
      print("Error: $e");
      print("Stack Trace: $stackTrace");
      }
    }

  // Sample transaction data mapped by day
  // Map<int, Map<String, dynamic>> dailyTransactions = {
  //   23: {'income': 51000, 'expense': 56000},
  //   24: {'income': 0, 'expense': 46000},
  //   // Add other days with income and expense data as needed
  // };

  @override
  void onInit() {
    super.onInit();
    _generateDays(month.value);  // 초기 데이터를 로드
    Future.delayed(Duration.zero, () {
      update();  // 즉시 갱신을 트리거
    });
  }

  // 이전 달로 이동하는 함수
  void previousMonth() {
    month.value = (month.value == 1) ? 12 : month.value - 1;
    _generateDays(month.value);
    loadMonthlyData();
}

  // 다음 달로 이동하는 함수
  void nextMonth() {
    month.value = (month.value == 12) ? 1 : month.value + 1;
    _generateDays(month.value);
    loadMonthlyData();
  }

  // 날짜 데이터를 생성하는 함수
  void _generateDays(int month) {
    print('Generating days for month: $month'); // 디버깅용 출력
    days.clear();
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, month, 1);
    int lastDay = DateTime(DateTime.now().year, month == 12 ? 12 : month + 1, 0).day;
    int startingWeekday = firstDayOfMonth.weekday % 7; // 첫 날이 무슨 요일인지 계산 (일요일 = 0)

    // 첫 번째 주 앞쪽에 빈칸 추가
    for (var i = 0; i < startingWeekday; i++) {
      days.add({
        "day": '',
        "inMonth": false,
        "income": 0,
        "expense": "",
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
        "expense": transaction["expense"]>0?"${transaction["expense"]}":"",
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
          "expense": "",
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

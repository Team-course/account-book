import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For the donut chart

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> with TickerProviderStateMixin {
  late TabController _tabController;

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
                  _buildContentTab(context, '9월', '1,230,500원', '2,310,200원', true), // 내역 탭
                  _buildContentTab(context, '9월', '1,230,500원', '2,310,200원', false), // 달력 탭
                  _buildFixedExpenseTab(context), // 고정 탭 with donut chart and expandable list
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

  // 내역 and 달력 tabs
  Widget _buildContentTab(BuildContext context, String month, String expense, String income, bool showTransactions) {
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
                  Text('지출: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(expense, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        ),
        if (showTransactions)
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final currentTransaction = transactions[index];
                final previousTransaction = index > 0 ? transactions[index - 1] : null;

                final showDate = previousTransaction == null || currentTransaction['date'] != previousTransaction['date'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

  // 고정 tab with donut chart and expandable list
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
                  Text('지출: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('1,230,500원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Text('수입: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text('2,310,200원', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // Donut chart for fixed expenses
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
              // Expandable List
              Expanded(
                child: ListView(
                  children: [
                    _buildFixedExpenseItem('보험', '192,000원', Colors.blue),
                    _buildFixedExpenseItem('적금', '50,000원', Colors.lightBlue),
                    _buildExpandableExpenseItem('통신비', '92,000원', [
                      _buildSubExpenseItem('인터넷', '20,000원'),
                      _buildSubExpenseItem('휴대폰', '72,000원'),
                    ], Colors.lightBlueAccent),
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

  // Helper for individual fixed expense item
  Widget _buildFixedExpenseItem(String title, String amount, Color circleColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: circleColor,
        radius: 10, // Adjust this value to make the circle smaller
      ),
      title: Text(title),
      trailing: Text(amount),
    );
  }

  // Helper for expandable expense item
  Widget _buildExpandableExpenseItem(String title, String amount, List<Widget> subItems, Color circleColor) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: circleColor,
        radius: 10, // Adjust this value to make the circle smaller
      ),
      title: Text(title),
      trailing: Text(amount),
      children: subItems,
    );
  }

  // Helper for sub-expense items in expandable list
  Widget _buildSubExpenseItem(String subTitle, String subAmount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        title: Text(subTitle),
        trailing: Text(subAmount),
      ),
    );
  }

  // Individual transaction item for 내역 tab
  Widget _buildTransactionItem(BuildContext context, String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.sync_alt, color: Colors.grey),
          radius: 10, // Adjust the size of this circle as well
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

// Model class for fixed expense data
class FixedExpense {
  FixedExpense(this.category, this.amount, this.color);
  final String category;
  final double amount;
  final Color color;
}

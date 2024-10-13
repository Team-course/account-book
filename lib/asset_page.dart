import 'package:flutter/material.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> transactions = [
    {'date': '24일', 'title': '카카오페이', 'amount': '-21,000원'},
    {'date': '24일', 'title': '송금 내역', 'amount': '-11,000원'},
    {'date': '24일', 'title': '네이버페이', 'amount': '-14,000원'},
    {'date': '23일', 'title': '송금 내역', 'amount': '+51,000원'},
    {'date': '23일', 'title': '네이버페이', 'amount': '-21,000원'},
    {'date': '23일', 'title': '카카오페이', 'amount': '-34,000원'},
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
                  _buildContentTab(context, '9월', '1,230,500원', '2,310,200원', true), // 내역 탭 - ListView 포함
                  _buildContentTab(context, '9월', '1,230,500원', '2,310,200원', false), // 달력 탭 - ListView 제거
                  _buildContentTab(context, '9월', '1,230,500원', '2,310,200원', false), // 고정 탭 - ListView 제거
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

  // Modify the function to include a 'showTransactions' parameter
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
        // Show ListView only if showTransactions is true
        if (showTransactions)
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final currentTransaction = transactions[index];
                final previousTransaction = index > 0 ? transactions[index - 1] : null;

                // 날짜가 이전과 다를 때만 날짜를 출력
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

  // 개별 거래 내역 항목 UI
  Widget _buildTransactionItem(BuildContext context, String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.sync_alt, color: Colors.grey),
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

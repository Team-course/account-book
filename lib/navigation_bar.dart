import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';
import 'asset_page.dart';
import 'calendar_page.dart';
import 'my_page.dart';

class NavigationMenu extends StatelessWidget{
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
          () => NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) => controller.selectedIndex.value = index,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: "Asset"),
                NavigationDestination(icon: Icon(Icons.calendar_today), label: "calendar"),
                NavigationDestination(icon: Icon(Icons.person), label: "My Page"),
              ]
          )
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomePage(),
    AssetPage(),
    CalendarPage(),
    MyPage()
    // Container(color: Colors.green),
    // Container(color: Colors.purple),
    // Container(color: Colors.orange),
    // Container(color: Colors.blue)
  ];
}

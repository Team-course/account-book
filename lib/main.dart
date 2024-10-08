import 'package:flutter/material.dart';
import 'navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //UI 요소 화면 출력 정의
  @override
  Widget build(BuildContext context) {
    return MaterialApp(      //앱이 기본 구조와 테마 설정
        title: 'Navigation App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NavigationMenu(),
    );
  }
}
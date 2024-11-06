import 'package:flutter/material.dart';
import 'signIn.dart'; // signIn.dart 파일을 임포트합니다.
import 'navigation_bar.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationMenu()
      //SignInPage(), // SignInPage를 첫 화면으로 설정
    );
  }
}

import 'package:flutter/material.dart';
import 'navigation_bar.dart'; // signIn.dart 파일을 임포트합니다.
import 'signUp.dart';
import 'login.dart';

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
      home: LoginWidget( ), // SignInPage를 첫 화면으로 설정
    );
  }
}

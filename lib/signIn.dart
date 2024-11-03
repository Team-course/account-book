import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ssnFrontController = TextEditingController();
  final TextEditingController ssnBackController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();

  bool _showVerificationFields = false; // 인증 필드를 표시할지 여부를 관리하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('전화 인증'), // 타이틀 제거
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              '휴대폰 본인인증',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '회원여부 확인 및 가입을 진행합니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 30.0),

            // 이름 입력 필드
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => nameController.clear(),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // 주민등록번호 입력 필드
            Row(
              children: [
                Container(
                  width: 130,
                  child: TextField(
                    controller: ssnFrontController,
                    decoration: InputDecoration(
                      labelText: '주민등록번호 앞 6자리',
                      hintText: '주민번호 앞 6자리',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                ),
                SizedBox(width: 10.0),
                Text('-', style: TextStyle(fontSize: 24)),
                SizedBox(width: 10.0),
                Container(
                  width: 190,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ssnBackController,
                          decoration: InputDecoration(
                            labelText: '주민등록번호 뒷 1자리',
                            hintText: '주민번호 뒷 1자리',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                        ),
                      ),
                      Container(
                        width: 60,
                        child: Text('*****', textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),

            // 휴대폰 번호 입력 필드
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: '휴대폰번호',
                hintText: '휴대폰번호 입력',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.0),

            // 인증번호 입력 필드 및 버튼 (인증 요청 버튼 위에 표시)
            if (_showVerificationFields) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: verificationCodeController,
                      decoration: InputDecoration(
                        labelText: '인증번호 6자리 입력',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // 재전송 로직 추가
                      print('인증번호 재전송 요청');
                    },
                    child: Text('재전송'),
                  ),
                ],
              ),
              SizedBox(height: 15.0), // 인증번호 입력 필드와 버튼 간격 조정
            ],

            // 인증 요청 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showVerificationFields = true; // 버튼 클릭 시 필드 표시
                  });
                },
                child: Text('인증 요청'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
            SizedBox(height: 50.0), // 인증 요청 버튼과 다음 요소 간격 조정
          ],
        ),
      ),
    );
  }
}

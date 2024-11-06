import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageWidgetState();
}

class _MyPageWidgetState extends State<MyPage>
    with TickerProviderStateMixin {
  bool switchListTileValue = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white, // Replace FlutterFlowTheme with basic colors
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.black, // Adjust the color as needed
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFBEE8F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                child: Text(
                  'andrea@domainname.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2AC6E8),
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Divider(
                height: 44,
                thickness: 1,
                indent: 24,
                endIndent: 24,
                color: Colors.grey, // Adjust as needed
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile.adaptive(
                            value: switchListTileValue,
                            onChanged: (newValue) {
                              setState(() {
                                switchListTileValue = newValue;
                              });
                            },
                            title: Text(
                              'Notification',
                              style: TextStyle(
                                letterSpacing: 0.0,
                              ),
                            ),
                            tileColor: Colors.white,
                            activeColor: Colors.blue,
                            activeTrackColor: Color(0x3439D2C0),
                            dense: false,
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(12, 0, 4, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Similar changes for other containers...
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  child: Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color
                    side: BorderSide(color: Colors.grey, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/widget/showdialog.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:solviolin/model/user.dart';
import 'package:solviolin/screen/day_change_page.dart';
import 'package:solviolin/screen/reservation_result.dart';

class MainPage extends StatelessWidget {
  final User user;
  final String token;

  MainPage({@required this.user, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 45,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: Text('예약 확인/취소', style: TextStyle(fontSize: 15),),
                  color: Color.fromRGBO(96, 128, 104, 100),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReservationResult(user: user)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 45,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: Text('보강예약', style: TextStyle(fontSize: 15),),
                  color: Color.fromRGBO(96, 128, 104, 100),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DayChange(user: user)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 45,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: Text('홈페이지', style: TextStyle(fontSize: 15),),
                  color: Color.fromRGBO(96, 128, 104, 100),
                  textColor: Colors.white,
                  onPressed: _launchURL,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 45,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  child: Text('QR체크인', style: TextStyle(fontSize: 15),),
                  color: Color.fromRGBO(96, 128, 104, 100),
                  textColor: Colors.white,
                  onPressed: () {
                    _scan(context, user.userID, token);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                child : Text('레슨 취소',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Container(
                child : Text('예약내역/취소 버튼 -> 취소하고싶은 수업 swipe',
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                child : Text('레슨 보강',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Container(
                child : Text('보강예약 버튼 -> 날짜 선택',
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _scan(BuildContext context ,String userID, String token) async {
    print('scanner start');
    //스캔 시작 - 이때 스캔 될때까지 blocking
    var barcode = await BarcodeScanner.scan();
    print(barcode.rawContent);
    qrCheckIn(context , userID,  barcode.rawContent,  token);
    //String photoScanResult = await BarcodeScanner.scan();
    //String barcode = await scanner.scan();
    //스캔 완료하면 _output 에 문자열 저장하면서 상태 변경 요청.
    //setState(() => _output = barcode.rawContent);
  }

}


Future<String> qrCheckIn(BuildContext context ,String userID, String userBranch, String token) async{

  Map data = {
    'userID' : userID,
    'userBranch' : userBranch,
    'token' : token
  };
  String res;
  var response = await http.post(API.POST_QR, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    res = response.body;
    String message = '';
    print(res);
    if(res == 'success'){
      message = '성공적으로 체크인 하였습니다!';
    }else{
      message = '실패하였습니다. 다시 한번 시도해주세요!';
    }
    showMyDialog(context, message);
    return res;
  }else{
    return Future.error('loading fail');
  }
}

_launchURL() async {
  const url = 'http://solviolin.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


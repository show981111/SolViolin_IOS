import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:solviolin/model/user.dart';
import 'package:solviolin/screen/day_change_page.dart';
import 'package:solviolin/screen/reservation_result.dart';

class MainPage extends StatelessWidget {
  final User user;

  MainPage({@required this.user});

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

}

_launchURL() async {
  const url = 'http://solviolin.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


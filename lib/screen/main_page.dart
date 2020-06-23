import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                  color: Colors.green,
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
                  color: Colors.green,
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
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {},
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
                  child: Text('정기예약', style: TextStyle(fontSize: 15),),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                child : Text('예약 방법 설명 적는 칸 블라브라블랍르'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
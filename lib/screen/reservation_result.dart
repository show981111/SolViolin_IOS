import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/model/booked_list.dart';
import 'dart:convert';

import 'package:solviolin/model/user.dart';
import 'package:solviolin/screen/change_result.dart';
import 'package:solviolin/screen/past_result.dart';
import 'package:solviolin/widget/showdialog.dart';

import 'current_result.dart';
import 'main_page.dart';

class ReservationResult extends StatefulWidget {
  final User user;
  ReservationResult({@required this.user});

  _ReservationResultState createState() => _ReservationResultState();
}

class _ReservationResultState extends State<ReservationResult>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(child : Text('이전 달')),
              Tab(child : Text('이번 달')),
              Tab(child : Text('변경내역')),
            ],
          ),
          title: Text('예약 내역'),
        ),
        body: TabBarView(
          children: <Widget>[
            PastResult(user: widget.user),
            CurrentResult(user : widget.user),
            ChangeResult(user : widget.user),
          ],
        ),
      ),
    );
  }


}


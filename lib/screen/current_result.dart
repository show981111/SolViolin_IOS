import 'package:flutter/material.dart';
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/fetchData/getBookedList.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:solviolin/screen/change_result.dart';
import 'package:solviolin/widget/showdialog.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrentResult extends StatefulWidget {
  final User user;

  CurrentResult({@required this.user});

  _CurrentResultState createState() => _CurrentResultState();
}

class _CurrentResultState extends State<CurrentResult> {
  List<BookedList> userBookedList = List<BookedList>();
  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    print(widget.user.userID);
  }

  @override
  Widget build(BuildContext context) {
    //print(userBookedList.length);
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder(
        future: getBookedList(context, widget.user.userID, 'cur'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(userBookedList.length);
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.hasError){
            return Container(
              child: Text('error'),
            );
          }else{
            userBookedList = snapshot.data;
            print(userBookedList.length);
            return  ListView.builder(itemCount:userBookedList.length ,itemBuilder: (context, index) {
              return Slidable(
                controller: slidableController,
                key: ValueKey(index),
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '연장',
                    color: Colors.grey.shade300,
                    icon: Icons.edit,
                    closeOnTap: true,
                    onTap: () {
                      extendRequest(context, widget.user.userID, userBookedList[index].bookedTeacher,userBookedList[index].bookedBranch
                          , userBookedList[index].bookedStartDate, userBookedList[index].bookedEndDate).then((value) {
                            if(value.length > 0 && value.substring(0,1) == '2')
                            {
                              setState(() {
                                userBookedList[index].bookedEndDate = value;
                              });
                            }
                      });
                    },
                  ),
                  IconSlideAction(
                    caption: '취소',
                    color: Colors.grey.shade300,
                    icon: Icons.delete,
                    closeOnTap: true,
                    onTap: () {
                      cancelRequest(context, widget.user.userID, userBookedList[index].bookedTeacher,userBookedList[index].bookedBranch
                          , userBookedList[index].bookedStartDate, userBookedList[index].bookedEndDate, widget.user.userName)
                          .then((value){
                            if(value == 'success'){
                              removeItem(index);
                            }
                      });
                    },
                  )
                ],
                child: ListTile(
                  title: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(userBookedList[index].bookedTeacher+ " / " + userBookedList[index].bookedBranch),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text("시작 : "+userBookedList[index].bookedStartDate),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text("종료 : " + userBookedList[index].bookedEndDate),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
          }
        }
      )
    );
  }

  void removeItem(int index) {
    setState(() {
      userBookedList = List.from(userBookedList)
        ..removeAt(index);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}


Future<String> cancelRequest(BuildContext context ,String userID, String cancelTeacher, String cancelBranch,
    String startDate,String endDate,String userName) async{

  Map data = {
    'userID' : userID,
    'cancelTeacher' : cancelTeacher,
    'cancelBranch' : cancelBranch,
    'startDate' : startDate,
    'endDate' : endDate,
    'userName' : userName,
  };
  String res;
  var response = await http.post(API.POST_CANCELCOURSE, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    res = response.body;
    String message = '';
    switch(res)
    {
      case 'success' :
        message = '성공적으로 수업을 취소하였습니다!';
        break;
      case 'creditOver' :
        message = '취소 가능 횟수를 초과하였습니다!';
        break;
      case 'timeout' :
        message = '취소는 수업시작 4시간 전까지만 가능합니다!';
        break;
      case 'already' :
        message = '이미 취소한 수업입니다!';
        break;
      default :
        message = '오류가 발생했습니다!';
        break;
    }
    showMyDialog(context,message);
    return res;
  }else{
    return Future.error('loading fail');
  }
}

//$userID = $_POST['userID'];
//$extendTeacher = $_POST['extendTeacher'];
//$extendBranch = $_POST['extendBranch'];
//$extendStartDate = $_POST['extendStartDate'];
//$extendEndDate = $_POST['extendEndDate'];


Future<String> extendRequest(BuildContext context ,String userID, String extendTeacher, String extendBranch,
    String extendStartDate,String extendEndDate) async{

  Map data = {
    'userID' : userID,
    'extendTeacher' : extendTeacher,
    'extendBranch' : extendBranch,
    'extendStartDate' : extendStartDate,
    'extendEndDate' : extendEndDate,
  };
  String res;
  var response = await http.post(API.POST_EXTENDCOURSE, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    res = response.body;
    String message = '';
    print(res);
    if(res.length > 0 && res.substring(0,1) == '2')
    {
      message = '성공적으로 연장하였습니다!';
    }else {
      switch (res) {
        case 'timeout' :
          message = '연장은 수업시작 4시간 전까지만 가능합니다!';
          break;
        case 'unavailable' :
          message = '연장을 하려면 수업을 먼저 취소해주세요!';
          break;
        case 'notEmpty':
          message = '연장가능한 시간대가 아닙니다!';
          break;
        default :
          message = '오류가 발생했습니다!';
          break;
      }
    }
    showMyDialog(context,message);
    return res;
  }else{
    return Future.error('loading fail');
  }
}
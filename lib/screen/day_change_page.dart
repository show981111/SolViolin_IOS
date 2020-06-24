import 'package:flutter/material.dart';
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/fetchData/getBookedList.dart';
import 'package:solviolin/fetchData/getTermList.dart';
import 'package:solviolin/fetchData/getTimeForDay.dart';
import 'package:solviolin/model/available_time.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/term.dart';
import 'package:solviolin/model/user.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


class DayChange extends StatefulWidget {
  final User user;
  DayChange({this.user});

  _DayChangeState createState() => _DayChangeState();
}

class _DayChangeState extends State<DayChange> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<BookedList> canceledList = List<BookedList>();
  List<Term> termList = List<Term>();
  List<AvailableTime> timeList = List<AvailableTime>();
  String selectedDate = '';
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('보강 예약'),
      ),
      body: FutureBuilder(
          future: getBookedList(context, widget.user.userID, 'cancelAll'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              return Container(
                child: Text('error'),
              );
            }else{
              String firstMessage = '';
              String secondMessage = '';
              canceledList = snapshot.data;
              print(canceledList.length);
              if(canceledList.length < 1){
                firstMessage = '취소한 수업이 없습니다';
                secondMessage = '수업을 먼저 취소해주세요';
              }else{
                _isButtonDisabled = false;
                firstMessage = canceledList[0].bookedTeacher + ' / ' + canceledList[0].bookedBranch;
                secondMessage = canceledList[0].bookedStartDate + ' ~ ' + canceledList[0].bookedEndDate;
              }
              return Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('취소한 수업', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(firstMessage),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(secondMessage),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Divider(
                              color: Colors.white,
                              height: 36,
                            )),
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('예약할 수업', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      child: Text('날짜 선택', style: TextStyle(fontSize: 15),),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        if(!_isButtonDisabled) {
                          getTermList().then((value) {
                            termList = value;
                            if (termList.length > 2) {
                              showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse(termList[1].termEnd)
                              ).then((pickedDate) {
                                setState(() {
                                  selectedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate);
                                });
                              });
                            }
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('선택한 날짜 : '+selectedDate, style: TextStyle(fontSize: 15),),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Divider(
                              color: Colors.white,
                              height: 36,
                            )),
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('가능한 시간', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ),
                    FutureBuilder(
                      future: getTimeForDay(widget.user.userID, widget.user.userBranch, widget.user.mainTeacher,
                          widget.user.userDuration, selectedDate, widget.user.userName),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData == false){
                          if(!_isButtonDisabled && selectedDate != '')
                          {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }else{
                            return Text('');
                          }
                        }else if(snapshot.hasError){
                          return Container(
                            child: Text('error'),
                          );
                        }else{
                          timeList =[];
                          timeList = snapshot.data;
                          return  makeButtonGrid(context, timeList, widget.user.mainTeacher, widget.user.userBranch,
                            widget.user.userID, selectedDate, canceledList[0].bookedStartDate,widget.user.userDuration,
                          widget.user.userName,_scaffoldKey);
                        }
                      },
                    ),
//                    GridView.count(
//                      crossAxisCount: 4,
//                      children:
//                    )
                  ],
                ),
              );
            }
          }
      )
    );
  }

}

Widget makeButtonGrid(BuildContext context, List<AvailableTime> timeList, String teacher, String courseBranch, String userID
    , String selectedDate, String canceledDate, String userDuration, String userName, GlobalKey<ScaffoldState> key){
  List<Widget> results = [];
  for(int i = 0; i < timeList.length; i++)
  {
    results.add(
      FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Text(timeList[i].availableTime),
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () {
          //showTwoButtonDialog(context, teacher + ' 선생님으로 '+ date + ' ' +timeList[i].availableTime+ ' 에 예약하시겠습니까?');
          showDialog<void>(
            context: context,
            barrierDismissible: true, // user dont have button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: Text(
                      teacher + ' 선생님으로 '+ selectedDate + ' ' +timeList[i].availableTime+ ' 에 예약하시겠습니까?'
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      String startDate = selectedDate + ' ' +timeList[i].availableTime;
                      print(startDate);
                      putNewlyDate( teacher,  courseBranch,  userID
                          ,  startDate,  canceledDate,  userDuration,  userName).then((value) {
                            if(value == 'success'){
                              Toast.show("성공적으로 예약하였습니다!", key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                            }else{
                              Toast.show("오류가 발생했습니다!", key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

                            }
                      });

                    },
                  ),
                ],
              );
            },
          );
        },
      )
    );
  }

  if(timeList.length < 1){
    return Center(
      child: Text(
        '예약가능한 시간대가 없습니다!',
            style: TextStyle(color: Colors.red),
      ),
    );
  }else{
    return GridView.count(
        padding: EdgeInsets.all(8),
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 4,
        children : results
    );
  }
  //return results;
}


Future<String> putNewlyDate(String courseTeacher, String courseBranch, String userID
    , String startDate, String canceledDate, String userDuration, String userName) async{

  Map data = {
    'courseTeacher' : courseTeacher,
    'courseBranch' : courseBranch,
    'userID' : userID,
    'startDate' : startDate,
    'canceledDate' : canceledDate,
    'userDuration' : userDuration,
    'userName' : userName
  };

  var response = await http.post(API.POST_PUTNEWLYDATE, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body;
    print(result);
    return result;
  }else{
    return Future.error('loading fail');
  }
}
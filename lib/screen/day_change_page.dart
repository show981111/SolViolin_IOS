import 'package:flutter/material.dart';
import 'package:solviolin/fetchData/getBookedList.dart';
import 'package:solviolin/fetchData/getTermList.dart';
import 'package:solviolin/fetchData/getTimeForDay.dart';
import 'package:solviolin/model/available_time.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/term.dart';
import 'package:solviolin/model/user.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/widget/show_twobutton_dialog.dart';
import 'package:solviolin/widget/showdialog.dart';

class DayChange extends StatefulWidget {
  final User user;
  DayChange({this.user});

  _DayChangeState createState() => _DayChangeState();
}

class _DayChangeState extends State<DayChange> {
  List<BookedList> canceledList = List<BookedList>();
  List<Term> termList = List<Term>();
  List<AvailableTime> timeList = List<AvailableTime>();
  String selectedDate = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        getTermList().then((value){
                          termList = value;
                          if(termList.length > 2){
                            showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate:  DateTime.now(),
                                lastDate: DateTime.parse(termList[1].termEnd)
                            ).then((pickedDate){
                              setState(() {
                                selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            });
                          }
                        });
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
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }else if(snapshot.hasError){
                          return Container(
                            child: Text('error'),
                          );
                        }else{
                          timeList =[];
                          timeList = snapshot.data;
                          return GridView.count(
                              padding: EdgeInsets.all(8),
                              childAspectRatio: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 16,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              crossAxisCount: 4,
                              children : makeButtonGrid(context, timeList, widget.user.mainTeacher, selectedDate)
                          );
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

List<Widget> makeButtonGrid(BuildContext context, List<AvailableTime> timeList, String teacher, String date){
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
          showTwoButtonDialog(context, teacher + ' 선생님으로 '+ date + ' ' +timeList[i].availableTime+ ' 에 예약하시겠습니까?');
        },
      )
    );
  }
  return results;
}


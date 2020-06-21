import 'package:flutter/material.dart';
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/fetchData/getBookedList.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';

class CurrentResult extends StatefulWidget {
  final User user;

  CurrentResult({@required this.user});

  _CurrentResultState createState() => _CurrentResultState();
}

class _CurrentResultState extends State<CurrentResult> {
  List<BookedList> userBookedList = List<BookedList>();
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
                key: ValueKey(index),
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '연장',
                    color: Colors.grey.shade300,
                    icon: Icons.edit,
                    closeOnTap: false,
                    onTap: () {
                      Toast.show('Update on $index', context, duration: Toast.LENGTH_SHORT);
                    },
                  ),
                  IconSlideAction(
                    caption: '삭제',
                    color: Colors.grey.shade300,
                    icon: Icons.delete,
                    closeOnTap: false,
                    onTap: () {
                      Toast.show('DELETE on $index', context, duration: Toast.LENGTH_SHORT);
                    },
                  )
                ],
                dismissal: SlidableDismissal(child: SlidableDrawerDismissal()),
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
}




import 'package:flutter/material.dart';
import 'package:solviolin/fetchData/getBookedList.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/user.dart';

class PastResult extends StatefulWidget {
  final User user;
  PastResult({@required this.user});
  _PastResultState createState() => _PastResultState();

}

class _PastResultState extends State<PastResult>{
  List<BookedList> pastBookedList = List<BookedList>();
  @override
  void initState() {
    print(widget.user.userID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBookedList(context, widget.user.userID, 'past'),
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
          pastBookedList = snapshot.data;
          print(pastBookedList.length);
          return ListView.builder(itemCount:pastBookedList.length ,itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(pastBookedList[index].bookedTeacher+ " / " + pastBookedList[index].bookedBranch),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Text("시작 : "+pastBookedList[index].bookedStartDate),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Text("종료 : " + pastBookedList[index].bookedEndDate),
                    )
                  ],
                ),
              ),
            );
          });
        }
      }
    );
  }

}

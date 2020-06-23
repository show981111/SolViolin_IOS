import 'package:flutter/material.dart';
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/fetchData/getBookedList.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/user.dart';

class ChangeResult extends StatefulWidget {
  final User user;
  ChangeResult({@required this.user});
  _ChangeResultState createState() => _ChangeResultState();

}

class _ChangeResultState extends State<ChangeResult>{
  List<BookedList> changeBookedList = List<BookedList>();
  @override
  void initState() {
    print(widget.user.userID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getBookedList(context, widget.user.userID, 'changeRes'),
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
            changeBookedList = snapshot.data;
            print(changeBookedList.length);
            return ListView.builder(itemCount:changeBookedList.length ,itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: makeList(changeBookedList, index),
                  ),
                ),
              );
            });
          }
        }
    );
  }

}

List<Widget> makeList(List<BookedList> changeBookedList, int index){
  List<Widget> results = [];
  String message = '';
  String beforeChange = '';

  if(changeBookedList[index].bookedEndDate == ''){
    beforeChange = changeBookedList[index].bookedStartDate;
    message = '아직 보강을 예약하지 않았습니다!';
  }else{
    beforeChange = changeBookedList[index].bookedEndDate;
    message = '변경 후 : ' + changeBookedList[index].bookedStartDate ;
  }
  results.add(
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(3),
            child: Text(changeBookedList[index].bookedTeacher+ " / " + changeBookedList[index].bookedBranch),
          ),
          Padding(
            padding: EdgeInsets.all(3),
            child: Text("변경 전 : "+ beforeChange ),
          ),
          Padding(
            padding: EdgeInsets.all(3),
            child: Text(message, style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      )
  );

  return results;
}


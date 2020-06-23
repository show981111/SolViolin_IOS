import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/model/available_time.dart';

Future<List<AvailableTime>> getTimeForDay(String userID, String courseBranch, String courseTeacher
                , String userDuration, String selectedDate, String userName) async{
  //$userID = $_POST['userID'];
  //$courseBranch = $_POST['courseBranch'];
  //  //$courseTeacher = $_POST['courseTeacher'];
  //  //$userDuration = $_POST['userDuration'];
  //  //$selectedDate = $_POST['selectedDate'];
  //  //$userName = $_POST['userName'];
  Map data = {
    'userID' : userID,
    'courseBranch' : courseBranch,
    'courseTeacher' : courseTeacher,
    'userDuration' : userDuration,
    'selectedDate' : selectedDate,
    'userName' : userName
  };

  List<AvailableTime> timeList = List<AvailableTime>();
  var response = await http.post(API.GET_TIMEFORDAY, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = json.decode(response.body);

    for(int i = 0; i < result.length ; i++)
    {
      AvailableTime time = AvailableTime.fromJson(result[i]);
      timeList.add(time);
    }
    return timeList;
  }else{
    return Future.error('loading fail');
  }
}


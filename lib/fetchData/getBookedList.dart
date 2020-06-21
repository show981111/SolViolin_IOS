import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/model/booked_list.dart';

Future<List<BookedList>> getBookedList(BuildContext context ,String userID, String option ) async{
  Map data = {
    'userID' : userID,
    'option' : option
  };
  List<BookedList> userBookedList = List<BookedList>();
  var response = await http.post(API.GET_USERBOOKEDLIST, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    //print(response.body);
    print(userID);
    var result = json.decode(response.body);
    for(int i = 0; i < result.length ; i++)
    {
      BookedList bookedListItem = BookedList.fromJson(result[i]);
      userBookedList.add(bookedListItem);
      print(bookedListItem.bookedTeacher);
    }
    return userBookedList;
  }else{
    return Future.error('loading fail');
  }
}
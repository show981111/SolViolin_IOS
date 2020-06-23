import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:solviolin/Api/api.dart';
import 'package:solviolin/model/booked_list.dart';
import 'package:solviolin/model/term.dart';

Future<List<Term>> getTermList() async{

  List<Term> termList = List<Term>();
  var response = await http.get(API.GET_TERMLIST);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    //print(response.body);
    var result = json.decode(response.body);
    for(int i = 0; i < result.length ; i++)
    {
      Term termItem = Term.fromJson(result[i]);
      termList.add(termItem);
      print(termItem.termStart);
    }
    return termList;
  }else{
    return Future.error('loading fail');
  }
}
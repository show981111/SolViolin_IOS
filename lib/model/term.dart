import 'package:flutter/material.dart';
class Term {
  String termStart;
  String termEnd;

  Term({@required this.termStart,@required this.termEnd});

  factory Term.fromJson(Map<String, dynamic> json){
    return Term(
      termStart: json['termStart'],
      termEnd: json['termEnd'],
    );
  }
}


import 'dart:convert';


class User {
  String userID;
  String userName;
  String userBranch;
  String userDuration;
  String mainTeacher;

  User({this.userID, this.userName, this.userBranch, this.userDuration, this.mainTeacher});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userID: json['userID'],
      userName: json['userName'],
      userBranch: json['userBranch'],
      userDuration: json['userDuration'],
      mainTeacher: json['courseTeacher']
    );
  }



}

//class Post {
//  final String userId;
//  final String userPW;
//
//  Post({this.userId, this.userPW});
//
//  factory Post.fromJson(Map<String, dynamic> json) {
//    return Post(
//      userId: json['userId'],
//      userPW: json['userPW'],
//    );
//  }
//}
//
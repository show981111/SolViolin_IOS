import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solviolin/Api/api.dart';
import 'dart:convert';

import 'package:solviolin/model/user.dart';
import 'package:solviolin/widget/showdialog.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'main_page.dart';
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


class LoginScreen extends StatefulWidget {

  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{
  TextEditingController idController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String _token;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    iOS_Permission();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = token;
        print(_token);

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Container(
        child : Column(//_isLoading ? Center(child: CircularProgressIndicator()) :
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/solviolin_logo.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 30, 8, 8),
              child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '아이디',
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 45,
                child: Container(
                  width: double.infinity,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Text('로그인', style: TextStyle(fontSize: 15),),
                    color: Color.fromRGBO(96, 128, 104, 100),
                    textColor: Colors.white,
                    onPressed: () {
                      print('firebase');
                      //firebaseCloudMessaging_Listeners();

                      setState(() {
                        _isLoading = true;
                      });
                      login(context, idController.text, passwordController.text, _token)
                          .catchError((e) {
                        print("Got error: ${e}");     // Finally, callback fires.
                        if(e == 'loginFail'){
                          showMyDialog(context, '아이디와 비밀번호를 다시 확인해주세요!');
                        }else{
                          showMyDialog(context, '인터넷 연결을 확인해주세요!');
                        }
                      });
                      //print(e);
                    },
                  ),
                )

              ),
            ),

          ],
        ),
      ),
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

}

Future<User> login(BuildContext context ,String userID, String password, String token) async{

  Map data = {
    'userID' : userID,
    'userPassword' : password,
    'token' : token
  };
  User userinfo;
  var response = await http.post(API.POST_LOGIN, body: data);
  print(userID + password + token);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    print(response.body);

    var result = json.decode(response.body);
    if(result.length > 0) {
      userinfo = User.fromJson(result[0]);
      print(userinfo.userID);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
          (BuildContext context) => MainPage(user: userinfo, token: token,)), (
          Route<dynamic> route) => false);
      return userinfo;
    }else{
      return Future.error('loginFail');
    }
  }else{
    return Future.error('loading fail');
  }
}



//Future<Post> fetchPost() async {
//  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');
//
//  if (response.statusCode == 200) {
//    // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
//    return Post.fromJson(json.decode(response.body));
//  } else {
//    // 만약 응답이 OK가 아니면, 에러를 던집니다.
//    throw Exception('Failed to load post');
//  }
//}
//


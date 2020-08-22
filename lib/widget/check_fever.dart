import 'package:flutter/material.dart';

Future<int> showFeverDialog(BuildContext context) async {
  return showDialog<int>(
    context: context,
    barrierDismissible: true, // user dont have button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text(
              "발열 증상이 있습니까?"
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('있습니다'),
            onPressed: () {
              Navigator.pop(context, 1);
            },
          ),
          FlatButton(
            child: Text('없습니다'),
            onPressed: () {
              Navigator.pop(context, 0);
            },
          ),
        ],
      );
    },
  );
}
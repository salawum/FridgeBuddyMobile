import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget{

  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueGrey,
      child: new InkWell(
        onTap: ()=> Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("FridgeBuddy", textScaleFactor: 4 , style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
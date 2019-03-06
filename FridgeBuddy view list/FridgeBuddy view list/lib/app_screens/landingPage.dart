import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget{

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return new Material(
      color: Colors.blueGrey,
      child: new InkWell(
        onTap: ()=> Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("FridgeBuddy", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width/7), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
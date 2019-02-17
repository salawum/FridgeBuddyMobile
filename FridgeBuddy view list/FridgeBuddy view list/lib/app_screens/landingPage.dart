import 'package:flutter/material.dart';
import './mainView.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> with TickerProviderStateMixin {
  Animation<double> _textAnimation;
  AnimationController _textController1, _textController2;

  @override
  void initState() {
    super.initState();
    _textController1 =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _textController2 =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _textAnimation =
        new Tween(begin: 0.5, end: 1.0).animate(new CurvedAnimation(
      parent: _textController2,
      curve: Curves.easeIn,
    ));

    _textController1.repeat();
    _textController2.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueGrey,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new MainView())),
        child: ScaleTransition(
          scale: _textController1,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "FridgeBuddy",
                textScaleFactor: 4,
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

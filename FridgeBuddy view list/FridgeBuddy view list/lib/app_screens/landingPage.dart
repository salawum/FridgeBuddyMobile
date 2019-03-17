import 'package:flutter/material.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> with TickerProviderStateMixin {
  AnimationController _iconController, _textController, _textController2;
  double opacityLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    _textController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _textController2 =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _iconController.forward();
    _textController.forward();
    _textController2.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueGrey,
      child: new InkWell(
        onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
        child: ScaleTransition(
          scale: _textController,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RotationTransition(
                turns: _iconController,
                child: new Container(
                  constraints: new BoxConstraints.expand(
                    height: 200.0,
                  ),
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage('images/logo.png'),
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              new Text(
                "FridgeBuddy",
                textScaleFactor: 4,
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              FadeTransition(
                opacity: _textController2,
                child: new Text(
                  "Tap to continue",
                  textScaleFactor: 1.5,
                  style: new TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _textController2.dispose();
    super.dispose();
  }
}
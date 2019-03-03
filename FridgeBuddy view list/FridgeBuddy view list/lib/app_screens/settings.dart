import 'package:flutter/material.dart';

final _feedbackBugs = TextEditingController();
bool _notificationValGlobal = true;
bool _notificationValFav = true;
bool _community = true;
bool _developers = false;

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => new _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Are you sure?"),
        content: new Text("Do you want to exit FridgeBuddy?"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text("No"),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text("Yes"),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: Text("Settings",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "General Notifications        ",
                        textScaleFactor: 1.2,
                      ),
                      Switch(
                        value: _notificationValGlobal,
                        onChanged: (bool newValue) {
                          setState(() {
                            _notificationValGlobal = newValue;
                            print(_notificationValGlobal);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Favourites List Notifications",
                        textScaleFactor: 1.2,
                      ),
                      Switch(
                        value: _notificationValFav,
                        onChanged: (bool newValue) {
                          setState(() {
                            _notificationValFav = newValue;
                            print(_notificationValFav);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Text(
                    "Got any feedback?",
                    textScaleFactor: 1.2,
                    //textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: TextField(
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLength: 280,
                    autocorrect: true,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    controller: _feedbackBugs, //_feedback.text would hold the string value
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message...",
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: width * 0.05,
                          height: height * 0.05,
                          child: (_community)
                              ? RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Colors.blue,
                            onPressed: () {},
                          )
                              : RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _community = !_community;
                                _developers = false;
                              });
                            },
                          ),
                        ),
                        Text(
                          "Community Fridge Feedback",
                          textScaleFactor: 1.2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: width * 0.05,
                          height: height * 0.05,
                          child: (_developers)
                              ? RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Colors.blue,
                            onPressed: () {},
                          )
                              : RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _developers = !_developers;
                                _community = false;
                              });
                            },
                          ),
                        ),
                        Text(
                          "App Feedback             ",
                          textScaleFactor: 1.2,
                        ),
                      ],
                    ),
                  ],
                ),
                FlatButton(
                    child: Text(
                      "Let us know",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                      textScaleFactor: 1.2,
                    ),
                    color: Colors.blue[700],
                    onPressed: (){
                      print(_feedbackBugs.text);
                      _feedbackBugs.text = "";
                    }
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.view_list),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                  }
              ),
              new IconButton(
                  icon: Icon(Icons.view_headline),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/favList', (Route<dynamic> route) => false);
                  }
              ),
              new IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.greenAccent,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
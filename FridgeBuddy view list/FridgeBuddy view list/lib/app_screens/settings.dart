import 'package:flutter/material.dart';
import './favouritesList.dart';
import './mainView.dart';

final _feedbackBugs = TextEditingController();
bool _notificationValGlobal = true;
bool _notificationValFav = true;
bool _community = true;
bool _devs = false;

class Settings extends StatelessWidget {

  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Settings",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: new AppSettings(),
    );
  }
}

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => new _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {

  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
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
                                _devs = false;
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
                        child: (_devs)
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
                              _devs = !_devs;
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
              onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MainView())),
            ),
            new IconButton(
              icon: Icon(Icons.view_headline),
              onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FavouritesList())),
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
    );
  }
}
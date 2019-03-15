import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:global_configuration/global_configuration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

GlobalConfiguration config = new GlobalConfiguration();
final _feedbackBugs = TextEditingController();
final String globalNotifyKey = "Global";
final String localNotifyKey = "Local";
bool notificationValGlobal = config.getBool(globalNotifyKey);
bool notificationValLocal = config.getBool(localNotifyKey);
bool _community = true;
bool _developers = false;
final FirebaseMessaging _messaging = new FirebaseMessaging();

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => new _AppSettingsState();
}
class _AppSettingsState extends State<AppSettings> {
  @override
  void initState() {
    //print(config.getBool(globalNotifyKey));
    setState(() {
      _getGlobalNotifications().then((resultGlobal) {
        if (resultGlobal != null) {
          //print(config.get(globalNotifyKey));
          setState(() {
            notificationValGlobal = resultGlobal;
            config.appConfig.update(globalNotifyKey, (bool) => resultGlobal);
          });
          //GlobalConfiguration().setValue(globalNotifyKey, (bool) => notificationValGlobal);
        } else {
          notificationValGlobal = false;
        }
      });

      _getLocalNotifications().then((resultLocal) {
        if (resultLocal != null) {
          //print(config.getBool(localNotifyKey));
          setState(() {
            notificationValLocal = resultLocal;
            config.appConfig.update(localNotifyKey, (bool) => resultLocal);
          });
          //GlobalConfiguration().setValue(localNotifyKey, (bool) => notificationValLocal);
        } else {
          notificationValLocal = false;
        }
      });
    });
    super.initState();
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
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

  Future<bool> _getGlobalNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(globalNotifyKey);
  }

  Future<bool> _setGlobalNotifications(bool valueOfGlobal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(globalNotifyKey, valueOfGlobal);
  }

  Future<bool> _getLocalNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(localNotifyKey);
  }

  Future<bool> _setLocalNotifications(bool valueOfLocal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(localNotifyKey, valueOfLocal);
  }

  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
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
        body: Builder(
            builder: (BuildContext context) {
              return ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.03, left: width * 0.1),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "General Notifications",
                              style: TextStyle(
                                fontSize: width / 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.325),
                              child: Switch(
                                value: notificationValGlobal,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    notificationValGlobal = newValue;
                                    _setGlobalNotifications(newValue);
                                    config.appConfig.update(
                                        globalNotifyKey, (bool) => newValue);
                                    updateToken();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.03, left: width * 0.1),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Favourites List Notifications",
                              style: TextStyle(
                                fontSize: width / 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.2),
                              child: Switch(
                                value: notificationValLocal,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    notificationValLocal = newValue;
                                    _setLocalNotifications(newValue);
                                    config.appConfig.update(
                                        localNotifyKey, (bool) => newValue);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: Text(
                          "Got any feedback?",
                          style: TextStyle(
                            fontSize: width / 25,
                          ),
                          //textAlign: TextAlign.left,
                        ),
                      ),
                      TextField(
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLength: 300,
                        autocorrect: true,
                        style: TextStyle(
                          fontSize: width / 25,
                        ),
                        maxLines: null,
                        textAlign: TextAlign.center,
                        controller: _feedbackBugs,
                        //_feedback.text would hold the string value
                        decoration: InputDecoration(
                          counterStyle: TextStyle(
                            fontSize: width / 40,
                          ),
                          border: InputBorder.none,
                          hintText: "Message...",
                          hintStyle: TextStyle(
                            fontSize: width / 25,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: width / 6),
                                child: Container(
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 12),
                                child: Text(
                                  "Community Fridge Feedback",
                                  style: TextStyle(
                                    fontSize: width / 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: width / 6),
                                child: Container(
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 12),
                                child: Text(
                                  "App Feedback",
                                  style: TextStyle(
                                    fontSize: width / 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height / 20),
                        child: SizedBox(
                          height: height / 20,
                          width: width / 3,
                          child: FlatButton(
                              child: Text(
                                "Let us know",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: width / 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              color: Colors.blue[700],
                              onPressed: () {
                                setState(() {
                                  if (_feedbackBugs.text.isNotEmpty) {
                                    if (_developers) {
                                      Firestore.instance.collection(
                                          "DeveloperFeedback")
                                          .document()
                                          .setData({
                                        'feedback': _feedbackBugs.text
                                      });
                                      _feedbackBugs.clear();
                                      final snackBar = SnackBar(
                                        content: Text(
                                          "Thank you for your feedback",
                                          style: TextStyle(
                                            fontSize: width / 25,
                                          ),
                                        ),
                                        backgroundColor: Colors.blue,
                                      );
                                      Scaffold.of(context).showSnackBar(
                                          snackBar);
                                    } else if (_community) {
                                      Firestore.instance.collection(
                                          "CommunityFeedback")
                                          .document()
                                          .setData({
                                        'feedback': _feedbackBugs.text
                                      });
                                      _feedbackBugs.clear();
                                      final snackBar = SnackBar(
                                        content: Text(
                                          "Thank you for your feedback",
                                          style: TextStyle(
                                            fontSize: width / 25,
                                          ),
                                        ),
                                        backgroundColor: Colors.blue,
                                      );
                                      Scaffold.of(context).showSnackBar(
                                          snackBar);
                                    }
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        "Sorry, but your feedback can't be blank",
                                        style: TextStyle(
                                          fontSize: width / 25,
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                });
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.view_list),
                  iconSize: width / 15,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  }
              ),
              new IconButton(
                  icon: Icon(Icons.star),
                  iconSize: width / 15,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/favList', (Route<dynamic> route) => false);
                  }
              ),
              new IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.greenAccent,
                ),
                iconSize: width / 15,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateToken(){
    _messaging.getToken().then((token) {
      if(config.get(globalNotifyKey))
      {
        Firestore.instance.collection("notifytokens").document(token).setData({
          "mobiletokens": token,
        });
      }else
      {
        Firestore.instance
            .collection('notifytokens')
            .document(token)
            .delete()
            .catchError((e) {
          print(e);
        });
      }
    });
  }
}
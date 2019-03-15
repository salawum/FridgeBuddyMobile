import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_configuration/global_configuration.dart';

List<String> allList = <String>[];
Map<String,Color> favStarColours = new Map();
List<String> userFavList = <String>[];
final String savedListPref = "listOfFavs";
final String globalNotifyKey = "Global";
final String localNotifyKey = "Local";
GlobalConfiguration config = new GlobalConfiguration();

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => new _FavListState();
}

class _FavListState extends State<FavList> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    _getListOfFavs().then((result) {
      if(result != null)
        {
          userFavList = result;
        }else
          {
            userFavList = [];
          }
      userFavList.forEach((e){
        List name = e.split("_");
        favStarColours.putIfAbsent(name[0]+"ColourKey", () => Colors.yellow);
      });
    });
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
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

  Future<List<String>> _getListOfFavs() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(savedListPref);
  }

  Future<bool> _setListOfFavs(List<String> valueOfList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(savedListPref, valueOfList);
  }

  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: Text("Favourites List",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('Items').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(!snapshot.hasData) return Text("Loading...");
            for(int colourCounter=0;colourCounter<snapshot.data.documents.length;colourCounter++)
            {
              favStarColours.putIfAbsent(snapshot.data.documents[colourCounter]['Item name']+"ColourKey", () => Colors.grey);
            }
            int index = 0;
            if(userFavList.isNotEmpty)
            {
              for(int i=0;i<snapshot.data.documents.length;i++)
              {
                userFavList.sort();
                List temp = userFavList[index].split("_");
                if(userFavList.contains(snapshot.data.documents[i]['Item name']+"_"+temp[1]))
                {
                  if(index<userFavList.length-1)
                  {
                    index++;
                  }
                  List name = userFavList[userFavList.indexOf((snapshot.data.documents[i]['Item name']+"_"+temp[1].toString()))].split("_");
                  if(favStarColours[name[0]+"ColourKey"] == Colors.yellow && snapshot.data.documents[i]['Quantity'] > int.parse(name[1]))
                  {
                    if(config.getBool(localNotifyKey))
                    {
                      print("WORKING");
                      showNotification();
                    }
                    userFavList[userFavList.indexOf((snapshot.data.documents[i]['Item name']+"_"+temp[1].toString()))] = snapshot.data.documents[i]['Item name']+"_"+snapshot.data.documents[i]['Quantity'].toString();
                    _setListOfFavs(userFavList);
                  }else
                  {
                    userFavList[userFavList.indexOf((snapshot.data.documents[i]['Item name']+"_"+temp[1].toString()))] = snapshot.data.documents[i]['Item name']+"_"+snapshot.data.documents[i]['Quantity'].toString();
                    _setListOfFavs(userFavList);
                  }
                }
              }
            }
            return new ListView(
              children: snapshot.data.documents.map((document) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: width/50),
                  child: new ListTile(
                    leading: Icon(
                      Icons.fastfood,
                      color: Colors.yellow[700],
                      size: width/15,
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(bottom: width/70),
                      child: new Text(
                        document['Item name'],
                        style: TextStyle(
                          fontSize: width/25,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    subtitle: new Text(
                      document['Donator']+", Qty: "+document['Quantity'].toString(),
                      style: TextStyle(
                        fontSize: width/35,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.star),
                      iconSize: width/15,
                      color: favStarColours[document['Item name']+"ColourKey"],
                      onPressed: () {
                        if(favStarColours[document['Item name']+"ColourKey"] == Colors.grey)
                          {
                            setState(() {
                              favStarColours.update(document['Item name']+"ColourKey", (value) => Colors.yellow);
                              if(!userFavList.contains(document['Item name']+"_"+document['Quantity'].toString()))
                              {
                                userFavList.add(document['Item name']+"_"+document['Quantity'].toString());
                              }
                              _setListOfFavs(userFavList);
                              final snackBar = SnackBar(
                                content: Text(
                                  document['Item name']+" added to Favourites",
                                  style: TextStyle(
                                    fontSize: width/25,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 1),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            });
                          }
                        else
                          {
                            setState(() {
                              favStarColours.update(document['Item name']+"ColourKey", (value) => Colors.grey);
                              userFavList.removeWhere((name) => (name.contains(document['Item name'])));
                              _setListOfFavs(userFavList);
                              final snackBar = SnackBar(
                                content: Text(
                                  document['Item name']+" removed from Favourites",
                                  style: TextStyle(
                                    fontSize: width/25,
                                  ),
                                ),
                                backgroundColor: Colors.blue,
                                duration: Duration(seconds: 1),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            });
                          }
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new IconButton(
                icon: Icon(Icons.view_list),
                iconSize: width/15,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                }
              ),
              new IconButton(
                icon: Icon(
                  Icons.star,
                  color: Colors.greenAccent,
                ),
                iconSize: width/15,
                onPressed: () {},
              ),
              new IconButton(
                icon: Icon(Icons.settings),
                iconSize: width/15,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/settings', (Route<dynamic> route) => false);
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails("Channel ID", "Channel Name", "Channel Desc");
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, "Ta-da!", "An item from your favourites list has been updated", platform, payload: "Test");
  }
}

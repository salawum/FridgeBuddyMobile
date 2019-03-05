import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final _textEditControl = TextEditingController();
final _focus = FocusNode();
List<ListTile> favouriteItems = <ListTile>[];
List searchList = [];
var _search = true;
var _searching = false;
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

BuildContext context;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _textEditControl.addListener(() {
      if (_textEditControl.text.isEmpty) {
        setState(() {
          _searching = !_searching;
        });
      }
    });
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          "Are you sure?",
          textScaleFactor: 1.2,
        ),
        content: new Text(
          "Do you want to exit FridgeBuddy?",
          textScaleFactor: 0.9,
        ),
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

  _saveFav(String name, int quantity) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt(name, quantity);
    });
  }

  _loadFav(String name) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int newVal = prefs.get(name);

    return newVal;
  }

  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return new WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: (!_search)
                    ? Container(
                  width: width,
                  height: height * 0.1,
                  color: Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage('images/logo.png'),
                              fit: BoxFit.contain,
                            ),
                            //color: Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TextField(
                          autocorrect: true,
                          autofocus: false,
                          focusNode: _focus,
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                          controller: _textEditControl, //holds the value for the input for text
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: "Search...",
                          ),
                          onChanged: (searchText)
                          {
                            //print (searchText.substring(0,1).toUpperCase());
                          },
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: ()
                            {
                              setState(() {
                                _search = true;
                                _textEditControl.clear();
                              });
                            },
                          )
                      ),
                    ],
                  ),
                )
                    : Container(
                  width: width,
                  height: height * 0.1,
                  color: Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage('images/logo.png'),
                              fit: BoxFit.contain,
                            ),
                            //color: Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          "FridgeBuddy",
                          textScaleFactor: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: ()
                          {
                            setState(() {
                              _search = false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: ()
                          {
                            setState(() {
                              _textEditControl.text = "";
                              _scaffoldKey.currentState.openEndDrawer();
                            });
                          },
                        )
                      ),
                    ],
                  ),
                )
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ItemList(),
              ),
            ],
          ),
        ),
        endDrawer: Container(
          width: width * 0.7,
          child: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  height: height * 0.075,
                  child: DrawerHeader(
                    decoration: BoxDecoration (
                      color: Colors.blue,
                    ),
                    child: Text("Search Filters",
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Sort by Fridge", textScaleFactor: 1.2),
                  onTap: () {
                    //stuff
                    //print(_textEditControl.text);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Sort by Item Name", textScaleFactor: 1.2),
                  onTap: () {
                    //stuff
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new IconButton(
                icon: Icon(
                  Icons.view_list,
                  color: Colors.greenAccent,
                ),
                onPressed: () {},
              ),
              new IconButton(
                  icon: Icon(Icons.view_headline),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/favList', (Route<dynamic> route) => false);
                  }
              ),
              new IconButton(
                  icon: Icon(Icons.settings),
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
}

class ItemList extends StatelessWidget
{
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('Items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData){
          return new Text('Loading...',
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
          );
        }
        return (!_searching)
            ? ListView(
          children: snapshot.data.documents.map((document) {
            return new ExpansionTile(
              leading: Icon(
                Icons.fastfood,
                color: Colors.blue[700],
              ),
              title: new Text(document['Item name'], textScaleFactor: 1.0, textAlign: TextAlign.left,),
              children: <Widget>[
                ItemInfo(str: document['Date Added'].toString(), iconImage: Icons.access_time,),
                ItemInfo(str: document['Fridge'].toString(), iconImage: Icons.camera_rear,),
                ItemInfo(str:document['Quantity'].toString(), iconImage: Icons.camera_rear,), //remember to change
                ItemInfo(str:document['Donator'].toString(), iconImage: Icons.home,),
              ],
            );
          }).toList(),
        )
            : ListView(
          children: snapshot.data.documents.map((document) {
            if(document['Item name'].toString().toLowerCase().contains((_textEditControl.text).toLowerCase()) && _textEditControl.text.isNotEmpty)
            {
              print(_textEditControl.text);
              print(document['Item name']);
              return new ExpansionTile(
                leading: Icon(
                  Icons.fastfood,
                  color: Colors.blue[700],
                ),
                title: new Text(document['Item name'], textScaleFactor: 1.0, textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),
                children: <Widget>[
                  ItemInfo(str: document['Date Added'].toString(), iconImage: Icons.access_time,),
                  ItemInfo(str: document['Fridge'].toString(), iconImage: Icons.camera_rear,),
                  ItemInfo(str:document['Quantity'].toString(), iconImage: Icons.format_list_numbered,), //remember to change
                  ItemInfo(str:document['Donator'].toString(), iconImage: Icons.home,),
                ],
              );
            }else
            {
              print("Not equal");
              Text empty = new Text("");
              return empty;
            }
          }).toList(),
        );
      },
    );
  }
}

class FavouriteItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: favouriteItems.toList(),
    );
  }
}

class ItemInfo extends StatelessWidget {
  const ItemInfo({this.str,this.iconImage});

  final String str;
  final IconData iconImage;

  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Icon(
                iconImage,
                color: Colors.blue[200],
              ),
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            ),
            new Text(str, textScaleFactor: 1.0,),
          ],
        ),
      ),
    );
  }
}
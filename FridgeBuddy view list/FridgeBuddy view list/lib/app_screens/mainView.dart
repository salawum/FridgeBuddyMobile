import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

final _textEditControl = TextEditingController();
final _focus = FocusNode();
List<ListTile> favouriteItems = <ListTile>[];
List searchList = [];
var _search = true;
var _searching = false;
var filtered = false;
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
List filteredList = [];
List<ExpansionTile> expansionFilter = <ExpansionTile>[];
var sortByFridge = false;
var sortByName = true;

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
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          "Are you sure?",
          style: TextStyle(
            fontSize: width/24,
          ),
        ),
        content: new Text(
          "Do you want to exit FridgeBuddy?",
          style: TextStyle(
            fontSize: width/30,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text("No",
              style: TextStyle(
                fontSize: width/30,
              ),
            ),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text("Yes",
              style: TextStyle(
                fontSize: width/30,
              ),
            ),
          ),
        ],
      ),
    );
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
                            fontSize: width/30,
                          ),
                          controller: _textEditControl, //holds the value for the input for text
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              size: width/15,
                            ),
                            border: InputBorder.none,
                            hintText: "Search...",
                            hintStyle: new TextStyle(
                              fontSize: width/30,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            iconSize: width/15,
                            onPressed: ()
                            {
                              setState(() {
                                _search = true;
                                filtered = false;
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
                            fontWeight: FontWeight.bold,
                            fontSize: width/28,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.search),
                          iconSize: width/12,
                          onPressed: ()
                          {
                            setState(() {
                              filtered = false;
                              _search = false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.filter_list),
                          iconSize: width/12,
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
                child: (!filtered)
                  ? ItemList()
                  : ListView(
                    children: expansionFilter.toList(),
                )
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
                    child: Text(
                      "Search Filters",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width/15,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: width/40),
                    child: Text(
                      "Sort by Fridge",
                      style: TextStyle(
                        fontSize: width/25,
                      ),
                    ),
                  ),
                  selected: sortByFridge,
                  onTap: () {
                    setState(() {
                      filtered = true;
                      Navigator.pop(context);
                      sortByFridge = true;
                      sortByName = false;
                    });
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: width/40),
                    child: Text(
                      "Sort by Item Name",
                      style: TextStyle(
                        fontSize: width/25,
                      ),
                    ),
                  ),
                  selected: sortByName,
                  onTap: () {
                    setState(() {
                      filtered = false;
                      Navigator.pop(context);
                      sortByFridge = false;
                      sortByName = true;
                    });
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
                iconSize: width/15,
                onPressed: () {},
              ),
              new IconButton(
                icon: Icon(Icons.star),
                iconSize: width/15,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/favList', (Route<dynamic> route) => false);
                }
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
}

class ItemList extends StatelessWidget
{
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return new StreamBuilder(
      stream: Firestore.instance.collection('Items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData){
          return new Text('Loading...',
            style: TextStyle(
              fontSize: width/25,
            ),
            textAlign: TextAlign.center,
          );
        }
        filteredList.clear();
        expansionFilter.clear();
        for(int i=0;i<snapshot.data.documents.length;i++)
        {
          filteredList.add(snapshot.data.documents[i]['Fridge']+"_"+snapshot.data.documents[i]['Date Added'].toString()+"_"+snapshot.data.documents[i]['Item name']+"_"+snapshot.data.documents[i]['Quantity'].toString()+"_"+snapshot.data.documents[i]['Donator']);
        }
        filteredList.sort();
        for(int i=0;i<filteredList.length;i++)
        {
          List temp = filteredList[i].toString().split("_");
          expansionFilter.add(
            new ExpansionTile(
              leading: Icon(
                Icons.fastfood,
                color: Colors.blue[700],
                size: width/15,
              ),
              title: Padding(
                padding: EdgeInsets.only(left: width/50),
                child: new Text(temp[2],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: width/25,
                  ),
                ),
              ),
              children: <Widget>[
                ItemInfo(str:temp[1], iconImage: Icons.access_time,),
                ItemInfo(str:temp[0], iconImage: Icons.camera_rear,), //remember to change
                ItemInfo(str:temp[3], iconImage: Icons.format_list_numbered,),
                ItemInfo(str:temp[4], iconImage: Icons.home,),
              ],
            )
          );
        }
        return (!_searching)
            ? ListView(
          children: snapshot.data.documents.map((document) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: width/50),
              child: new ExpansionTile(
                leading: Icon(
                  Icons.fastfood,
                  color: Colors.blue[700],
                  size: width/15,
                ),
                title: Padding(
                  padding: EdgeInsets.only(left: width/50),
                  child: new Text(document['Item name'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: width/25,
                    ),
                  ),
                ),
                children: <Widget>[
                  ItemInfo(str: document['Date Added'].toString(), iconImage: Icons.access_time,),
                  ItemInfo(str: document['Fridge'].toString(), iconImage: Icons.camera_rear,), //remember to change
                  ItemInfo(str:document['Quantity'].toString(), iconImage: Icons.format_list_numbered,),
                  ItemInfo(str:document['Donator'].toString(), iconImage: Icons.home,),
                ],
              ),
            );
          }).toList(),
        )
            : ListView(
          children: snapshot.data.documents.map((document) {
            if(document['Item name'].toString().toLowerCase().contains((_textEditControl.text).toLowerCase()) && _textEditControl.text.isNotEmpty)
            {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: width/50),
                child: new ExpansionTile(
                  leading: Icon(
                    Icons.fastfood,
                    color: Colors.blue[700],
                    size: width/15,
                  ),
                  title: new Text(
                    document['Item name'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: width/25,
                    ),
                  ),
                  children: <Widget>[
                    ItemInfo(str: document['Date Added'].toString(), iconImage: Icons.access_time,),
                    ItemInfo(str: document['Fridge'].toString(), iconImage: Icons.camera_rear,), //remember to change
                    ItemInfo(str: document['Quantity'].toString(), iconImage: Icons.format_list_numbered,),
                    ItemInfo(str: document['Donator'].toString(), iconImage: Icons.home,),
                  ],
                ),
              );
            }else
            {
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
  const ItemInfo({
    this.str,
    this.iconImage
  });

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
                size: width/15,
              ),
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            ),
            new Text(
              str,
              style: TextStyle(
                fontSize: width/32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
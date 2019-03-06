import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> allList = <String>[];
Map<String,Color> favStarColours = new Map();
List<String> userFavList = <String>[];
final String savedListPref = "listOfFavs";

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => new _FavListState();
}

class _FavListState extends State<FavList> {
  @override
  void initState() {
    super.initState();
    //userFavList = [];
    //_setListOfFavs(userFavList);
    _getListOfFavs().then((result) {
      if(result != null)
        {
          userFavList = result;
        }else
          {
            userFavList = [];
          }
      print("Here "+userFavList.toString());
      userFavList.forEach((e){
        print(e);
        List name = e.split("_");
        print(name[0]);
        favStarColours.putIfAbsent(name[0]+"ColourKey", () => Colors.yellow);
        //favStarColours.update(n[0]+"ColourKey", (value) => Colors.yellow);
      });
    });
    /*_getListOfFavs().then((result) {
      if(result.contains(document['Item name']+"_"+document['Quantity'].toString()))
      {
        favStarColours.update(document['Item name']+"ColourKey", (value) => Colors.yellow);
      }else
      {
        print("ELSE "+result.toString());
      }
    });*/
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

  Future<bool> _setListOfFavs(List<String> valueOfList) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(savedListPref, valueOfList);
  }

  /*Widget buildAllList() {
    StreamBuilder(
      stream: Firestore.instance.collection('itemsAll').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("Loading...");
        return Column(
          children: <Widget>[
            Text(snapshot.data.documents[0]['Item Name']),
            Text(snapshot.data.documents[0]['Fridge']),
            Text(snapshot.data.documents[0]['Donator']),
            Text(snapshot.data.documents[0]['Quantity'].toString()),
          ],
        );
      },
    );
    return buildAllList();
  }*/

  /*allList.clear();
  for(int i=0;i<snapshot.data.documents.length;i++)
  {
  allList.add(snapshot.data.documents[i]['Item Name']+"_"+snapshot.data.documents[i]['Quantity']);
  print(allList);
  }*/

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
              print("DONE");
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
                            print("in");
                            setState(() {
                              favStarColours.update(document['Item name']+"ColourKey", (value) => Colors.yellow);
                              print(document['Item name']+" added to Favourites");
                              if(!userFavList.contains(document['Item name']+"_"+document['Quantity'].toString()))
                              {
                                userFavList.add(document['Item name']+"_"+document['Quantity'].toString());
                              }
                              //print(userFavList);
                              _setListOfFavs(userFavList);
                              //print(_getListOfFavs());
                              _getListOfFavs().then((result) {
                                print("get added result "+result.toString());
                              });
                              print("User Fav List (added) "+userFavList.toString());
                              userFavList.forEach((e){
                                //print(e);
                                //List singleItem = e.split("_");
                                //print("new String: "+singleItem[0]+" "+singleItem[1]);
                              });
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
                              print(document['Item name']+" removed from Favourites");
                              userFavList.remove(document['Item name']+"_"+document['Quantity'].toString());
                              _setListOfFavs(userFavList);
                              _getListOfFavs().then((result) {
                                print("get removed result "+result.toString());
                              });
                              print("User Fav List (removed) "+userFavList.toString());
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
}

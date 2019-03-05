import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> allList = <String>[];
Map<String,Color> favStarColours = new Map();

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => new _FavListState();
}

class _FavListState extends State<FavList> {
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
    //double height = MediaQuery.of(context).size.height;
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
          stream: Firestore.instance.collection('itemsAll').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(!snapshot.hasData) return Text("Loading...");
            for(int colourCounter=0;colourCounter<snapshot.data.documents.length;colourCounter++)
            {
              favStarColours.putIfAbsent(snapshot.data.documents[colourCounter]['Item Name'], () => Colors.grey);
            }
            return new ListView(
              children: snapshot.data.documents.map((document) {
                return new ListTile(
                  leading: Icon(
                    Icons.fastfood,
                    color: Colors.yellow[700],
                  ),
                  title: new Text(document['Item Name'], textScaleFactor: 1.0, textAlign: TextAlign.left,),
                  subtitle: new Text(document['Donator']+", Qty: "+document['Quantity'].toString(), textScaleFactor: 1.0, textAlign: TextAlign.left,),
                  trailing: IconButton(
                    icon: Icon(Icons.star),
                    color: favStarColours[document['Item Name']],
                    onPressed: () {
                      if(favStarColours[document['Item Name']] == Colors.grey)
                        {
                          setState(() {
                            favStarColours.update(document['Item Name'], (value) => Colors.yellow);
                            print(document['Item Name']+" "+"added to Favourites");
                            final snackBar = SnackBar(
                              content: Text(document['Item Name']+" "+"added to Favourites"),
                              backgroundColor: Colors.blue,
                              duration: Duration(milliseconds: 250),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        }
                      else
                        {
                          setState(() {
                            favStarColours.update(document['Item Name'], (value) => Colors.grey);
                            print(document['Item Name']+" "+"removed from Favourites");
                            final snackBar = SnackBar(
                              content: Text(document['Item Name']+" "+"removed from Favourites"),
                              backgroundColor: Colors.blue,
                              duration: Duration(milliseconds: 250),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        }
                    },
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
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                  }
              ),
              new IconButton(
                icon: Icon(
                  Icons.view_headline,
                  color: Colors.greenAccent,
                ),
                onPressed: () {},
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

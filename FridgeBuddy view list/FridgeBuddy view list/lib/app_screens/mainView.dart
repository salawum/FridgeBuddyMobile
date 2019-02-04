import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _textEditControl = TextEditingController();
final _focus = FocusNode();

BuildContext context;

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View List',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: Icon(
          Icons.search,
          ),
        onPressed: () => FocusScope.of(context).requestFocus(_focus)
        ),
        actions:[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        title: new TextField(
          autofocus: false,
          focusNode: _focus,
          style: new TextStyle(
            color: Colors.white,
          ),
          controller: _textEditControl, //holds the value for the input for text
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
          ),
        ),
      ),
      body: new ItemList(),
      endDrawer: Drawer(
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
                print(_textEditControl.text);
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
      )
    );
  }
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('Items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...', textScaleFactor: 1.0);
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new ExpansionTile(
              title: new Text(document['Item name'], textScaleFactor: 1.0),
              children: <Widget>[
                ItemInfo(str: document['Date Added'].toString(), iconImage: Icons.access_time,),
                ItemInfo(str: document['Fridge'].toString(), iconImage: Icons.camera_rear,),
                ItemInfo(str:document['Quantity'].toString(), iconImage: Icons.format_list_numbered,),
                ItemInfo(str:document['Donator'].toString(), iconImage: Icons.home,),
              ],
              leading: Icon(
                Icons.fastfood,
                color: Colors.blue[700],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ItemInfo extends StatelessWidget
{
  const ItemInfo({this.str,this.iconImage});

  final String str;
  final IconData iconImage;

  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    return new Container(
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
    );
  }
}
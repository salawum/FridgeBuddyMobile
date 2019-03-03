import 'package:flutter/material.dart';
import './mainView.dart';

  class FavList extends StatefulWidget {
  @override
  _FavListState createState() => new _FavListState();
  }

  class _FavListState extends State<FavList> {

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
          body: new FavouriteItem(),
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
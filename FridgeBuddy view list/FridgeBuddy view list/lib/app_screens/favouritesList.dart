import 'package:flutter/material.dart';
import './settings.dart';
import './mainView.dart';

class FavouritesList extends StatelessWidget {

  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Favourites List",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: new FavList(),
    );
  }
}

  class FavList extends StatefulWidget {
  @override
  _FavListState createState() => new _FavListState();
  }

  class _FavListState extends State<FavList> {

    Widget build(BuildContext context)
    {
      //double height = MediaQuery.of(context).size.height;
      return new Scaffold(
        appBar: new AppBar(
          title: Text("Favourites List",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: new FavouriteItem(),
        bottomNavigationBar: BottomNavigationBar(
          //onTap: onTabTapped, // new
          currentIndex: 1, // new
          items: [
            new BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.view_list),
                onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MainView())),
              ),
              title: Text("View Items",),
            ),
            new BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.view_headline),
                onPressed: () {},
              ),
              title: Text("Favourites List"),
            ),
            new BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.settings),
                onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Settings())),
              ),
              title: Text("Settings"),
            ),
          ],
        ),
      );
    }
  }
import 'package:flutter/material.dart';
import './favouritesList.dart';
import './mainView.dart';

final _feedback = TextEditingController();
bool _notificationVal = true;

class Settings extends StatelessWidget {

  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Settings",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
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
                      "Toggle Notifications",
                      textScaleFactor: 1.2,
                    ),
                    Switch(
                      value: _notificationVal,
                      onChanged: (bool newValue) {
                        setState(() {
                          _notificationVal = newValue;
                          print(_notificationVal);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                  "Got any Feedback? Let us know\n",
                  textScaleFactor: 1.2,
                  ),
                  TextField(
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLength: 280,
                    autocorrect: true,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    controller: _feedback, //_feedback.text would hold the string value
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message...",
                    ),
                  ),
                  FlatButton(
                      child: Text(
                        "Submit",
                        textScaleFactor: 1.2,
                      ),
                      color: Colors.blue[700],
                      onPressed: (){
                        print(_feedback.text);
                        _feedback.text = "";
                      }
                  )
                ],
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //onTap: onTabTapped, // new
        currentIndex: 2, // new
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
              onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FavouritesList())),
            ),
            title: Text("Favourites List"),
          ),
          new BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}
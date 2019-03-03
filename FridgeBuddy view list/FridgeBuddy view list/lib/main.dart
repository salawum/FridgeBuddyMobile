import 'package:flutter/material.dart';
import './app_screens/landingPage.dart';
import './app_screens/mainView.dart';
import './app_screens/favouritesList.dart';
import './app_screens/settings.dart.';
import 'package:flutter/services.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new LoadScreen(),
    routes: {
      'landing': (BuildContext context) => LoadScreen(),
      '/home': (BuildContext context) => MyHomePage(),
      '/favList': (BuildContext context) => FavList(),
      '/settings': (BuildContext context) => AppSettings(),
    },
    theme: new ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
}
import 'package:flutter/material.dart';
import './app_screens/landingPage.dart';
import './app_screens/mainView.dart';
import './app_screens/favouritesList.dart';
import './app_screens/settings.dart.';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import './config/app_settings.config.dart';

void main(){
  GlobalConfiguration().loadFromMap(appSettings);
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(
        child: new LoadScreen()
    ),
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
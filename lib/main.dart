import 'package:flutter/material.dart';
import 'package:uberflutterapp/routes/routes.dart';
import 'package:uberflutterapp/telas/home.dart';


final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a)
);
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
  theme: temaPadrao,
  initialRoute: Routes.ROUTE_ROOT,
  onGenerateRoute: Routes.routeGenerator,
));
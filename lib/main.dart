import 'package:flutter/material.dart';

import 'homepage.dart';
import 'injector/injector.dart';
import 'loginpage.dart';
import 'signuppage.dart';

void main() => setupLocator();

Future setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        '/landingpage': (BuildContext context) => MyApp(),
        '/signup': (BuildContext context) => SignUpPage(),
        '/homepage': (BuildContext context) => HomePage(),
      },
    );
  }
}

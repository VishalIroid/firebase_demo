import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 15.0),
              TextField(
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  if(_email == null && _password == null) {
                    showAlertDialog(context, "Empty Filed Not Allowed");
                  } else {
                    signIn();
                  }
                },
                child: Text('Login'),
                color: Colors.blue,
                textColor: Colors.white,
              ),
              SizedBox(height: 15.0),
              Text('Don\'t have an account?'),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }


  signIn() {
//    Navigator.of(context).pushReplacementNamed('/homepage');

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password
    ).then((user) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString('email', user.user.email);
       prefs.setString('uid', user.user.uid);
      Navigator.of(context).pushReplacementNamed('/homepage');
//      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((e) {
      print(e);
      String _errorMsg = e.message.toString();
      showAlertDialog(context, _errorMsg);
      setState(() {});
    });
  }

  showAlertDialog(BuildContext context, String msg) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
//        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
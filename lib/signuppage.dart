import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'help/content.dart';
import 'injector/injector.dart';
import 'model/newuser.dart';
import 'service/usermanagement.dart';



class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _firstName;
  String _lastname;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextField(
                decoration: InputDecoration(hintText: 'First Name'),
                onChanged: (value) {
                  _firstName = value;
                },
              ),
              SizedBox(height: 15.0),
              TextField(
                decoration: InputDecoration(hintText: 'Last Name'),
                onChanged: (value) {
                  _lastname = value;
                },
              ),
              SizedBox(height: 15.0),

              TextField(
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 15.0),
              TextField(
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  _password = value;
                },
              ),

              SizedBox(height: 20.0),

              Text('Don\'t have an account?'),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {

                  if(_email == null || _password == null) {
                    showAlertDialog(context, 'email or password empty not allowed.');
                  } else {
                    signUp();
                  }

                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  signUp() async {

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email,
      password: _password
    ).then((signedInUser) async {

      NewUser rq = NewUser();
      rq.uid = signedInUser.user.uid;
      rq.firstName = _firstName;
      rq.lastName = _lastname;
      rq.email = signedInUser.user.email;


      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', signedInUser.user.email);
      prefs.setString('uid', signedInUser.user.uid);

      await Injector.databaseRef
          .collection(Const.user).document(signedInUser.user.uid).setData(rq.toJson()).then((result){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/homepage');
      }).catchError((e) {
        print("sign up error $e");
      });

    /*  SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', signedInUser.user.email);
      prefs.setString('uid', signedInUser.user.uid);
      UserManagement().storeNewUser(signedInUser, context, _firstName, _lastname);
    */
    }).catchError((e) {
      print(e);
      String errorMsg = e.message.toString();
      showAlertDialog(context, errorMsg);
      setState(() {

      });
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

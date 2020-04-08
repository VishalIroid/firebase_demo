import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserManagement {
  storeNewUser(user, context, firstName, lastName) {
    Firestore.instance.collection('/users').add({
      'firstName':firstName,
      'lastName':lastName,
      'email': user.user.email,
      'uid': user.user.uid
    }).then((value) async {
//      Injector.prefs.setString('email', user.user.email);

//      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
    });
  }
}
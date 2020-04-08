import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/help/content.dart';
import 'package:firebase_login/injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudObj {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(category, email, uid) {
    if (isLoggedIn()) {
      /*Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference = await Firestore.instance.collection('/category');
        reference.add({'category': category});
      });*/

      Firestore.instance.collection('/category').add({
        'category': category,
        'email': email,
//        'uid': uid,
        'uid': {'ctaegories':category, 'uid':uid}
      }).catchError((e) {
        print(e);
      });
    } else {
      print('you need to be logged.');
    }
  }

  getData() async {
//    return await Firestore.instance.collection('category').getDocuments();
//    return await Firestore.instance.collection('category').snapshots();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String localUid = prefs.getString('uid');



    return await Injector.databaseRef
        .collection(Const.category)
        .document(localUid)
        .collection(Const.categories)
        .snapshots();

/*    var getDataUser = Firestore.instance.collection('category').document().documentID;

    if(getDataUser == localUid) {
      return await Injector.databaseRef
          .collection(Const.category)
          .document(localUid)
          .collection(Const.categories)
          .snapshots();
    }*/


/*//    var data = await Firestore.instance.collection('category').document('uid');

    var firebaseCategory = await Firestore.instance.collection('category').getDocuments();


    for(int i = 0; i < firebaseCategory.documents.length; i++) {
//      return Firestore.instance.collection('category').document('uid').collection('ctaegories').snapshots();

      if(firebaseCategory.documents[i].data['uid'].toString() == localUid) {
        print(firebaseCategory.documents[i].data['uid']);
        return await Firestore.instance.collection('category').document('uid').collection('ctaegories').snapshots();
      }
    }*/



//    var data = Firestore.instance
//        .collection("category")
//        .where("uid", arrayContains: {"ctaegories": localUid},)
//        .snapshots();
//
//    print(data);
//    return data;


//    var data = await Firestore.instance
//        .collection('category')
//        .where('uid', isEqualTo: localUid)
//        .getDocuments();


//
//    print(data);
//    return data;

/*    SharedPreferences prefs = await SharedPreferences.getInstance();
    String localUid = prefs.getString('uid');

    var firebaseCategory = await Firestore.instance.collection('category').getDocuments();

//    var firebaseUid = await Firestore.instance.collection('category').document('uid');

    for (int i = 0; i < firebaseCategory.documents.length; i++) {
      if (firebaseCategory.documents[i].data['uid'] == localUid) {
        print(firebaseCategory.documents[i].data['uid']);
        return Firestore.instance.collection('category').document('ctaegories').get();
      }
    }*/
  }

  getListData() async {
    return await Injector.databaseRef
        .collection('tabname')
        .snapshots();
  }

  updateData(selectedDoc, newValue, email) {
    Firestore.instance
        .collection('category')
        .document(selectedDoc)
        .updateData({'category': newValue, 'email': email}).catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('category')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}

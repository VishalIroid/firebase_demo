import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/help/content.dart';
import 'package:firebase_login/injector/injector.dart';
import 'package:firebase_login/model/category.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/crud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category;
  String updateCategory;

  CrudObj crudObj = CrudObj();

  Stream cate;
  Stream cateList;
  String email;
  String uid;

  List tabOfData = ['tab 1', 'tab 2', 'tab 3', 'tab 4'];
//  QuerySnapshot cate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sharedPref();
    getData();
//    getListData();
  }

  sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    uid = prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
//                  getData();
                  showAlertDialog(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
//                  getData();
                  getListData();
                },
              ),
              FlatButton(
                textColor: Colors.white,
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed('/landingpage');
                  }).catchError((e) {
                    print('sign out $e');
                  });
                },
                child: Text("Logout"),
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ],
          )
        ],
      ),
//      body: Center(child: listOfCategory()),

      body: Column(
        children: <Widget>[
          Expanded(child: Center(child: changeText())),
          Container(
            height: 50,
            child:
//    StreamBuilder(
//                stream: cateList,
//                builder: (context, snapShot) {
                    ListView.builder(
//                      itemCount: snapShot.data.documents.length,
                      itemCount: tabOfData.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkResponse(
                          child: Container(
                            color: Colors.blueAccent,
                            margin: EdgeInsets.all(10),
//                            child: Text(snapShot.data.documents[index].data[index]['tab1']),
                            child: Text(tabOfData[index]),
                          ),
                          onTap: () {
                            changesIndex = index;
                            setState(() {});
                          },
                        );
                      }),
//                }),
          )
        ],
      ),

//      bottomNavigationBar:
      /*ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
          return Container(
            child: Text('hello'),
          );
      }),*/
    );
  }

  int changesIndex = 0;

  changeText() {
    if (changesIndex == 0) {
      return tab1();
    } else if (changesIndex == 1) {
      return tab2();
    } else if (changesIndex == 2) {
      return tab3();
    } else if (changesIndex == 3) {
      return tab4();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Add"),
      onPressed: () {
        Navigator.of(context).pop();
//        Navigator.pop(context);
        addCategoryFirebase();
//        dialogShow(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: TextField(
        decoration: InputDecoration(labelText: 'Enter Category Name'),
        onChanged: (value) {
          category = value;
        },
      ),
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

  updateDialog(BuildContext context, selectDoc) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Update"),
      onPressed: () {
        Navigator.of(context).pop();
//        Navigator.pop(context);
        updateCategoryFirebase(selectDoc, 1);
//        dialogShow(context);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: TextField(
        decoration: InputDecoration(labelText: 'Update Category Name'),
        onChanged: (value) {
          updateCategory = value;
          print(value);
        },
      ),
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


  Future<bool> dialogShow(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contect) {
          return AlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(fontSize: 15.0),
            ),
            content: Text('Category is added.'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
//                    Navigator.pop(context);
                  },
                  textColor: Colors.black,
                  child: Text('Ok'))
            ],
          );
        });
  }

  addCategoryFirebase() async {
//    Map category = {'category': category.toString()};

    /*  crudObj.addData(category, email, uid).then((result) {
//      print('$result');
    }).catchError((e) {
      print(e);
    });*/

    CategoryData rq = CategoryData();
    rq.categoryId = "";
    rq.categoryName = category;

//    Injector.databaseRef
//        .collection(Const.category)
//        .document(uid)
//        .collection(Const.categories)
//        .add(rq.toJson())
//        .then((result) {
////      updateCategoryFirebase(null,);
//    }).catchError((e) {
//      print(("add category data null $e"));
//    });

    DocumentReference docRef = await Injector.databaseRef
        .collection(Const.category)
        .document(uid)
        .collection(Const.categories)
        .add(rq.toJson());
    print(docRef.documentID);
    updateCategoryFirebase(docRef.documentID, 2);
  }

  updateCategoryFirebase(selectDoc, int i) {
//    Map category = {'category': category.toString()};
    /*crudObj.updateData(selectDoc, updateCategory, email).then((result) {
//      print('$result');
    }).catchError((e) {
      print(e);
    });*/

    CategoryData rq = CategoryData();
    rq.categoryId = selectDoc;
    i == 1 ? rq.categoryName = updateCategory : rq.categoryName = category;
//    rq.ctaegories = updateCategory;

    Injector.databaseRef
        .collection(Const.category)
        .document(uid)
        .collection(Const.categories)
        .document(selectDoc)
        .updateData(rq.toJson())
        .then((result) {})
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    crudObj.getData().then((result) {
//      var cate1;
      setState(() {
        cate = result;
      });
    });
//      var cate1 = Injector.databaseRef.collection(Const.category).document(uid).collection(Const.categories).snapshots();

/*    await getDataQuery().then((result) {
      setState(() {
        cate =  result;
      });
    }).catchError((e) {
      print("get data eroro $e");
    });*/
  }

  getListData() {
    crudObj.getListData().then((result) {
//      var cate1;
      setState(() {
        cateList = result;
      });
    });
  }

/*  getDataQuery() async {
    return await Injector.databaseRef
        .collection(Const.category)
        .document(uid)
        .collection(Const.categories)
        .snapshots();
  }*/

  listOfCategory() {
    if (cate != null) {
      return StreamBuilder(
          stream: cate,
          builder: (context, snapShot) {
            return cate != null
                ? ListView.builder(
                    itemCount: snapShot.data.documents.length,
                    padding: EdgeInsets.all(5.0),
                    itemBuilder: (context, index) {
                      return InkResponse(
                        child:
//                    snapShot.data.documents[index].data['email'] == email  ?
                            Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3.0,
                            )
                          ]),
                          child: Text(snapShot
                              .data.documents[index].data['categoryName']),
//                      child: Text(snapShot.data.documents[index].data['category']),
                        ),
//                        : Container(),
                        onTap: () {
                          updateDialog(context,
                              snapShot.data.documents[index].documentID);
                        },
                        onLongPress: () {
//                      crudObj.deleteData(
//                          snapShot.data.documents[index].documentID);
                          Injector.databaseRef
                              .collection(Const.category)
                              .document(uid)
                              .collection(Const.categories)
                              .document(
                                  snapShot.data.documents[index].documentID)
                              .delete();
                        },
                      );
                    })
                : Text("Loading....");
          });
    } else {
      return Text('Loading Please wait...!');
    }
  }
}

class tab1 extends StatefulWidget {
  @override
  _tab1State createState() => _tab1State();
}

class _tab1State extends State<tab1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tab 1',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class tab2 extends StatefulWidget {
  @override
  _tab2State createState() => _tab2State();
}

class _tab2State extends State<tab2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tab 2',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class tab3 extends StatefulWidget {
  @override
  _tab3State createState() => _tab3State();
}

class _tab3State extends State<tab3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tab 3',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class tab4 extends StatefulWidget {
  @override
  _tab4State createState() => _tab4State();
}

class _tab4State extends State<tab4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tab 4',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

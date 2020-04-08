
import 'package:cloud_firestore/cloud_firestore.dart';

class Injector {

  static Firestore databaseRef;

  static  getInstance() {
    databaseRef = Firestore.instance;
  }
 }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaaseService {
  final String uid;

  DatabaaseService({this.uid});

  final CollectionReference myCollection =
      Firestore.instance.collection('customer');

  final CollectionReference temporary = Firestore.instance.collection('temporary');

  Future updateUserData(String Name, String phone, String adress, String gender) async {
    return await myCollection.document(uid).setData({
      'Name': Name,
      'Phone': phone,
      'city': adress,
      'Gender': gender,
    });
  }

  Future DatabaseupdateUserData(String Name, String phone, String adress , String gender) async{
    final user = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance.collection('customer').document(user.uid).updateData({
      'Name': Name,
      'Phone': phone,
      'city':adress,
      'Gender': gender,
    });
  }

  final String _collection = 'customer';
  final Firestore _fireStore = Firestore.instance;

  Future tempobook(String loc, String des) async{
    final user = await FirebaseAuth.instance.currentUser();
    return await temporary.document(user.uid).setData({
      'Location' : loc,
      'Destination' : des,
    });
  }

  Future userlocation(String loc, String des) async{
    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('customer').document(user.uid).collection('userbookings').reference().document().setData({
      'Location' : loc,
      'Destination' : des,
    });
  }

  void getCustomer() async {
    var cusDoocumet =
        await Firestore.instance.collection('customer').document(uid).get();
    print(cusDoocumet.data);
  }
}

class DriverDatabaseService {
  final String D_id;

  DriverDatabaseService({this.D_id});

  final CollectionReference DriverCollection =
      Firestore.instance.collection('Drivers');

  Future UpdateDriverData(String Name, String Phone, String adress,
      String Gender, String CNIC, String CarName, String RegisterNo) async {
    return await DriverCollection.document(D_id).setData({
      'Name': Name,
      'Phone': Phone,
      'Adress': adress,
      'Gender': Gender,
      'CNIC': CNIC,
      'CarName': CarName,
      'RegisterNo': RegisterNo,
    });
  }

  void getdriver() async {
    var document =
        await Firestore.instance.collection('Drivers').document(D_id).get();
    print(document.data);
  }
}

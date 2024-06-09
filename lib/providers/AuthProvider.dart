import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserCredential> signInEmail(String email, String password) async{
    try{
      UserCredential userCredential =
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
  }
  }

  Future<UserCredential> signUp(String email, String password, String name) async{
    try{
      UserCredential userCredential =
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    _fireStore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
      'password': password,
    });

    return userCredential;
    }on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

  }

Future<void> saveToken(String token) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await _fireStore.collection('users').doc(user.uid).update({
      'TOKEN': token,
    });
  } else {
    throw FirebaseAuthException(
      code: 'user-not-found',
      message: 'No user currently signed in.',
    );
    // Или можно возвращать ошибку через Future:
    // return Future.error('No user currently signed in.');
  }
}

Future<void> new_warehouse(String name, String address, String capacity, String description, String number) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw FirebaseAuthException(
      code: 'user-not-found',
      message: 'No user currently signed in.',
    );
  }

  final docRef = _fireStore.collection('warehouses').doc(number);
  final docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    // Документ уже существует, обработайте эту ситуацию, например, выбросите ошибку
    throw Exception('Warehouse with this number already exists.');
  } else {
    // Документ не существует, создайте новый документ
    await docRef.set({
      "name": name,
      "address": address,
      "capacity": capacity,
      "currentCapacity": "",
      "number": number,
      "description": description
    });
  }
}

}
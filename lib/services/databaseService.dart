import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safegrandpa/models/userData.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection reference - con el .collection, si no existe, firebase lo crea
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  //usamos esta función para crear los valores que tendrá el café, atravez de su uid para saber que usuario
  //específico será el que pidió esos valores(.doc(uid)).
  Future udpateUserData(
      String? nombre, String? email, String? userType, String? phone) async {
    return await userCollection
        .doc(uid) //sirve para referenciar un documento en específico
        .set({
      "nombre": nombre,
      'email': email,
      'userType': userType,
      "phone": phone
    });
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> doc = snapshot.data() as Map<String, dynamic>;
    return UserData(
        uid: uid,
        nombre: doc['nombre'],
        email: doc['email'],
        userType: doc['userType'],
        phone: doc['phone']);
  }

  //get UserData Stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

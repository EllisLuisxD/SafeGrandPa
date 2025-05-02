import 'package:firebase_auth/firebase_auth.dart';
import 'package:safegrandpa/models/user.dart';
import 'package:safegrandpa/services/databaseService.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on UserCredential
  UserInitial? _userFromFirebaseUser(User? userCredential) {
    // ignore: unnecessary_null_comparison
    return userCredential != null ? UserInitial(uid: userCredential.uid) : null;
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential emailAndPassword = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebaseUser(emailAndPassword.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String userType, String phone) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //Aquí colocamos la función que creamos en el database con el documento único(uid) y sus datos que por ahora lo colocamos nosotros
      await DatabaseService(uid: userCredential.user!.uid)
          .udpateUserData(name, email, userType, phone);

      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //obtener el usuario autenticado
  Stream<UserInitial?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

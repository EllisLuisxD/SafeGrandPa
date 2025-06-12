// lib/services/authService.dart

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:safegrandpa/models/userInitial.dart'; // <--- Puedes eliminar o comentar esta línea
import 'package:safegrandpa/models/userData.dart'; // <--- ¡Asegúrate de importar UserData!
import 'package:safegrandpa/services/databaseService.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserData?> get user {
    return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) {
        // No hay usuario logueado, devuelve null
        return null;
      } else {
        // Usuario logueado, obtener sus datos de Firestore
        final databaseService = DatabaseService(uid: firebaseUser.uid);
        UserData? userData =
            await databaseService.getUserData(firebaseUser.uid);

        // Retorna el objeto UserData completo. Si getUserData devuelve null,
        // esto también devolverá null, lo que causará el CircularProgressIndicator
        // en GrandpaHome si el documento del usuario no existe o no se puede leer.
        return userData;
      }
    });
  }

  // sign in with email and password
  Future<UserData?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Tras iniciar sesión, obtenemos los datos completos del usuario.
      if (userCredential.user != null) {
        final databaseService = DatabaseService(uid: userCredential.user!.uid);
        UserData? userData =
            await databaseService.getUserData(userCredential.user!.uid);
        return userData; // Retorna el UserData completo
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future<UserData?> registerWithEmailAndPassword(String email, String password,
      String name, String userType, String phone) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Aquí colocamos la función que creamos en el database con el documento único(uid) y sus datos
      await DatabaseService(uid: userCredential.user!.uid).udpateUserData(
          name,
          email,
          userType,
          phone); // Asumo que udpateUserData guarda 'name' como 'nombre'

      // Después de registrar y guardar los datos, obtener el UserData completo
      if (userCredential.user != null) {
        final databaseService = DatabaseService(uid: userCredential.user!.uid);
        UserData? userData =
            await databaseService.getUserData(userCredential.user!.uid);
        return userData; // Retorna el UserData completo
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    // Cambiado a Future<void> ya que no retorna nada significativo
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

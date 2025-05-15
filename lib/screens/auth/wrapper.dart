import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/models/userInitial.dart';
import 'package:safegrandpa/screens/auth/authenticate.dart';
import 'package:safegrandpa/screens/home/family_home.dart';
import 'package:safegrandpa/screens/home/granpa_home.dart';
import 'package:safegrandpa/screens/home/home.dart';
import 'package:safegrandpa/services/databaseService.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInitial?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      // Si hay un usuario autenticado, ahora verifica su tipo desde Firestore
      return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data == null) {
            UserData? userData = snapshot.data;

            // Navega a la pantalla de inicio correcta según el tipo de usuario
            if (userData!.userType == 'Abuelo') {
              return GranpaHome();
            } else if (userData.userType == 'Familiar') {
              return FamilyHome();
            } else {
              // Manejar tipo de usuario desconocido
              return Text(
                  'Tipo de usuario desconocido'); // O redirigir a una pantalla de error
            }
          } else {
            // Si el usuario está autenticado en Firebase pero no tiene datos en Firestore (caso raro si el registro funciona bien)
            return Text(
                'Error al cargar datos del usuario'); // O redirigir a configuración/error
          }
        },
      );
    }
  }
}

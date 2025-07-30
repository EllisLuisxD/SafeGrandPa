// lib/screens/auth/wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userData.dart'; // Tu modelo UserData (para datos de Firestore)
import 'package:safegrandpa/screens/auth/authenticate.dart'; // Tu pantalla de login/registro
import 'package:safegrandpa/screens/home/family_home.dart'; // Tu pantalla para familiares
import 'package:safegrandpa/screens/home/granpa_home.dart';
import 'package:safegrandpa/services/databaseService.dart';
import 'package:safegrandpa/widgets/loading.dart'; // Tu pantalla para abuelos

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Escucha el estado de autenticación (UserInitial)
    // Este valor viene del StreamProvider<UserInitial?> en main.dart
    final UserData? userInitial = Provider.of<UserData?>(context);

    // Si userInitial es null, significa que no hay un usuario logueado.
    if (userInitial == null) {
      return Authenticate(); // Muestra la pantalla de login/registro.
    } else {
      // Si userInitial NO es null, significa que un usuario está logueado.
      // Ahora, intenta obtener los datos adicionales de ese usuario (UserData) desde Firestore.
      return StreamBuilder<UserData?>(
        // Define el tipo como UserData? (nullable)
        // Crea una instancia de DatabaseService SOLO cuando userInitial.uid no es null
        stream: DatabaseService(uid: userInitial.uid).userData,
        builder: (context, snapshot) {
          // Si está esperando los datos del usuario de Firestore
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); // Muestra un indicador de carga.
          }
          // Si hubo un error al cargar los datos
          else if (snapshot.hasError) {
            print('Error en StreamBuilder UserData: ${snapshot.error}');
            return const Text(
                'Error al cargar los datos del usuario. Por favor, reintente.'); // Manejo de error
          }
          // Si los datos llegaron y NO son nulos
          else if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot
                .data!; // Ahora es seguro usar '!' porque ya comprobamos que no es null

            // Redirige según el tipo de usuario
            if (userData.userType == 'Abuelo') {
              return GranpaHome();
            } else if (userData.userType == 'Familiar') {
              return FamilyHome();
            } else {
              // Si el tipo de usuario es desconocido o incompleto
              print('Tipo de usuario desconocido para UID: ${userInitial.uid}');
              return const Text(
                  'Tipo de usuario desconocido o datos de perfil incompletos. Contacta a soporte.');
            }
          }
          // Si el usuario está autenticado (userInitial no es null), pero no hay datos de perfil en Firestore
          // Esto puede ocurrir justo después del registro antes de que se creen los datos de perfil.
          else {
            print(
                'Usuario autenticado (${userInitial.uid}) sin datos de perfil en Firestore. Redirigiendo a pantalla de configuración.');
            // Aquí podrías redirigir a una pantalla para completar el perfil
            return const Text(
                'Autenticado pero sin datos de perfil. Por favor, espere o contacte a soporte.');
          }
        },
      );
    }
  }
}

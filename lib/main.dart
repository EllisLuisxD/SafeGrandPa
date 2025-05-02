import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/user.dart';
import 'package:safegrandpa/screens/auth/wrapper.dart';
import 'package:safegrandpa/screens/home/family_home.dart';
import 'package:safegrandpa/screens/home/granpa_home.dart';
import 'package:safegrandpa/services/authService.dart';

void main() async {
  //Inicializa los widgets
  WidgetsFlutterBinding.ensureInitialized();

  //Inicializar FireBase
  await Firebase.initializeApp();

  runApp(
    //Es un proveedor de estado que escucha un Stream y actualiza automáticamente la UI cuando los datos cambian. Es muy útil para datos en tiempo real, como la autenticación de Firebase.
    StreamProvider<UserInitial?>.value(
      value: Authservice()
          .user, //es el Stream que escucha cambios de autenticación.
      initialData:
          null, //significa que, por defecto, el usuario no está autenticado.
      child: MaterialApp(
        routes: {
          '/familyHome': (context) => FamilyHome(),
          '/granpaHome': (context) => GranpaHome()
        },
        home: Wrapper(),
      ),
    ),
  );
}

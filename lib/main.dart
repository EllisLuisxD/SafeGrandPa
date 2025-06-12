import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/models/userInitial.dart'; // Tu modelo UserInitial
import 'package:safegrandpa/screens/auth/wrapper.dart';
import 'package:safegrandpa/screens/home/family_home.dart';
import 'package:safegrandpa/screens/home/granpa_home.dart';
import 'package:safegrandpa/services/authService.dart'; // Tu AuthService
import 'package:safegrandpa/services/databaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        // 1. Provider para la INSTANCIA de AuthService
        // Esto hace que AuthService esté disponible para ser consumido
        Provider<Authservice>(
          // Asegúrate que el nombre de la clase sea exactamente Authservice
          create: (_) => Authservice(),
        ),
        // 2. StreamProvider para el estado del usuario (UserInitial)
        // Este depende de la instancia de AuthService que acabamos de proporcionar.
        StreamProvider<UserData?>.value(
          // Accedemos a la instancia de AuthService desde el contexto del Provider
          value: Authservice()
              .user, // O context.read<Authservice>().user si prefieres
          initialData: null,
        ),
        // 3. Provider para la INSTANCIA de DatabaseService
        // No necesita UID en su constructor si solo va a usar firestore.instance
        // Si siempre usa UID, se inicializaría de otra forma (ej. ProxyProvider)
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/familyHome': (context) => FamilyHome(),
          '/granpaHome': (context) => GranpaHome()
        },
        home: Wrapper(),
      ),
    ),
  );
}

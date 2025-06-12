import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userInitial.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/services/databaseService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authservice _auth = Authservice();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInitial>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Home Prueba'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
                print('Se cerró la sesión');
              },
              label: Text('Logout'),
              icon: Icon(Icons.person),
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white)),
            ),
          ],
        ),
        body: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userDataStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Cargando datos..."));
            }

            UserData? userData = snapshot.data;

            return Center(
              child: Column(
                children: [
                  Text('Email: ${userData!.email}'),
                  Text('Nombre: ${userData.nombre}'),
                  Text('UserType: ${userData.userType}'),
                  Text('Phone: ${userData.phone}'),
                ],
              ),
            );
          },
        ));
  }
}

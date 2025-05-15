import 'package:flutter/material.dart';
import 'package:safegrandpa/services/authService.dart';

class FamilyHome extends StatefulWidget {
  const FamilyHome({super.key});

  @override
  State<FamilyHome> createState() => _FamilyHomeState();
}

class _FamilyHomeState extends State<FamilyHome> {
  final Authservice _auth = Authservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Home'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
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
      body: Center(
        child: Text('Este es el home para los Familiares :D'),
      ),
    );
  }
}

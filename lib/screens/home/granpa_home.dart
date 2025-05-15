import 'package:flutter/material.dart';
import 'package:safegrandpa/services/authService.dart';

class GranpaHome extends StatefulWidget {
  const GranpaHome({super.key});

  @override
  State<GranpaHome> createState() => _GranpaHomeState();
}

class _GranpaHomeState extends State<GranpaHome> {
  final Authservice _auth = Authservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Granpa Home'),
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
        child: Text('Este es el home para los Abuelos :D'),
      ),
    );
  }
}

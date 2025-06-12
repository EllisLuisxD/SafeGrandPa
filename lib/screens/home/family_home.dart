// lib/screens/home/family_home.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/emergency_alert.dart';
import 'package:safegrandpa/models/userData.dart'; // <--- ¡IMPORTANTE! Usar UserData
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/services/databaseService.dart';
import 'package:safegrandpa/screens/map_screen.dart';

class FamilyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context, listen: false);
    // <--- ¡CAMBIO AQUÍ! USAMOS UserData EN LUGAR DE UserInitial
    final UserData? user = Provider.of<UserData?>(context);

    final databaseService =
        DatabaseService(uid: user?.uid); // Usamos user?.uid aquí

    return Scaffold(
      appBar: AppBar(
        title: const Text('SGP - Familiar'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.black),
            label: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.black)),
            onPressed: () async {
              await authService.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Alertas de Emergencia:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<EmergencyAlert>>(
              stream: databaseService
                  .getActiveEmergencyAlertsForFamily(user?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error al cargar alertas: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay alertas de emergencia activas.'));
                } else {
                  final alerts = snapshot.data!;
                  return ListView.builder(
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.red[50],
                        child: ListTile(
                          leading: const Icon(Icons.crisis_alert,
                              color: Colors.red, size: 40),
                          title: Text(
                            'Alerta de ${alert.senderName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Latitud: ${alert.latitude.toStringAsFixed(4)}'),
                              Text(
                                  'Longitud: ${alert.longitude.toStringAsFixed(4)}'),
                              Text(
                                  'Enviada: ${alert.timestamp.toLocal().toString().split('.')[0]}'),
                              Text('Estado: ${alert.status.toUpperCase()}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.location_on,
                                    color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                        latitude: alert.latitude,
                                        longitude: alert.longitude,
                                        grandpaName: alert.senderName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

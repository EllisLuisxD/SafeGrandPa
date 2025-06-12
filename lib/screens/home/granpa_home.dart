// lib/screens/home/granpa_home.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/services/databaseService.dart';
import '../../services/geolocator_service.dart';
import '../../models/emergency_alert.dart';

class GranpaHome extends StatelessWidget {
  Future<void> _sendPanicAlert(
    BuildContext context,
    DatabaseService databaseService,
    GeolocatorService geolocatorService,
    String senderUid,
    String senderName,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Obteniendo ubicación y enviando alerta...')),
    );

    try {
      final position = await geolocatorService.getCurrentLocation();

      if (position != null) {
        final newAlert = EmergencyAlert(
          id: databaseService.getNewDocId('emergencyAlerts'),
          senderUid: senderUid,
          senderName: senderName, // Aquí ya viene el nombre correcto
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now(),
          status: 'pending',
        );

        await databaseService.addEmergencyAlert(newAlert);
        print(
            'Alerta de pánico enviada desde: ${position.latitude}, ${position.longitude} por $senderName');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Alerta de pánico enviada con éxito!')),
        );
      } else {
        print('No se pudo obtener la ubicación para la alerta de pánico.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pudo obtener la ubicación para la alerta.')),
        );
      }
    } catch (e) {
      print('Error al enviar la alerta de pánico: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar alerta: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context, listen: false);
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final geolocatorService = GeolocatorService();
    // <--- ¡CAMBIO AQUÍ! USAMOS UserData EN LUGAR DE UserInitial
    final UserData? user = Provider.of<UserData?>(context);

    // Verificamos que el usuario y sus datos estén disponibles
    if (user == null || user.uid == null || user.nombre == null) {
      // <--- Usamos user.nombre
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Obtenemos el nombre y UID del usuario actual (abuelo)
    final String grandpaName =
        user.nombre; // <--- Ya es String, no necesita '!' si está requerido
    final String grandpaUid =
        user.uid!; // <--- Asumiendo que uid podría ser nullable en tu modelo

    return Scaffold(
      appBar: AppBar(
        title: const Text('SGP - Abuelo'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido, $grandpaName!', // Muestra el nombre real del abuelo
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () async {
                await _sendPanicAlert(
                  context,
                  databaseService,
                  geolocatorService,
                  grandpaUid,
                  grandpaName, // <-- ¡Aquí se pasa el nombre correcto!
                );
              },
              icon:
                  const Icon(Icons.crisis_alert, size: 80, color: Colors.white),
              label: const Text(
                'BOTÓN DE PÁNICO',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(80),
                elevation: 10,
                shadowColor: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pulsa para enviar una alerta a tus familiares',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

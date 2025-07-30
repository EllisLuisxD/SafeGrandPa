// lib/screens/home/granpa_home.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/services/databaseService.dart';
import 'package:safegrandpa/models/emergency_alert.dart';
import 'package:safegrandpa/services/geolocator_service.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback

class GranpaHome extends StatefulWidget {
  @override
  _GranpaHomeState createState() => _GranpaHomeState();
}

class _GranpaHomeState extends State<GranpaHome> {
  Future<void> _sendPanicAlert(
    BuildContext context,
    DatabaseService databaseService,
    GeolocatorService geolocatorService,
    String senderUid,
    String senderName,
  ) async {
    // Proporcionar feedback háptico al presionar el botón de pánico
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Obteniendo ubicación y enviando alerta...'),
        backgroundColor: Color(0xFFFFA000), // Usar color de acento
      ),
    );
    print(
        'SenderUid: $senderUid\ SenderName: $senderName\ Geolocator: $geolocatorService');

    try {
      final position = await geolocatorService.getCurrentLocation();

      if (position != null) {
        final newAlert = EmergencyAlert(
          id: databaseService.getNewDocId('emergencyAlerts'),
          senderUid: senderUid,
          senderName: senderName,
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now(),
          status: 'pending',
        );

        await databaseService.addEmergencyAlert(newAlert);
        print(
            'Alerta de pánico enviada desde: ${position.latitude}, ${position.longitude} por $senderName');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Alerta de pánico enviada con éxito!'),
            backgroundColor: Color(0xFF4CAF50), // Un verde para éxito
          ),
        );
      } else {
        print('No se pudo obtener la ubicación para la alerta de pánico.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener la ubicación para la alerta.'),
            backgroundColor: Color(0xFFE53935), // Un rojo para error
          ),
        );
      }
    } catch (e) {
      print('Error al enviar la alerta de pánico: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar alerta: $e'),
          backgroundColor: const Color(0xFFE53935), // Un rojo para error
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context, listen: false);
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final geolocatorService = GeolocatorService();

    final UserData? user = Provider.of<UserData?>(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SafeGrandpa',
              style: TextStyle(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor:
              const Color(0xFF4A00E0), // Color de la barra de app consistente
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8E2DE2),
                Color(0xFF4A00E0),
              ],
            ),
          ),
          child: const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
        ),
      );
    }

    final String grandpaName = user.name;
    final String grandpaUid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeGrandpa',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter')),
        backgroundColor:
            const Color(0xFF4A00E0), // Color de la barra de app consistente
        elevation: 0, // Sin sombra para un look moderno
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.logout,
                color: Colors.white70), // Icono de cerrar sesión
            label: const Text(
              'Salir', // Texto más conciso
              style: TextStyle(
                  color: Colors.white70, fontSize: 16, fontFamily: 'Inter'),
            ),
            onPressed: () async {
              await authService.signOut();
            },
          )
        ],
      ),
      body: Container(
        // Fondo con gradiente para el cuerpo de la pantalla
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8E2DE2), // Un violeta profundo
              Color(0xFF4A00E0), // Un azul-violeta oscuro
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Título de bienvenida
              Text(
                '¡Hola, ${grandpaName.split(' ')[0]}!', // Mostrar solo el primer nombre
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu seguridad es nuestra prioridad.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Tarjeta del Código de Abuelo
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                color: Colors.white.withOpacity(0.95), // Fondo casi blanco
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Esquinas más redondeadas
                ),
                elevation: 10, // Sombra más pronunciada
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      const Icon(Icons.vpn_key_rounded,
                          size: 40, color: Color(0xFF4A00E0)), // Icono de llave
                      const SizedBox(height: 15),
                      const Text(
                        'Tu Código de Seguridad para compartir:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A00E0), // Color consistente
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        user.uid,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color:
                              Colors.grey[800], // Color más oscuro para el UID
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2, // Espaciado entre letras
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Botón para copiar el UID
                      OutlinedButton.icon(
                        icon: const Icon(Icons.copy, size: 20),
                        label: const Text('Copiar Código'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4A00E0),
                          side: const BorderSide(
                              color: Color(0xFF4A00E0), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: user.uid));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Código copiado al portapapeles.'),
                              backgroundColor: Color(0xFF4CAF50),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: 50), // Espaciado mayor antes del botón de pánico

              // Botón de Pánico
              ElevatedButton.icon(
                icon: const Icon(Icons.warning_rounded,
                    size: 45), // Icono más visible y redondeado
                label: const Text(
                  'ALERTA DE PÁNICO', // Texto en mayúsculas
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935), // Rojo intenso
                  foregroundColor: Colors.white,
                  minimumSize: const Size(280, 90), // Botón más grande
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50.0), // Totalmente redondeado (pastilla)
                  ),
                  elevation: 15, // Sombra grande para destacar
                  shadowColor: Colors.redAccent.withOpacity(0.6), // Sombra roja
                ),
                onPressed: () async {
                  await _sendPanicAlert(context, databaseService,
                      geolocatorService, grandpaUid, grandpaName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

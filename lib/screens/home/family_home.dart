// lib/screens/home/family_home.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/emergency_alert.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/services/databaseService.dart';
import 'package:safegrandpa/screens/map_screen.dart';
import 'package:safegrandpa/screens/link_grandpa_screen.dart';

class FamilyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context, listen: false);
    final UserData? user =
        Provider.of<UserData?>(context); // El user actual (familiar)
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    // Si user es null (datos aún no cargados), puedes mostrar un CircularProgressIndicator
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SafeGrandpa',
              style: TextStyle(color: Colors.white, fontFamily: 'Inter')),
          backgroundColor: const Color(0xFF4A00E0),
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

    // Obtener el nombre del familiar para el saludo
    final String familyName = user.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SafeGrandpa',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF4A00E0), // Color consistente
        elevation: 0,
        actions: <Widget>[
          // Botón para Vincular Abuelo
          IconButton(
            icon: const Icon(Icons.group_add,
                color: Colors.white70), // Icono más descriptivo para vincular
            tooltip: 'Vincular a un Abuelo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LinkGrandpaScreen()),
              );
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.logout, color: Colors.white70),
            label: const Text(
              'Salir',
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
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinear el contenido a la izquierda
          children: <Widget>[
            // Saludo al Familiar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  25.0, 25.0, 25.0, 15.0), // Padding más generoso
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Bienvenido, ${familyName.split(' ')[0]}!', // Solo el primer nombre
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Aquí verás las alertas de tus abuelos vinculados.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            // Título de la sección de alertas
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Text(
                'Alertas Activas:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<EmergencyAlert>>(
                stream: databaseService.getActiveEmergencyAlertsForFamily(
                    user.linkedGrandpaUids ?? []),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white70)));
                  } else if (snapshot.hasError) {
                    print('Error al cargar alertas: ${snapshot.error}');
                    return Center(
                      child: Text(
                        'Error al cargar alertas: ${snapshot.error}',
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Inter'),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 80, color: Colors.white54),
                          const SizedBox(height: 15),
                          const Text(
                            '¡No hay alertas activas en este momento!',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Todo parece estar en calma.',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                                fontFamily: 'Inter'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.group_add, size: 20),
                            label: const Text('Vincular Nuevo Abuelo'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LinkGrandpaScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFFFA000), // Naranja vibrante
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final alerts = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alert = alerts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5.0),
                          color: Colors.white.withOpacity(
                              0.98), // Fondo de tarjeta casi blanco
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 6, // Sombra para destacar
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.crisis_alert,
                                        color: Color(0xFFE53935),
                                        size: 35), // Rojo de alerta
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Alerta de ${alert.senderName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                          color: Color(
                                              0xFF4A00E0), // Texto principal en violeta
                                          fontFamily: 'Inter',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Estado de la alerta
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: alert.status == 'pending'
                                            ? const Color(0xFFFFA000)
                                                .withOpacity(0.2)
                                            : Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        alert.status.toUpperCase(),
                                        style: TextStyle(
                                          color: alert.status == 'pending'
                                              ? const Color(0xFFFFA000)
                                              : Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                    height: 20,
                                    thickness: 1,
                                    color: Colors.grey), // Separador
                                Text(
                                  'Enviada: ${alert.timestamp.toLocal().toString().split('.')[0]}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Ubicación: Lat ${alert.latitude.toStringAsFixed(4)}, Lon ${alert.longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.location_on,
                                            size: 20),
                                        label: const Text('Ver Mapa'),
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
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                              0xFF4A00E0), // Morado principal
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        icon: const Icon(
                                            Icons.check_circle_outline,
                                            size: 20),
                                        label: const Text('Resuelta'),
                                        onPressed: () async {
                                          final bool? confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                title: const Text(
                                                    'Confirmar Resolución',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                content: Text(
                                                  '¿Estás seguro de que deseas marcar la alerta de ${alert.senderName} como resuelta?',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(false);
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text(
                                                        'Confirmar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(true);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: const Color(
                                                          0xFF4CAF50), // Verde de confirmación
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirm == true) {
                                            await databaseService
                                                .updateEmergencyAlertStatus(
                                              alert.id,
                                              'resolved',
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Alerta de ${alert.senderName} marcada como resuelta.'),
                                                backgroundColor: const Color(
                                                    0xFF4CAF50), // Verde para éxito
                                              ),
                                            );
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                              0xFF4CAF50), // Verde para resuelta
                                          side: const BorderSide(
                                              color: Color(0xFF4CAF50),
                                              width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}

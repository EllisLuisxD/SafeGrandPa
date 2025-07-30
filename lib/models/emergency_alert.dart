// lib/models/emergency_alert.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyAlert {
  final String id;
  final String senderUid;
  final String senderName;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String status;

  EmergencyAlert({
    required this.id,
    required this.senderUid,
    required this.senderName,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.status,
  });

  // Constructor para crear un objeto EmergencyAlert desde un DocumentSnapshot de Firestore
  factory EmergencyAlert.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EmergencyAlert(
      id: doc.id,
      senderUid: data['senderUid'] ?? '',
      senderName:
          data['senderName'] ?? 'Abuelo Desconocido', // <--- LEER EL CAMPO
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }

  // Método para convertir un objeto EmergencyAlert a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'senderName': senderName,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }
}

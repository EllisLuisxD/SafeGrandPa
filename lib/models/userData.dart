// lib/models/userData.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String name;
  final String userType; // 'Familiar' o 'Abuelo'
  final String phoneNumber;
  final String email;
  final double? latitude; // Solo para Abuelo
  final double? longitude; // Solo para Abuelo
  final List<String>?
      linkedGrandpaUids; // Nuevo: Para familiares, UIDs de abuelos vinculados
  final List<String>?
      linkedFamilyUids; // Nuevo: Para abuelos, UIDs de familiares vinculados

  UserData({
    required this.uid,
    required this.name,
    required this.userType,
    required this.phoneNumber,
    required this.email,
    this.latitude,
    this.longitude,
    this.linkedGrandpaUids, // Añadir al constructor
    this.linkedFamilyUids, // Añadir al constructor
  });

  // Factory constructor para crear UserData desde un documento de Firestore
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      uid: doc.id,
      name: data['name'] ?? '',
      userType: data['userType'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      latitude: data['latitude'] is double ? data['latitude'] : null,
      longitude: data['longitude'] is double ? data['longitude'] : null,
      // Asegúrate de que estos campos se lean como List<String>
      linkedGrandpaUids: (data['linkedGrandpaUids'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      linkedFamilyUids: (data['linkedFamilyUids'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
    );
  }

  // Método para convertir UserData a un mapa para Firestore (cuando se actualiza)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userType': userType,
      'phoneNumber': phoneNumber,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'linkedGrandpaUids': linkedGrandpaUids,
      'linkedFamilyUids': linkedFamilyUids,
    };
  }
}

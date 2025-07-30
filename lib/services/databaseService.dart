// lib/services/databaseService.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/models/emergency_alert.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Colección de usuarios (he cambiado "Users" a "users" por convención)
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  // Colección para alertas de emergencia
  final CollectionReference _emergencyAlertsCollection =
      FirebaseFirestore.instance.collection('emergencyAlerts');

  // Método para actualizar los datos del usuario (usado en registro y perfil)
  Future<void> updateUserData(String name, String userType, String phoneNumber,
      {String? email, double? latitude, double? longitude}) async {
    // Asegurarse de que el UID no sea nulo antes de intentar guardar
    if (uid == null) {
      print('Error: UID de usuario es nulo. No se puede actualizar el perfil.');
      return;
    }
    return await userCollection.doc(uid).set(
        {
          "name": name,
          'email': email ?? '', // Se mantiene para compatibilidad si lo usas
          'userType': userType,
          "phoneNumber": phoneNumber,
          'latitude': latitude, // Añadido para guardar latitud
          'longitude': longitude, // Añadido para guardar longitud
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(
            merge:
                true)); // Usa merge: true para no sobrescribir documentos completos
  }

  // get UserData Stream (para escuchar cambios en tiempo real)
  Stream<UserData?> get userData {
    if (uid == null) {
      return Stream.value(null);
    }
    return userCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserData.fromFirestore(doc);
      }
      return null;
    });
  }

  // **** MÉTODO: Obtener UserData una sola vez (Future) ****
  // Esto es necesario para la validación en LinkGrandpaScreen
  Future<UserData?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserData.fromFirestore(doc);
      }
      return null; // El documento del usuario no existe
    } catch (e) {
      print('Error al obtener datos del usuario desde Firestore (Future): $e');
      return null;
    }
  }

  // **** NUEVOS MÉTODOS PARA LA VINCULACIÓN DE USUARIOS ****

  // Método para vincular un familiar con un abuelo
  Future<String> linkGrandpaToFamily(
      String familyMemberUid, String grandpaUid) async {
    try {
      // 1. Añadir el UID del abuelo a la lista del familiar
      await userCollection.doc(familyMemberUid).update({
        'linkedGrandpaUids': FieldValue.arrayUnion([grandpaUid]),
      });

      // 2. Añadir el UID del familiar a la lista del abuelo
      // Esto es crucial para que el abuelo también tenga registro de sus familiares vinculados
      await userCollection.doc(grandpaUid).update({
        'linkedFamilyUids': FieldValue.arrayUnion([familyMemberUid]),
      });

      return 'Vinculación exitosa.';
    } catch (e) {
      print('Error al vincular abuelo y familiar: $e');
      return 'Error al vincular: ${e.toString()}'; // Más descriptivo
    }
  }

  // Método para desvincular un familiar de un abuelo (opcional, pero útil)
  Future<String> unlinkGrandpaFromFamily(
      String familyMemberUid, String grandpaUid) async {
    try {
      // 1. Eliminar el UID del abuelo de la lista del familiar
      await userCollection.doc(familyMemberUid).update({
        'linkedGrandpaUids': FieldValue.arrayRemove([grandpaUid]),
      });

      // 2. Eliminar el UID del familiar de la lista del abuelo
      await userCollection.doc(grandpaUid).update({
        'linkedFamilyUids': FieldValue.arrayRemove([familyMemberUid]),
      });

      return 'Desvinculación exitosa.';
    } catch (e) {
      print('Error al desvincular abuelo y familiar: $e');
      return 'Error al desvincular: ${e.toString()}';
    }
  }

  // **** MÉTODOS PARA ALERTAS DE EMERGENCIA ****

  // Método para generar un ID de documento único para Firestore
  String getNewDocId(String collectionPath) {
    return FirebaseFirestore.instance.collection(collectionPath).doc().id;
  }

  // Método para agregar una alerta de emergencia a Firestore
  Future<void> addEmergencyAlert(EmergencyAlert alert) async {
    return await _emergencyAlertsCollection.doc(alert.id).set(alert.toMap());
  }

  // Marcar una alerta como resuelta/atendida
  Future<void> updateEmergencyAlertStatus(
      String alertId, String newStatus) async {
    try {
      await _emergencyAlertsCollection.doc(alertId).update({
        'status': newStatus,
        'resolvedAt': FieldValue.serverTimestamp(),
      });
      print('Alerta $alertId actualizada a estado: $newStatus');
    } catch (e) {
      print('Error al actualizar el estado de la alerta $alertId: $e');
    }
  }

  // Opcional: Método para obtener las alertas activas para los familiares
  // MODIFICADO: Ahora requiere la lista de UIDs de abuelos vinculados
  Stream<List<EmergencyAlert>> getActiveEmergencyAlertsForFamily(
      List<String> linkedGrandpaUids) {
    // Si no hay abuelos vinculados, devuelve un stream vacío inmediatamente.
    // Esto evita que la consulta de Firestore falle con una lista whereIn vacía.
    if (linkedGrandpaUids.isEmpty) {
      return Stream.value([]);
    }

    // IMPORTANTE: Firestore whereIn tiene un límite de 10 elementos.
    // Si un familiar puede tener más de 10 abuelos vinculados, esta lógica
    // necesitará ser extendida para realizar múltiples consultas o usar Cloud Functions.
    return _emergencyAlertsCollection
        .where('status', isEqualTo: 'pending')
        .where('senderUid', whereIn: linkedGrandpaUids) // <--- ¡FILTRADO CLAVE!
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmergencyAlert.fromFirestore(doc))
            .toList());
  }
}

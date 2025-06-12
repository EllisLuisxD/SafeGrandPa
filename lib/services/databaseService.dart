// lib/services/database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safegrandpa/models/userData.dart'; // Tu modelo UserData existente
import 'package:safegrandpa/models/emergency_alert.dart'; // El nuevo modelo de alerta

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Colección de usuarios
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  // NUEVA Colección para alertas de emergencia
  final CollectionReference _emergencyAlertsCollection =
      FirebaseFirestore.instance.collection('emergencyAlerts');

  // Método para actualizar los datos del usuario (usado en registro)
  Future<void> udpateUserData(
      String? nombre, String? email, String? userType, String? phone) async {
    return await userCollection
        .doc(uid) // sirv para referenciar un documento en específico
        .set(
            {
          "nombre":
              nombre ?? '', // Asegura que si es null, guarda un string vacío
          'email': email ?? '',
          'userType': userType ?? '',
          "phone": phone ?? '',
          'createdAt':
              FieldValue.serverTimestamp(), // Opcional: timestamp de creación
        },
            SetOptions(
                merge:
                    true)); // Usa merge: true para no sobrescribir documentos completos
  }

  // userData from snapshot (método auxiliar para el stream)
  // Este método asume que el snapshot.data() no es null.
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    // Asegurarse de que el snapshot tiene datos antes de intentar acceder a ellos
    if (!snapshot.exists || snapshot.data() == null) {
      // Devolver un UserData por defecto o lanzar un error, dependiendo de tu lógica
      return UserData(
          uid: snapshot.id,
          nombre: 'Desconocido',
          email: '',
          userType: '',
          phone: '');
    }

    Map<String, dynamic> data = snapshot.data()!
        as Map<String, dynamic>; // Usamos '!' con precaución aquí

    return UserData(
      uid: snapshot.id, // Usa snapshot.id para el UID del documento
      nombre: data['nombre'] ??
          'Sin Nombre', // Proporciona un valor predeterminado si es null
      email: data['email'] ?? 'sinemail@ejemplo.com',
      userType: data['userType'] ?? 'unknown',
      phone: data['phone'] ?? '000-000-0000',
    );
  }

  // get UserData Stream (para escuchar cambios en tiempo real)
  Stream<UserData> get userDataStream {
    // Renombrado a userDataStream para evitar conflicto
    if (uid == null) {
      // Si no hay UID, no podemos escuchar el stream de un documento específico
      // Puedes devolver un stream vacío o uno con un UserData por defecto.
      return Stream.value(
          UserData(uid: null, nombre: '', email: '', userType: '', phone: ''));
    }
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // **** NUEVO MÉTODO: Obtener UserData una sola vez (Future) ****
  // Este es el método que AuthService necesita después del login.
  Future<UserData?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        return UserData(
          uid: userId,
          nombre: data['nombre'] ?? 'Sin Nombre',
          email: data['email'] ?? 'sinemail@ejemplo.com',
          userType: data['userType'] ?? 'unknown',
          phone: data['phone'] ?? '000-000-0000',
        );
      }
      return null; // El documento del usuario no existe
    } catch (e) {
      print('Error al obtener datos del usuario desde Firestore (Future): $e');
      return null;
    }
  }

  // **** NUEVOS MÉTODOS PARA ALERTAS DE EMERGENCIA ****

  // Método para generar un ID de documento único para Firestore
  String getNewDocId(String collectionPath) {
    return FirebaseFirestore.instance.collection(collectionPath).doc().id;
  }

  // Método para agregar una alerta de emergencia a Firestore
  Future<void> addEmergencyAlert(EmergencyAlert alert) async {
    // Recibe el objeto EmergencyAlert completo
    return await _emergencyAlertsCollection.doc(alert.id).set(alert.toMap());
  }

  // Opcional: Método para obtener las alertas activas para los familiares
  Stream<List<EmergencyAlert>> getActiveEmergencyAlertsForFamily(
      String familyMemberUid) {
    // Aquí la lógica para filtrar por los abuelos asociados a este familiar
    // Actualmente, esto devuelve TODAS las alertas pendientes, no solo las de los abuelos asociados.
    // Para filtrar por abuelos asociados, necesitarías una lista de UIDs de abuelos en el documento del familiar.
    return _emergencyAlertsCollection
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmergencyAlert.fromFirestore(doc))
            .toList());
  }
}

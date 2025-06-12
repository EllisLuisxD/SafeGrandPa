// lib/services/geolocator_service.dart

import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  // Verifica si los servicios de ubicación están habilitados en el dispositivo
  Future<bool> checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Los servicios de ubicación están deshabilitados.');
      // Puedes mostrar un diálogo al usuario para que los habilite
      return false;
    }
    return true;
  }

  // Solicita los permisos de ubicación a la aplicación
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permisos de ubicación denegados por el usuario.');
        // Puedes mostrar un mensaje al usuario sobre la necesidad de permisos
        return LocationPermission.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Permisos de ubicación denegados permanentemente. Solicitar al usuario que los habilite manualmente desde la configuración.');
      // Puedes abrir la configuración de la aplicación para que el usuario habilite los permisos
      await Geolocator.openAppSettings();
      return LocationPermission.deniedForever;
    }

    return permission;
  }

  // Obtiene la ubicación actual del dispositivo
  Future<Position?> getCurrentLocation() async {
    try {
      // Primero, verificar si los servicios de ubicación están habilitados
      bool serviceEnabled = await checkLocationService();
      if (!serviceEnabled) return null;

      // Segundo, verificar y solicitar permisos
      LocationPermission permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Si todo está bien, obtener la posición actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Alta precisión
      );
      return position;
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      return null;
    }
  }
}

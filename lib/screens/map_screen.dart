// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String grandpaName;

  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.grandpaName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Coordenadas de la alerta
    final LatLng alertLocation = LatLng(latitude, longitude);

    // Marcador para la ubicación de la alerta
    final Marker alertMarker = Marker(
      markerId: MarkerId('alert_location'),
      position: alertLocation,
      infoWindow: InfoWindow(
          title: 'Alerta de $grandpaName'), // Muestra el nombre del abuelo
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación de la Alerta'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: alertLocation,
          zoom: 15.0, // Ajusta el zoom según sea necesario
        ),
        markers: {alertMarker}, // Muestra el marcador
      ),
    );
  }
}

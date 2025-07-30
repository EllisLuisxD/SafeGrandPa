// lib/widgets/loading.dart

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fondo con gradiente, consistente con las pantallas de autenticación
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de carga
            SpinKitFoldingCube(
              // Cambiado a SpinKitFoldingCube para un efecto más moderno y dinámico
              color: Color(
                  0xFFFFA000), // Usamos el naranja vibrante del botón principal
              size: 50.0,
            ),
            SizedBox(height: 20),
            // Mensaje opcional de carga
            Text(
              'Cargando...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

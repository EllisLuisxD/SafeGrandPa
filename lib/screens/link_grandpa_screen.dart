// lib/screens/link_grandpa_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/userData.dart';
import 'package:safegrandpa/services/databaseService.dart';

class LinkGrandpaScreen extends StatefulWidget {
  @override
  _LinkGrandpaScreenState createState() => _LinkGrandpaScreenState();
}

class _LinkGrandpaScreenState extends State<LinkGrandpaScreen> {
  final _formKey = GlobalKey<FormState>();
  String _grandpaUid = '';
  String _errorMessage = '';
  bool _isLoading = false;

  // Controlador para limpiar el texto del UID después de un intento
  final TextEditingController _uidController = TextEditingController();

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final UserData? currentUser = Provider.of<UserData?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vincular Abuelo', // Título más conciso
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'),
        ),
        backgroundColor: const Color(0xFF4A00E0), // Color consistente
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.white), // Color del icono de retroceso
      ),
      body: Container(
        // Fondo con gradiente, consistente con el resto de la app
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
          child: SingleChildScrollView(
            // Añadimos SingleChildScrollView por si el teclado cubre los campos
            padding: const EdgeInsets.all(25.0), // Padding generoso
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icono grande para destacar la acción
                  const Icon(
                    Icons
                        .connect_without_contact, // Icono de conexión o vínculo
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // Mensaje instructivo
                  const Text(
                    'Pide a tu abuelo su Código de Seguridad (UID) y vincúlalo a tu cuenta para recibir sus alertas.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      height: 1.4, // Espaciado de línea
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Campo de texto para el UID del Abuelo
                  TextFormField(
                    controller: _uidController, // Usar el controlador
                    decoration: InputDecoration(
                      labelText: 'Código del Abuelo (UID)',
                      labelStyle: TextStyle(
                          color: Colors.grey[700], fontFamily: 'Inter'),
                      hintText: 'Ej: abcdefg1234567890',
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontFamily: 'Inter'),
                      fillColor:
                          Colors.white.withOpacity(0.95), // Fondo casi blanco
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // Esquinas redondeadas
                        borderSide: BorderSide.none, // Sin borde visible
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.7), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFFFA000),
                            width: 2.0), // Borde resaltado al enfocar
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFE53935),
                            width: 2.0), // Borde rojo para error
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFE53935), width: 2.0),
                      ),
                      prefixIcon: const Icon(Icons.qr_code_rounded,
                          color:
                              Color(0xFF4A00E0)), // Icono de código o vínculo
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 20.0),
                    ),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontFamily: 'Inter'),
                    validator: (val) => val!.isEmpty
                        ? 'Por favor, ingresa un UID válido'
                        : null,
                    onChanged: (val) {
                      setState(() => _grandpaUid = val.trim());
                    },
                  ),
                  const SizedBox(height: 30),
                  // Indicador de carga o Botón de Vinculación
                  _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white)) // Indicador de carga blanco
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.link_rounded,
                              size: 25), // Icono más moderno
                          label: const Text(
                            'Vincular Abuelo',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFFA000), // Naranja vibrante
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 40), // Padding más generoso
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Esquinas redondeadas
                            ),
                            elevation: 8, // Sombra para destacar
                            shadowColor: Colors.orangeAccent.withOpacity(0.6),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = '';
                              });

                              if (_grandpaUid == currentUser?.uid) {
                                setState(() {
                                  _errorMessage =
                                      'No puedes vincularte a ti mismo.';
                                  _isLoading = false;
                                });
                                return;
                              }

                              final UserData? grandpaData =
                                  await databaseService
                                      .getUserData(_grandpaUid);

                              if (grandpaData == null) {
                                setState(() {
                                  _errorMessage =
                                      'Código no encontrado. Por favor, verifica el UID.';
                                  _isLoading = false;
                                });
                                return;
                              }
                              if (grandpaData.userType != 'Abuelo') {
                                setState(() {
                                  _errorMessage =
                                      'El código ingresado no pertenece a un Abuelo.';
                                  _isLoading = false;
                                });
                                return;
                              }

                              if (currentUser?.uid != null) {
                                final String result =
                                    await databaseService.linkGrandpaToFamily(
                                  currentUser!.uid,
                                  _grandpaUid,
                                );

                                setState(() {
                                  _isLoading = false;
                                  _uidController
                                      .clear(); // Limpiar el campo después del intento
                                });

                                if (result == 'Vinculación exitosa.') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('¡Abuelo vinculado con éxito!'),
                                      backgroundColor:
                                          Color(0xFF4CAF50), // Verde para éxito
                                    ),
                                  );
                                  Navigator.pop(
                                      context); // Volver a la pantalla anterior
                                } else {
                                  setState(() {
                                    _errorMessage =
                                        result; // Mostrar el error específico
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    // Mostrar también en SnackBar
                                    SnackBar(
                                      content:
                                          Text('Error al vincular: $result'),
                                      backgroundColor: const Color(
                                          0xFFE53935), // Rojo para error
                                    ),
                                  );
                                }
                              } else {
                                setState(() {
                                  _errorMessage =
                                      'Error: No se pudo obtener el UID del familiar.';
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                        ),
                  const SizedBox(height: 15),
                  // Mensaje de error
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

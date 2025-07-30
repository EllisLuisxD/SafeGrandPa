// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/widgets/loading.dart'; // Asegúrate de que este widget de carga sea visible y funcional

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  const RegisterScreen({super.key, required this.toggleView});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Authservice _auth = Authservice();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String error = '';
  bool loading = false;

  final List<String> userType = [
    'Abuelo',
    'Familiar',
  ];

  String? types; // Usado para el valor seleccionado del Dropdown

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formWidth = MediaQuery.of(context).size.width *
        0.8; // Aumentamos un poco el ancho para los campos

    return loading
        ? const Loading() // Asegúrate de que Loading() sea un widget const si es posible
        : Scaffold(
            // Fondo con gradiente suave, consistente con LoginScreen
            body: Container(
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
                // Eliminamos SingleChildScrollView
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0), // Padding lateral
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo o Icono de la App (tamaño ligeramente reducido)
                      const Icon(
                        Icons.person_add_alt_1, // Icono sugerente de registro
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15), // Espaciado reducido
                      // Título
                      const Text(
                        'Crea tu Cuenta', // Título más conciso
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26, // Fuente ligeramente más pequeña
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // El subtítulo lo podríamos omitir si es muy apretado en pantallas pequeñas.
                      // Por ahora, lo mantenemos con un espacio reducido.
                      const SizedBox(height: 8),
                      const Text(
                        'Completa tus datos para empezar.', // Subtítulo más conciso
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25), // Espaciado reducido

                      Form(
                        key: _key,
                        child: Column(
                          children: [
                            // Campo de Nombre
                            SizedBox(
                              width: formWidth,
                              child: TextFormField(
                                controller: nameController,
                                validator: (value) =>
                                    value!.isEmpty ? 'Ingresa tu nombre' : null,
                                decoration: InputDecoration(
                                  hintText: 'Nombre Completo',
                                  fillColor: Colors.white.withOpacity(0.9),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.person,
                                      color: Color(0xFF4A00E0)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 15.0), // Padding interno
                                ),
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 15), // Espaciado reducido

                            // Campo de Email
                            SizedBox(
                              width: formWidth,
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) =>
                                    value!.isEmpty ? 'Ingresa tu correo' : null,
                                decoration: InputDecoration(
                                  hintText: 'Correo Electrónico',
                                  fillColor: Colors.white.withOpacity(0.9),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color(0xFF4A00E0)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 15.0),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 15), // Espaciado reducido

                            // Campo de Contraseña
                            SizedBox(
                              width: formWidth,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                validator: (value) => value!.isEmpty
                                    ? 'Ingresa tu contraseña'
                                    : null,
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  fillColor: Colors.white.withOpacity(0.9),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Color(0xFF4A00E0)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 15.0),
                                ),
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 15), // Espaciado reducido

                            // Campo de Teléfono
                            SizedBox(
                              width: formWidth,
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                maxLength: 9,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa tu teléfono';
                                  }
                                  if (value.length != 9) {
                                    return 'El teléfono debe tener 9 dígitos';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      'Teléfono (9 dígitos)', // Mensaje más corto
                                  fillColor: Colors.white.withOpacity(0.9),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.phone,
                                      color: Color(0xFF4A00E0)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 15.0),
                                  counterText: "",
                                ),
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 15), // Espaciado reducido

                            // Dropdown de Tipo de Usuario
                            Container(
                              width:
                                  formWidth, // Usar el mismo ancho que los TextField
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: DropdownButtonFormField<String>(
                                items: userType.map(
                                  (type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    );
                                  },
                                ).toList(),
                                hint: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0), // Ajuste para el ícono
                                  child: Text('Tipo de Usuario',
                                      style: TextStyle(
                                          color: Colors
                                              .black54)), // Mensaje más conciso
                                ),
                                value: types,
                                onChanged: (value) {
                                  setState(() {
                                    types = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Escoja su tipo de usuario'
                                    : null,
                                decoration: const InputDecoration(
                                  border: InputBorder
                                      .none, // Elimina el borde del Dropdown
                                  prefixIcon: Icon(Icons.group,
                                      color: Color(0xFF4A00E0)),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 0.0), // Ajustar padding
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 16),
                                iconEnabledColor: const Color(0xFF4A00E0),
                              ),
                            ),
                            const SizedBox(height: 25), // Espaciado reducido

                            // Botón de Registrar
                            ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                    error = '';
                                  });

                                  String getEmail = emailController.text.trim();
                                  String getPassword =
                                      passwordController.text.trim();
                                  String getPhone = phoneController.text.trim();
                                  String getNameController =
                                      nameController.text.trim();
                                  String getUserType = types!;

                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                    getEmail,
                                    getPassword,
                                    getNameController,
                                    getUserType,
                                    getPhone,
                                  );

                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Error al registrar. El correo podría estar en uso o las credenciales no son válidas.';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA000),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 14), // Padding reducido
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                                minimumSize: Size(formWidth,
                                    48), // Ancho completo y altura ligeramente reducida
                              ),
                              child: const Text(
                                'REGISTRARME',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        'Inter'), // Fuente ligeramente más pequeña
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15), // Espaciado reducido
                      // Mensaje de Error
                      Text(
                        error,
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontFamily: 'Inter'), // Fuente más pequeña
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15), // Espaciado reducido
                      // Botón para Iniciar Sesión
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          '¿Ya tienes cuenta? Inicia sesión aquí',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15, // Fuente ligeramente más pequeña
                            fontFamily: 'Inter',
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

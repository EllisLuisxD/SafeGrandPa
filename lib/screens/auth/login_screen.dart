// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/widgets/loading.dart'; // Asegúrate de que este widget de carga sea visible y funcional

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  const LoginScreen({super.key, required this.toggleView});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Authservice _auth = Authservice();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String error = '';
  bool loading = false;

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading() // Asegúrate de que Loading() sea un widget const si es posible
        : Scaffold(
            // Fondo con gradiente suave
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
                child: SingleChildScrollView(
                  // Permite desplazamiento si el teclado cubre los campos
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo o Icono de la App
                      const Icon(
                        Icons.shield_outlined, // Un icono que sugiere seguridad
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      // Título
                      const Text(
                        'Bienvenido a SafeGrandpa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter', // Usando una fuente moderna
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Inicia sesión para proteger a tus seres queridos.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      Form(
                        key: _key,
                        child: Column(
                          children: [
                            // Campo de Email
                            TextFormField(
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
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 20),
                            // Campo de Contraseña
                            TextFormField(
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
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 30),

                            // Botón de Iniciar Sesión
                            ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                    error = ''; // Limpiar errores anteriores
                                  });

                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                  );

                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Credenciales incorrectas o usuario no encontrado.';
                                      loading = false;
                                    });
                                  }
                                  // No limpiar controladores aquí si el inicio de sesión es exitoso,
                                  // ya que el widget se desmontará y se navegará a otra pantalla.
                                  // Si falla, los usuarios podrían querer corregir su entrada.
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFFFA000), // Un naranja vibrante
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                                minimumSize: const Size(
                                    double.infinity, 50), // Ancho completo
                              ),
                              child: const Text(
                                'INICIAR SESIÓN',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Mensaje de Error
                      Text(
                        error,
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontFamily: 'Inter'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Botón para Registrarse
                      TextButton(
                        onPressed: () {
                          widget
                              .toggleView(); // Navegar a la pantalla de registro
                        },
                        child: const Text(
                          '¿No tienes cuenta? Regístrate aquí',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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

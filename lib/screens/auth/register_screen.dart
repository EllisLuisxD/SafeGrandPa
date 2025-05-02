import 'package:flutter/material.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/widgets/loading.dart';

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

  String? types;

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Registrarse SGP',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              foregroundColor: Colors.lightBlue,
              backgroundColor: Colors.amber,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: Text('Iniciar Sesión'),
                  icon: Icon(Icons.person),
                  style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white)),
                )
              ],
            ),
            body: Form(
                key: _key,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu nombre';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Nombre'),
                            onChanged: (value) {
                              setState(() {
                                nameController.text = value;
                              });
                            },
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu correo';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email'),
                            onChanged: (value) {
                              setState(() {
                                emailController.text = value;
                              });
                            },
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu contraseña';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password'),
                            onChanged: (value) {
                              setState(() {
                                passwordController.text = value;
                              });
                            },
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu teléfono';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Teléfono'),
                            onChanged: (value) {
                              setState(() {
                                phoneController.text = value;
                              });
                            },
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonFormField(
                          items: userType.map(
                            (userType) {
                              return DropdownMenuItem(
                                child: Text('$userType'),
                                value: userType,
                              );
                            },
                          ).toList(),
                          hint: Text('Escoja el tipo de Usuario'),
                          value: types,
                          onChanged: (value) {
                            setState(() {
                              types = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Escoja su tipo de usuario';
                            }
                            return null;
                          },
                          decoration: InputDecoration(),
                        ),
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });

                              String getEmail = emailController.text;
                              String getPassword = passwordController.text;
                              String getPhone = phoneController.text;
                              String getNameController = nameController.text;
                              String getUserType = types!;

                              emailController.clear();
                              passwordController.clear();
                              phoneController.clear();
                              nameController.clear();

                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      getEmail,
                                      getPassword,
                                      getNameController,
                                      getUserType,
                                      getPhone);

                              if (result != null) {
                                print('Registrado con éxito');
                              } else {
                                setState(() {
                                  error = 'No se pudo validar el correo';
                                  loading = false;
                                });
                              }

                              print("Uid: ${result.uid}");
                            }
                          },
                          label: Text('Registrar')),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )),
          );
  }
}

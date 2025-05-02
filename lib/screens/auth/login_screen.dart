import 'package:flutter/material.dart';
import 'package:safegrandpa/services/authService.dart';
import 'package:safegrandpa/widgets/loading.dart';

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
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Iniciar Sesión SGP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              foregroundColor: Colors.lightBlue,
              backgroundColor: Colors.amber,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    //usamos widget porque estamos trabajando dentro de un StateFul
                    widget.toggleView();
                  },
                  label: Text('Register'),
                  icon: Icon(Icons.person),
                  style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white)),
                )
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: _key,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingresa tu contraseña';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Password'),
                                  onChanged: (value) {
                                    setState(() {
                                      passwordController.text = value;
                                    });
                                  },
                                )),
                            ElevatedButton.icon(
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });

                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text);

                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'No se pudo encontrar los datos';
                                        loading = false;
                                      });
                                    }

                                    emailController.clear();
                                    passwordController.clear();

                                    print("Uid: ${result.uid}");
                                  }
                                },
                                label: Text('Iniciar Sesión'))
                          ],
                        ),
                      )),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          );
  }
}

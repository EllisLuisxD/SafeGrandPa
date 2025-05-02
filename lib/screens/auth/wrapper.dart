import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safegrandpa/models/user.dart';
import 'package:safegrandpa/screens/auth/authenticate.dart';
import 'package:safegrandpa/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInitial?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}

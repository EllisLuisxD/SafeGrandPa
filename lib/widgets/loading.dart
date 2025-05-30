import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: SpinKitFadingCircle(
        color: Colors.amber,
        size: 50.0,
      )),
    );
  }
}

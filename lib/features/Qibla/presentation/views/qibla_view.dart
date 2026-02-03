import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'dart:math' as math;

class QiblaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final qiblahDirection = snapshot.data!;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // صورة البوصلة (الخلفية)
              Transform.rotate(
                angle: (qiblahDirection.direction * (math.pi / 180) * -1),
                child: Image.asset('assets/images/compass.png'),
              ),
              // إبرة البوصلة اللي بتشير للكعبة
              Transform.rotate(
                angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
                child: Image.asset('assets/images/needle.png'),
              ),
            ],
          ),
        );
      },
    );
  }
}

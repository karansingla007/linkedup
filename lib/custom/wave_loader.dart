import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaveLoader {
  static Widget spinKit({
    Color color = Colors.black54,
    double size = 50.0,
  }) {
    return SpinKitWave(
      color: color,
      size: size,
    );
  }

  static Widget threeBounce({Color color = Colors.white, double size = 50.0}) {
    return SpinKitThreeBounce(
      color: color,
      size: size,
    );
  }
}

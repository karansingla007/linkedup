import 'dart:math';

import 'package:flutter/cupertino.dart';

abstract class Styles {
  static const white64 = Color(0xA3FFFFFF);
  static Color getRandomColor() {
    final _colors = <Color>[
      Color(0xFFEB5757),
      Color(0xFFF2994A),
      Color(0xFFF2C94C),
      Color(0xFF27AE60),
      Color(0xFF2D9CDB),
      Color(0xFF56CCF2),
      Color(0xFFBB6BD9),
    ];
    return _colors[getRandomNumber(0, 6)];
  }

  static int getRandomNumber(int min, int max) {
    final _random = new Random();
    return (min + _random.nextInt(max - min));
  }
}

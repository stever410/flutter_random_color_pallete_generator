import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtils {
  static const double goldenRatioConjugate = 0.618033988749895;

  static List<Color> generateRandomPallete(int length) =>
      List.generate(length, (index) => generateRandomColor());

  static Color generateRandomColor() {
    Random random = Random();
    double hue = random.nextDouble();
    hue += goldenRatioConjugate;
    hue %= 1.0;
    return convertHSVtoRGB(hue, 0.4, 0.99);
  }

  static Color convertHSVtoRGB(double h, double s, double v) {
    double r = 255, g = 255, b = 255, i, f, p, q, t;
    i = (h * 6).floorToDouble();
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    int remainder = (i % 6).toInt();
    switch (remainder) {
      case 0:
        r = v;
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        g = v;
        b = p;
        break;
      case 2:
        r = p;
        g = v;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        b = v;
        break;
      case 4:
        r = t;
        g = p;
        b = v;
        break;
      case 5:
        r = v;
        g = p;
        b = q;
        break;
    }
    return Color.fromRGBO(
        (r * 255).round(), (g * 255).round(), (b * 255).round(), 1);
  }
}

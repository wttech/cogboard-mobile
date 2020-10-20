import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

const MaterialColor accentColor =
    const MaterialColor(0xFF969696, const <int, Color>{
  50: Color.fromRGBO(150, 150, 150, .1),
  100: Color.fromRGBO(150, 150, 150, .2),
  200: Color.fromRGBO(150, 150, 150, .3),
  300: Color.fromRGBO(150, 150, 150, .4),
  400: Color.fromRGBO(150, 150, 150, .5),
  500: Color.fromRGBO(150, 150, 150, .6),
  600: Color.fromRGBO(150, 150, 150, .7),
  700: Color.fromRGBO(150, 150, 150, .8),
  800: Color.fromRGBO(150, 150, 150, .9),
  900: Color.fromRGBO(150, 150, 150, 1),
});

const MaterialColor primarySwatchColor =
    const MaterialColor(0xFF343539, const <int, Color>{
  50: Color.fromRGBO(12, 12, 12, .1),
  100: Color.fromRGBO(34, 35, 39, .2),
  200: Color.fromRGBO(34, 35, 39, .3),
  300: Color.fromRGBO(34, 35, 39, .4),
  400: Color.fromRGBO(34, 35, 39, .5),
  500: Color.fromRGBO(34, 35, 39, .6),
  600: Color.fromRGBO(34, 35, 39, .7),
  700: Color.fromRGBO(34, 35, 39, .8),
  800: Color.fromRGBO(34, 35, 39, .9),
  900: Color.fromRGBO(34, 35, 39, 1),
});

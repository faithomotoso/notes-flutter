import 'dart:ui';
import 'package:flutter/material.dart';

// primary colors swatch

const MaterialColor primaryColor =
    MaterialColor(0xff0097A7, // default primary color
        <int, Color>{
      50: Color(0xffE0F7FA),
      100: Color(0xffB2EBF2),
      200: Color(0xff80DEEA),
      300: Color(0x4DD0E1),
      400: Color(0xff26C6DA),
      500: Color(0xff00BCD4),
      600: Color(0xff00acc1),
      700: Color(0xff0097A7), // using this as default for legibility
      800: Color(0xff00838F),
      900: Color(0xff006064)
    });

// secondary colors
const MaterialColor secondaryColor = MaterialColor(0xffEF9A9A, // default,
    <int, Color>{
      50: Color(0xffFFEBEE),
      100: Color(0xffFFCDD2),
      200: Color(0xffEF9A9A),
      300: Color(0xffE57373),
      400: Color(0xffEF5350),
      500: Color(0xffF44336),
      600: Color(0xffE53935),
      700: Color(0xffD32F2F),
      800: Color(0xffC62828),
      900: Color(0xffB71C1C),
    });



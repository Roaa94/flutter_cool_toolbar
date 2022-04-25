import 'package:flutter/material.dart';

class Constants {
  static const double itemsGutter = 10;
  static const double toolbarHeight = 420;
  static const double toolbarWidth = 70;
  static const double itemsOffset = toolbarWidth - 10;
  static const int itemsInView = 7;
  static const double toolbarVerticalPadding = 10;
  static const double toolbarHorizontalPadding = 10;

  static const Duration longPressAnimationDuration =
      Duration(milliseconds: 400);
  static const Duration scrollScaleAnimationDuration =
      Duration(milliseconds: 700);

  static const Curve longPressAnimationCurve = Curves.easeOutSine;
  static const Curve scrollScaleAnimationCurve = Curves.ease;
}

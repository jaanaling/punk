import 'package:flutter/cupertino.dart';

double getWidth(
    BuildContext context, {
      double? percent,
      double? baseSize,
    }) {
  const baseWidth = 360;

  if (percent == null && baseSize == null) {
    throw Exception('Try adding percent or base size');
  }

  final width = percent != null
      ? MediaQuery.of(context).size.width * percent
      : ((baseSize ?? 0) / baseWidth) * MediaQuery.of(context).size.width;
  return width;
}

double getHeight(
    BuildContext context, {
      double? percent,
      double? baseSize,
    }) {
  const baseHeight = 800;

  if (percent == null && baseSize == null) {
    throw Exception('Try adding percent or base size');
  }

  final width = percent != null
      ? MediaQuery.of(context).size.height * percent
      : ((baseSize ?? 0) / baseHeight) * MediaQuery.of(context).size.height;

  return width;
}

bool isIpad (BuildContext context){
  return MediaQuery.of(context).size.shortestSide >= 600;
}
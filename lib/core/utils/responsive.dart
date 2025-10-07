import 'package:flutter/material.dart';

double sw(BuildContext context, double value) {
  double width = MediaQuery.of(context).size.width;
  if (width >= 1200) return value * 1.3;
  if (width >= 800) return value * 1.15;
  return value;
}

double sh(BuildContext context, double value) {
  double height = MediaQuery.of(context).size.height;
  if (height >= 900) return value * 1.3;
  if (height >= 600) return value * 1.1;
  return value;
}

double st(BuildContext context, double value) {
  double width = MediaQuery.of(context).size.width;
  if (width >= 1200) return value * 1.3;
  if (width >= 800) return value * 1.15;
  return value;
}

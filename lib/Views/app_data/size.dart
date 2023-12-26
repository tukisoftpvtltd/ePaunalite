import 'package:flutter/material.dart';

class AppSize extends StatelessWidget {
  final context;
  AppSize({super.key, required this.context});

  double height() => MediaQuery.of(context).size.height;
  double width() => MediaQuery.of(context).size.height;

  double large() {
    double? baseWidth = 428;
    return baseWidth;
  }

  double small() {
    double? baseWidth = 428;
    double? fem = MediaQuery.of(context).size.width / baseWidth;
    return fem;
  }

  double ex_small() {
    double? baseWidth = 428;
    double? fem = MediaQuery.of(context).size.width / baseWidth;
    double? ffem = fem * 0.97;
    return ffem;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

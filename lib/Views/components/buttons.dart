import 'package:flutter/material.dart';

import '../../Utils/colors.dart';

class CustomButton extends StatelessWidget {
  final double? size;
  final String label;
  final void Function()? onpressed;
  double height;
  double width;
  CustomButton({
    required this.onpressed,
    this.size,
    required this.label,
    this.height = 40,
    this.width = 100,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: PrimaryColors.primaryblue,
          fixedSize: Size(width, height)),
      onPressed: onpressed,
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Poppins', fontSize: size),
      ),
    );
  }
}

class AcceptDecline extends StatelessWidget {
  final void Function()? onpressed;
  final Color bgcolor;
  final String label;
  const AcceptDecline({
    required this.onpressed,
    required this.bgcolor,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor,
        ),
        child: Text(
          label,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
      ),
    );
  }
}

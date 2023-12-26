import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  final String hinttext;
  final IconData icon;
  final TextEditingController controller;
  const InputTextField({
    required this.hinttext,
    required this.icon,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: hinttext == 'Rate' ? TextInputType.number:TextInputType.name, // Set the keyboard type to number
  inputFormatters: hinttext == 'Rate' ? <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow numeric characters
      ] : null,

        decoration: InputDecoration(
          
          floatingLabelAlignment: FloatingLabelAlignment.center,
          prefixIcon: Icon(icon),
          hintText: hinttext,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
          )),
        ),
      ),
    );
  }
}

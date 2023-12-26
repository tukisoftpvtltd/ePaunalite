import 'package:flutter/material.dart';

class CustomPrompt extends StatelessWidget {
  const CustomPrompt({super.key});

  prompt(
      {dynamic context,
      required String title,
      required String message,
      Color? titleColor,
      Color? messageColor}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
            child: Text(
          title,
          style: TextStyle(color: titleColor),
        )),
        content: Text(
          message,
          style: TextStyle(color: messageColor),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: titleColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

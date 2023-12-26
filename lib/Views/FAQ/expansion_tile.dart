import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final int questionCount;
  final String questions;
  const CustomExpansionTile(
      {super.key,
      required this.title,
      required this.questionCount,
      required this.questions});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q. $questionCount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(questions)
            ],
          ),
        )
      ],
    );
  }
}

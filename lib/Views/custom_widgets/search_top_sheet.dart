// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import '../app_data/colors.dart';
//import 'search_widget.dart';

class SearchTopSheet extends StatefulWidget {
  final dynamic searchButtonIndex;
  final dynamic mainCategoryIndex;
  const SearchTopSheet(
      {super.key,
      required this.searchButtonIndex,
      required this.mainCategoryIndex});

  @override
  State<SearchTopSheet> createState() => _SearchTopSheetState();
}

class _SearchTopSheetState extends State<SearchTopSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.clear,
                color: blackColor,
              ),
            ),
            SizedBox(width: 15),
            Text("Change Your Search",
                style: TextStyle(
                    color: blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        ),
        // SearchCard(
        //   searchButtonIndex: widget.searchButtonIndex,
        // ),
      ],
    ));
  }
}

import 'package:flutter/material.dart';

import '../../Utils/colors.dart';
import 'expansion_tile.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            elevation: 0,
            backgroundColor: PrimaryColors.primarywhite,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'FAQ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            leading: BackButton(
              color: Colors.black,
            ),
            
            ),
      body: Container(
        color: Colors.white,
        child:  SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                CustomExpansionTile(
                  title: 'How To Accept User Request',
                  questionCount: 1,
                  questions:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit',
                ),
                CustomExpansionTile(
                  title: 'What You Need To Know ?',
                  questionCount: 2,
                  questions:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit',
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
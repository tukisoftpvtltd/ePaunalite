// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../app_data/colors.dart';
import '../app_data/size.dart';

class InternetLostScreen extends StatefulWidget {
  const InternetLostScreen({super.key});

  @override
  State<InternetLostScreen> createState() => _InternetLostScreenState();
}

class _InternetLostScreenState extends State<InternetLostScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSize size = AppSize(context: context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: mainColor,
        ),
        // title: Padding(
        // padding: EdgeInsets.only(top: 3, bottom: 3),
        // child: IntrinsicWidth(
        //   child: Image(
        //     height: size.large() / 10,
        //     image: AssetImage('assets/pauna1-1.png'),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        // ),
        // title: Text(
        //   "ePauna.com",
        // ),
        title: Text(
          "ePauna.com",
          style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/no_internet.png',
                fit: BoxFit.cover, height: size.large() * 0.5),
            Text(
              'No Internet Connection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Please check your internet connection',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: whiteColor,
      //   currentIndex: 0,
      //   selectedFontSize: size.ex_small() * 12,
      //   unselectedFontSize: 9 * size.ex_small(),
      //   unselectedItemColor: blackColor,
      //   selectedIconTheme: IconThemeData(fill: 0, color: mainColor),
      //   selectedLabelStyle: TextStyle(
      //       height: size.ex_small() * 0.5, fontWeight: FontWeight.bold),
      //   selectedItemColor: mainColor,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 0, size.small() * 6),
      //           child: SvgPicture.asset(
      //             "assets/NavigationIcon/search-line.svg",
      //             color: mainColor,
      //           ),
      //         ),
      //         label: 'Search'),
      //     BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 0, size.small() * 6),
      //           child: SvgPicture.asset(
      //             "assets/NavigationIcon/heart-line.svg",
      //             color: blackColor,
      //           ),
      //         ),
      //         label: 'Saved'),
      //     BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 0, size.small() * 6),
      //           child: SvgPicture.asset(
      //             "assets/NavigationIcon/briefcase-line.svg",
      //             color: blackColor,
      //           ),
      //         ),
      //         label: 'My Booking'),
      //     BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 0, size.small() * 6),
      //           child: SvgPicture.asset(
      //             "assets/NavigationIcon/profile-line.svg",
      //             color: blackColor,
      //           ),
      //         ),
      //         label: 'Profile'),
      //   ],
      //   onTap: _onItemTapped,
      // ),
    
    );
  }
}

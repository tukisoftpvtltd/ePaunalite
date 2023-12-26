import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:paunalite/Views/services/manage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../controller/internet_bloc.dart';
import '../../controller/login/bloc/login_bloc.dart';
import '../FAQ/faq.dart';
import '../Login/login.dart';
import '../Request_history/request_history.dart';
import '../profile/mainprofile.dart';

class CustomerDrawer extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  String fullname;
  String phoneno;
  String address;
  String city;
  String logo;
  CustomerDrawer({
    super.key,
    required this.scaffoldKey,
    required this.fullname,
    required this.phoneno,
    required this.address,
    required this.city,
    required this.logo,
  });

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  void _closeDrawer() {
    widget.scaffoldKey.currentState?.closeDrawer();
  }

  bool close = true;
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    Fluttertoast.showToast(
      msg: "Logged out",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[600],
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Get.offAll(() => BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocProvider(
            create: (context) => InternetBloc(),
            child: const Login(),
          ),
        ));
    // Get.offAll(BlocProvider(
    //   create: (context) => InternetBloc(),
    //   child: RequestHistory(),
    // ));
    // Get.offAll( () =>
    // BlocProvider(
    //   create: (context) => InternetBloc(),
    //   child: BlocProvider(
    //     create: (context) => LoginBloc(),
    //     child: Login(),
    //   ),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 130,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: PrimaryColors.primarywhite,
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Image.network(
                        "https://pauna.tukisoft.com.np/ServiceProviderProfile/${widget.logo}",
                        fit: BoxFit.cover,
                        )
                      // FadeInImage.assetNetwork(
                      //   placeholder: 'assets/user.png',
                      //   image: "https://pauna.tukisoft.com.np/ServiceProviderProfile/${widget.logo}",
                      //   fit: BoxFit.fill,
                      // ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: Get.width/2.4,
                      child: Text(
                        widget.fullname,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.access_time,
              color: Colors.black,
            ),
            title: const Text(
              'Request History',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {
              _closeDrawer();
              Get.to(RequestHistory());
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.person_pin,
              color: Colors.black,
            ),
            title: const Text(
              'Service Provider Info.',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {
              _closeDrawer();
              Get.to(MainProfile(
                  hotelName: widget.fullname,
                  phoneno: widget.phoneno,
                  address: widget.address,
                  city: widget.city));
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.person_pin,
              color: Colors.black,
            ),
            title: const Text(
              'Services',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {
              _closeDrawer();
              Get.to(() => const ManageService());
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.help_outline,
              color: Colors.black,
            ),
            title: const Text(
              'FAQ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {
              Get.to(const FAQ());
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.message_outlined,
              color: Colors.black,
            ),
            title: const Text(
              'Support',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {},
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text(
              'Setting',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {},
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.black,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4A4A4A)),
            ),
            onTap: () {
              logout();
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}

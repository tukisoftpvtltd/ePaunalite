// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paunalite/Views/customer_counter2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/internet_bloc.dart';
import '../../controller/login/bloc/login_bloc.dart';
import '../CRUDPage.dart';
import '../Login/login.dart';
import '../customer_counter.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  List notification;
  // String? notificationData;
  SplashScreen({super.key,required this.notification});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
    
  }
 
  

  _navigatetohome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? isLoggedIn = prefs.getString('login');
      String? hotelName = prefs.getString('hotelName');
      if(isLoggedIn == 'true' ){
        Get.offAll(BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocProvider(
          create: (context) => InternetBloc(),
          child:
          CRUDPage(
            hotelName: hotelName!,
            notification :widget.notification
          ),
        ),
      ));
      }
      else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    prefs.remove('sid');
    prefs.remove('hotelName');
    prefs.remove('phoneno');
    prefs.remove('online');
    prefs.remove('address');
    prefs.remove('city');
      OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) async{
        
    // ignore: avoid_print
    print("Accepted permission:$accepted");
    Get.offAll(BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocProvider(
          create: (context) => InternetBloc(),
          child: const Login(),
        ),
      ));
      });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: const AssetImage('assets/pauna1-1.png'),
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.width * 0.17,
        ),
      ),
    );
  }
}

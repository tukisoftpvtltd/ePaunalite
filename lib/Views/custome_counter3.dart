import 'dart:convert';
import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paunalite/Views/components/CustomeDrawer.dart';
import 'package:paunalite/controller/ServiceProviderDetail/model/ServiceProviderDetailModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/colors.dart';
import '../controller/address/address_model.dart';
import '../controller/address/address_repository.dart';
import 'app_data/colors.dart';
import 'app_data/size.dart';
import 'components/buttons.dart';
import 'components/counter.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
'high_importance_channel', // id
'High Importance Notifications', // title 
importance: Importance.high,
playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();



// ignore: must_be_immutable
class CustomerCounter3 extends StatefulWidget {
  List notification;
  String hotelName;
  CustomerCounter3({super.key,
  required this.notification,
  required this.hotelName});

  @override
  State<CustomerCounter3> createState() => _CustomerCounter3State();
}

class _CustomerCounter3State extends State<CustomerCounter3> 
    with WidgetsBindingObserver {
  bool?  isOnlineValue;
  String YourPlayerId = '';
  String senderPlayerId = '';
  List notificationIds =[];


  AcceptOffer(String customerIdValue, String rate,int index) async {
    var status = await OneSignal.shared.getDeviceState();
    String? playerId = status!.userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sidValue = prefs.getString('sid');
    print(playerId);
      var data = {
      'to' : customerIdValue,
      'priority': 'high',
      'data':{
          "requestType": "accept",
          "rate": '$rate',
          "offer1": "",
          "offer2": "",
          "offer3": "",
          "distance": "1.7km",
          "hotel_name": widget.hotelName,
          "hotel_type": "5 star Hotel",
          "hotel_desc":
              "Free Breakfast, Free Ride, Sight Seeing, Travel & Trekking",
          "sid":sidValue,
        }
      };

      await http.post (
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode (data),
        headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'key=AAAAAoAuJ1U:APA91bHzeDLiK--_kbVmT58vc_KSpP-6H97vxRSVDh3Jepo0F-M5VU4anxZQTBSVe4HTgPcSa1T-sY5ZElZEnk-v5pYYi9Z6hzRxAs3SLWP99Xj3HLQT-HyiveWodRRO4AsGA44WjOpG'
    }
    );
    deleteRequest(index);

  }
  
  List notifications = [];

  deleteRequest(index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  String title = 'loading';
  String body = 'loading';
  //String hotelName = '';
  
  ServiceProviderDetailModel? hotelData;
  String hotelName='';
  String phoneno='';
  String address='';
  String city='';
  getData()async{
 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    
  });
  String? sidValue = prefs.getString('sid');
  addressRepository repo = new addressRepository();
  ServiceProviderAddressModel model = await repo.getAddress(sidValue!);
  // setState(() {
  prefs.setString('address',model.address.toString());
  prefs.setString('city', model.city.toString());
  setState(() {
  hotelName = prefs.getString('hotelName')!;
  phoneno = prefs.getString('phoneno')!;
  address = model.address.toString();
  city = model.city.toString();
  });
  }
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
// { await Firebase.initializeApp();
// print('A bg message just showed up inside a page : ${message.messageId}');
// message.data;
// }
 final player = AudioPlayer();
 playNotification(){
  print("play sound");
  player.play(AssetSource('notification.wav'));
 }
static const notificationChannel = MethodChannel('notification');
findOnlineValue()async{
 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    print("The saved bool value is");
    print(prefs.getBool('online'));
  isOnlineValue = prefs.getBool('online')??true;
  print("the is online value is");
  print(isOnlineValue);
  });
}
List messageIds = [];
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getData();
    print("the widget notification is");
    print(widget.notification);
    notifications = widget.notification;
    findOnlineValue();
   FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    //  await notificationChannel.invokeMethod('getNotification');
    //  await LaunchApp.openApp(androidPackageName: "com.example.pauna");
      RemoteNotification?  notification = message.notification;
      print(notification?.title);
      print("The is online value");
    print( isOnlineValue);
      if( isOnlineValue == true){
        playNotification();
      setState(() {
      //   print("The message id length is");
      //   print(messageIds.length);
      //   for(int i =0;i<=messageIds.length ;i++){
      //   //   print("I am here");
      //   //   print(message.messageId);
      //   //   print(messageIds[i].toString());
      //     // if(message.messageId.toString() != messageIds[i].toString()){
        notifications.add(message.data);
      //   // print("The message id is");
      //   // messageIds.add(message.messageId);
      // // }
      //  }
        
        });
      }
      print(notifications);
     });
  }

  getUserPlayerId() async {
    var status = await OneSignal.shared.getDeviceState();
    String? playerId = status!.userId;
    setState(() {
      YourPlayerId = playerId!;
    });
    
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    AppSize size = AppSize(context: context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: PrimaryColors.backgroundcolor,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: PrimaryColors.primarywhite,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            leading: null,
            actions: [
              GestureDetector(
                onTap: () async{
                 //  await notificationChannel.invokeMethod('getNotification');
                  _openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                      height: 25,
                      width: 25,
                      child: Image.asset("assets/filter.png")),
                ),
              ),
            ]),
        body:  ListView(
          shrinkWrap: true,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: PrimaryColors.backgroundcolor,
                        height: 3,
                      ),
                      Container(
                        color: PrimaryColors.primarywhite,
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                               isOnlineValue == null ?Container():
                               Padding(
                                 padding: const EdgeInsets.fromLTRB(20,0,0,0),
                                 child: LiteRollingSwitch(
                                         value: isOnlineValue!,
                                       textOn: "Online",
                                       textOff: "Offline",
                                       colorOn: PrimaryColors.primarygreen,
                                       colorOff: Colors.red,
                                       iconOn: Icons. done,
                                       iconOff: Icons.code_off_rounded,
                                       textSize: 16.0,
                                       textOnColor: Colors.white,
                                       onChanged: (bool position)async {
                                       print("The button is $position");
                                       setState(() {
                                         isOnlineValue = position;
                                       });
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                       await prefs.setBool('online', position);
                                       
                                       }, onDoubleTap: (){}, onSwipe: (){}, onTap: (){},
                                       ),
                               ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    widget.hotelName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: PrimaryColors.primaryblue,
                                      fontSize: 15 * size.ex_small(),
                                      fontWeight: FontWeight.w500,
                                      height: 1.5 * size.ex_small() / size.small(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 10,
                      ),
                      Container(
                        color: PrimaryColors.backgroundcolor,
                        height: 3,
                      ),
                      Container(
                        color: Colors.white,
                        height: 10,
                      ),
                     notifications.length == 0
                ? Container(
                        height: 400,
                        color: PrimaryColors.primarywhite,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 300,
                                  width: width,
                                  child: Image.asset('assets/images/no_booking.png'),
                                ),
                                Text(
                                  'No Bookings yet',
                                  style: TextStyle(
                                    fontSize: size.large() / 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5 * size.small() / size.small(),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ):
                          SingleChildScrollView(
                            child: Container(
                              height: height-200,
                              child: ListView.builder(
                                itemCount: notifications.length,
                                shrinkWrap: true,
                                
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.20,
                                    margin: const EdgeInsets.all(10),
                                    color: PrimaryColors.primarywhite,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.white,
                                      // width: 600,
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            // Text("Player Id is"),
                                            // SelectableText(YourPlayerId),
                                            Expanded(
                                              flex: 3,
                                              child: CounterOffer(
                                                callback:deleteRequest,
                                                indexValue : index,
                                                label: notifications[index]['name']
                                                        ?.toString() ??
                                                    'N/A',
                                                image: 'assets/images/profile.jpg',
                                                amount: notifications[index]['rate']
                                                        ?.toString() ??
                                                    'N/A',
                                                Checked_in: notifications[index]['startDate']
                                                        ?.toString() ??
                                                    'N/A',
                                                Checked_out: notifications[index]['endDate']
                                                        ?.toString() ??
                                                    'N/A',
                                                roomquantity: notifications[index]['bedQuantity']
                                                        ?.toString() ??
                                                    'N/A',
                                                noofguest: notifications[index]['personCount']
                                                        ?.toString() ??
                                                    'N/A',
                                                distance: notifications[index]['distance']
                                                        ?.toString() ??
                                                    'N/A',
                                                customerPlayerId: notifications[index]['customerPlayerId']
                                                        ?.toString() ??
                                                    'N/A',
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  MediaQuery.of(context).size.height * 0.01,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AcceptDecline(
                                                      onpressed: () {
                                                        deleteRequest(index);
                                                      },
                                                      bgcolor: PrimaryColors.primaryred,
                                                      label: 'Decline',
                                                    ),
                                                    const SizedBox(width: 10),
                                                    AcceptDecline(
                                                      onpressed: () {
                                                        String customerId =
                                                            notifications[index][
                                                                        'customerPlayerId']
                                                                    ?.toString() ??
                                                                'N/A';
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return CounterDialogBox(
                                                              description: '',
                                                              indexValue:index,
                                                              callback: deleteRequest,
                                                                CustomerId: customerId);
                                                          },
                                                        );
                                                      },
                                                      bgcolor: PrimaryColors.primaryblue,
                                                      label: 'Counter',
                                                    ),
                                                    const SizedBox(width: 10),
                                                    AcceptDecline(
                                                      onpressed: () {
                                                        String customerId =
                                                            notifications[index][
                                                                        'customerPlayerId']
                                                                    ?.toString() ??
                                                                'N/A';
                                                        String rateValue =
                                                            notifications[index]
                                                                    ['rate']
                                                                    ?.toString() ??
                                                                'N/A';
                                                        AcceptOffer(customerId, rateValue,index);
                                                      },
                                                      bgcolor: PrimaryColors.primarygreen,
                                                      label: 'Accept',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
            
                    ],
                  ),
          ],
        ),
        drawer: CustomerDrawer(
  // String hotelName='';
  // String phoneno='';
  // String address='';
  // String city='';
          scaffoldKey: _scaffoldKey,
          fullname:hotelName,
          phoneno:phoneno,
          address:address,
          city:city,
          logo:''

        )),
    );
  }
}



class CounterOffer extends StatefulWidget {
  Function callback;
  final int indexValue;
  final String label;
  final String image;
  final String amount;
  final String Checked_in;
  final String Checked_out;
  final String? roomquantity;
  final String? noofguest;
  final String? distance;
  final String? customerPlayerId;

   CounterOffer(
      {required this.callback,
        required this.indexValue,
        required this.label,
      required this.image,
      required this.amount,
      required this.Checked_in,
      required this.Checked_out,
      this.roomquantity,
      this.noofguest,
      this.customerPlayerId,
      super.key,
      this.distance});

  @override
  State<CounterOffer> createState() => _CounterOfferState();
}

class _CounterOfferState extends State<CounterOffer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(() {
      if(controller.value ==0.0){
        widget.callback(widget.indexValue);
      }
        setState(() {});
      });
    controller.reverse(from: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Image.asset(widget.image),
        ),
        // ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    
                    Text(
                      "Rs." + widget.amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: PrimaryColors.primaryblue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Checked In:  ${widget.Checked_in.toString().split(' ')[0]}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey.shade500),
                        ),
                        Text('${widget.distance} ',
                            style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.green))
                      ],
                    ),
                    Text(
                      'Checked Out:  ${widget.Checked_out.toString().split(' ')[0]}',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    Text(
                      'Room Quantity: ${widget.roomquantity} ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    Text(
                      'No of Guest: ${widget.noofguest} ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    // SelectableText(
                    //   'Customer Player Id: ${widget.customerPlayerId} ',
                    //   style: TextStyle(
                    //       fontFamily: 'Poppins',
                    //       fontSize: 12,
                    //       color: Colors.grey.shade500),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// class ToggleButton extends StatefulWidget {
//   @override
//   _ToggleButtonState createState() => _ToggleButtonState();
// }

// class _ToggleButtonState extends State<ToggleButton> {
//   bool isOnline = true;

//   void toggleOnlineOffline() {
//     setState(() {
//       isOnline = !isOnline;
//     });
//   }
//   bool isSwitched = true;
//   @override
//   Widget build(BuildContext context) {
//     Color buttonColor = isOnline ? Colors.green : Colors.red;
//     String buttonText = isOnline ? "Online" : "Offline";
    
//     return  Padding(
//       padding: const EdgeInsets.fromLTRB(30,0,0,0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           LiteRollingSwitch(
//           value: isOnlineValue!,
//         textOn: "Online",
//         textOff: "Offline",
//         colorOn: PrimaryColors.primarygreen,
//         colorOff: Colors.red,
//         iconOn: Icons. done,
//         iconOff: Icons.code_off_rounded,
//         textSize: 16.0,
//         textOnColor: Colors.white,
//         onChanged: (bool position)async {
//         print("The button is $position");
//         setState(() {
//           isOnlineValue = position;
//         });
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('online', position);
        
//         }, onDoubleTap: (){}, onSwipe: (){}, onTap: (){},
//         ),
         
//         ],
//       ),
//     );
    
//   }
// }
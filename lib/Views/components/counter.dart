import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/colors.dart';
import 'inputfields.dart';

// ignore: must_be_immutable
class CounterDialogBox extends StatefulWidget {
  int indexValue;
  Function callback;
  String CustomerId;
  String? logo;
  String description;
  CounterDialogBox({super.key,
  required this.indexValue,
  required this.callback,
  required this.CustomerId,
   required this.description,
  this.logo});

  @override
  State<CounterDialogBox> createState() => _CounterDialogBoxState();
}

class _CounterDialogBoxState extends State<CounterDialogBox> {
  void sendNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
   String? hotelName = prefs.getString('hotelName');
  //  String? hotelDesc = prefs.getString("Description");
       String? sidValue = prefs.getString('sid');
  var status = await OneSignal.shared.getDeviceState();
  String? playerId = status!.userId;
  print(playerId);
  // var notification = OSCreateNotification(
  //   playerIds: [widget.CustomerId!],
  //   content: "Counter offer at rate: ${rate.text}",
  //   heading: "Hotel Puspa",
  //   additionalData: {
  //     "requestType":"counter",
  //     "offer1":"${offer1.text}",
  //     "offer2":"${offer2.text}",
  //     "offer3":"${offer3.text}",
  //     "rate":int.parse(rate.text),
  //     "distance":"1.7km",
  //     "hotel_name":hotelName,
  //     "hotel_type":"3 star Hotel",
  //     "hotel_desc":"Free Breakfast, Free Ride, Sight Seeing, Travel & Trekking",
  //     "sid":sidValue,

  //   } 
  // );
  // await OneSignal.shared.postNotification(notification);
      var data = {
      'to' : widget.CustomerId,
      'priority': 'high',
      'data':{
      "requestType":"counter",
      "offer1":"${offer1.text}",
      "offer2":"${offer2.text}",
      "offer3":"${offer3.text}",
      "rate":'${rate.text}',
      "distance":"1.7km",
      "hotel_name":hotelName,
      "hotel_type":"3 star Hotel",
      "hotel_desc":widget.description,
      "sid":sidValue,
      "logo":widget.logo,
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
  widget.callback(widget.indexValue);
}

  void initState(){
    super.initState();
    
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
     
    });
  }
  TextEditingController rate = new TextEditingController();
  TextEditingController offer1 = new TextEditingController();
  TextEditingController offer2 = new TextEditingController();
  TextEditingController offer3 = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
     return StatefulBuilder(builder: (context, setState) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: PrimaryColors.primarywhite,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 450,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Counter rate :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.dangerous_rounded,
                      size: 35,
                      color: PrimaryColors.primaryblue,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InputTextField(
              controller: rate, hinttext: 'Rate', icon: Icons.attach_money),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Offers :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            InputTextField(controller: offer1, hinttext: 'offer 1', icon: Icons.clean_hands),
            const SizedBox(height: 10),
            InputTextField(controller: offer2,hinttext: 'offer 2', icon: Icons.clean_hands),
            const SizedBox(height: 10),
            InputTextField (controller: offer3,hinttext: 'offer 3', icon: Icons.clean_hands),
            const SizedBox(height: 10),
            Container(
              height: 35,
              margin: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrimaryColors.primaryblue,
                  alignment: Alignment.centerRight,
                ),
                onPressed: () {
                  sendNotification();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
     });
     }
}

// ignore: must_be_immutable
class OfferDialogBox extends StatefulWidget {
  int indexValue;
  Function callback;
  String CustomerId;
  String? logo;
  String? description;
  OfferDialogBox({super.key,
  required this.indexValue,
  required this.callback,
  required this.CustomerId,
  this.description,
  this.logo});

  @override
  State<OfferDialogBox> createState() => _OfferDialogBoxState();
}

class _OfferDialogBoxState extends State<OfferDialogBox> {
  void sendNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
   String? hotelName = prefs.getString('hotelName');
  //  String? hotelDesc = prefs.getString('Description');
       String? sidValue = prefs.getString('sid');
  // var status = await OneSignal.shared.getDeviceState();
  // String? playerId = status!.userId;
  // print(playerId);
      var data = {
      'to' : widget.CustomerId,
      'priority': 'high',
      'data':{
      "requestType":"offer",
      "offer1":"${offer1.text}",
      "offer2":"${offer2.text}",
      "offer3":"${offer3.text}",
      "rate":'${rate.text}',
      "distance":"1.7km",
      "hotel_name":hotelName,
      "hotel_type":"3 star Hotel",
      "hotel_desc":widget.description,
      "sid":sidValue,
      "logo":widget.logo,

    } 
      };
      
    print(data);

      await http.post (
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode (data),
        headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'key=AAAAAoAuJ1U:APA91bHzeDLiK--_kbVmT58vc_KSpP-6H97vxRSVDh3Jepo0F-M5VU4anxZQTBSVe4HTgPcSa1T-sY5ZElZEnk-v5pYYi9Z6hzRxAs3SLWP99Xj3HLQT-HyiveWodRRO4AsGA44WjOpG'
    }
    );
  widget.callback(widget.indexValue);
}

  void initState(){
    super.initState();
    
    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
     
    // });
  }
  TextEditingController rate = new TextEditingController();
  TextEditingController offer1 = new TextEditingController();
  TextEditingController offer2 = new TextEditingController();
  TextEditingController offer3 = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
     return StatefulBuilder(builder: (context, setState) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: PrimaryColors.primarywhite,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 200,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Offer rate :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.dangerous_rounded,
                      size: 35,
                      color: PrimaryColors.primaryblue,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InputTextField(
              controller: rate, hinttext: 'Rate', icon: Icons.attach_money),
            const SizedBox(height: 10),
           
            Container(
              height: 35,
              margin: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrimaryColors.primaryblue,
                  alignment: Alignment.centerRight,
                ),
                onPressed: () {
                  sendNotification();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
     });
     }
}

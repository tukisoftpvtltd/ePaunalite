// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Utils/colors.dart';
import 'components/buttons.dart';
import 'components/counter.dart';

class CustomerCounter extends StatefulWidget {
   CustomerCounter({super.key});

  @override
  State<CustomerCounter> createState() => _CustomerCounterState();
}

class _CustomerCounterState extends State<CustomerCounter> {
  String YourPlayerId ='';

  DeclineOffer()async{
    var status = await OneSignal.shared.getDeviceState();
  String? playerId = status!.userId;
  print(playerId);
  var notification = OSCreateNotification(
    contentAvailable: false,
    playerIds: [playerId!],
    content: "The offer rate was declined",
    heading: "Offered Rate:50000",
  );
  await OneSignal.shared.postNotification(notification);
  }

  AcceptOffer()async{
        var status = await OneSignal.shared.getDeviceState();
  String? playerId = status!.userId;
  print(playerId);
  var notification = OSCreateNotification(
     contentAvailable: false,
    playerIds: [
      playerId!
    ],
    content: "The offer rate was accepted",
    heading: "Offered Rate:50000",
  );
  await OneSignal.shared.postNotification(notification);
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPlayerId();
  }
  getUserPlayerId()async{
    var status = await OneSignal.shared.getDeviceState();
  String? playerId = status!.userId;
  setState(() {
    YourPlayerId = playerId!;
  });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: PrimaryColors.backgroundcolor,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: PrimaryColors.primarywhite,
            title: const Text(
              'Counter Offer',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: const EdgeInsets.all(10),
            color: PrimaryColors.primarywhite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                      Text("Player Id is"),
                      SelectableText(YourPlayerId),
                  Expanded(
                    flex: 3,
                    child: CounterOffer(
                      label: 'Pawan Sigdel',
                      image: 'assets/images/profile.jpg',
                      amount: '4,000',
                      Checked_in: DateTime.now(),
                      Checked_out: DateTime.now(),
                      roomquantity: '1',
                      noofguest: '2',
                      distance: 1.2,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AcceptDecline(
                            onpressed: () {
                              DeclineOffer();
                            },
                            bgcolor: PrimaryColors.primaryred,
                            label: 'Decline',
                          ),
                          const SizedBox(width: 10),
                          AcceptDecline(
                            onpressed: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return CounterDialogBox();
                              //   },
                              // );
                            },
                            bgcolor: PrimaryColors.primaryblue,
                            label: 'Counter',
                          ),
                          const SizedBox(width: 10),
                          AcceptDecline(
                            onpressed: () {
                              AcceptOffer();
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
        ),
      ),
    );
  }
}

class CounterOffer extends StatelessWidget {
  final String label;
  final String image;
  final String amount;
  // ignore: non_constant_identifier_names
  final DateTime Checked_in;
  final DateTime Checked_out;
  final String? roomquantity;
  final String? noofguest;
  final double? distance;

  const CounterOffer(
      {required this.label,
      required this.image,
      required this.amount,
      required this.Checked_in,
      required this.Checked_out,
      this.roomquantity,
      this.noofguest,
      super.key,
      this.distance});

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
          child: Image.asset(image),
        ),
        // ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      amount,
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
                          'Checked In:  ${Checked_in.toString().split(' ')[0]}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey.shade500),
                        ),
                        Text('$distance Km',
                            style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.green))
                      ],
                    ),
                    Text(
                      'Checked Out:  ${Checked_out.toString().split(' ')[0]}',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    Text(
                      'Room Quantity: $roomquantity ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    Text(
                      'No of Guest: $noofguest ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
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

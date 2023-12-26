import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:paunalite/controller/ProfilePic/serviceProviderProfileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart'as sql;
import '../Utils/colors.dart';
import '../controller/ProfilePic/ProfileRepository.dart';
import '../controller/address/address_model.dart';
import '../controller/address/address_repository.dart';
import 'app_data/colors.dart';
import 'app_data/size.dart';
import 'components/CustomeDrawer.dart';
import 'components/buttons.dart';
import 'components/counter.dart';
import 'package:http/http.dart' as http;
late ScrollController _scrollController;
bool scrollabel = true;
int count = 0;
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
CREATE TABLE IF NOT EXISTS notifications(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    distance TEXT,
    category TEXT,
    noOfBed TEXT,
    startRange TEXT,
    endRange TEXT,
    location TEXT,
    rate TEXT,
    bedQuantity TEXT,
    startDate TEXT,
    endDate TEXT,
    personCount TEXT,
    note TEXT,
    customerPlayerId TEXT,
    hourlyBargain TEXT,
    hours TEXT,
    pickUpLocation TEXT,
    pickUpLat TEXT,
    pickUpLong TEXT,
    pickUpPrice TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)""");
  }
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
    String name,
     String? fixedDistance,
     String category,
     String noOfBed,
     String startRange,
     String endRange,
     String location,
     String rate,
     String bedQuantity,
     String startDate,
     String endDate,
     String personCount,
     String note,
     String token,
     String hourlyBargain,
     String hours,
     String pickUpLocation,
     String pickUpLat,
     String pickUpLong,
     String pickUpPrice
     )async {
      
    final db = await SQLHelper.db();
    final data ={
        "name":"$name",
        "distance": fixedDistance.toString(),
        "category":category!,
        "noOfBed":noOfBed!,
        "startRange":startRange.toString(),
        "endRange": endRange.toString(),
        "location":location.toString(),
        "rate":rate.toString(),
        "bedQuantity":bedQuantity.toString(),
        "startDate":startDate.toString(),
        "endDate":endDate.toString(),
        "personCount":personCount.toString(),
        "note":note.toString(),
        "customerPlayerId":token.toString(),
        "hourlyBargain":hourlyBargain,
        "hours":hours,
        "pickUpLocation":pickUpLocation,
        "pickUpLat":pickUpLat,
        "pickUpLong":pickUpLong,
        "pickUpPrice":pickUpPrice,
      };
    final id = await db.insert('notifications', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
        if(count >=2){
          scrollListToTop();
        }
        count ++;
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> result = await db.query('notifications');
    count = result.length-1;
  // if(count !=0){
  //   scrollListToTop();
  // }
  return db.query('notifications', orderBy: "id");
   
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('notifications', where: "id = ?", whereArgs: [id], limit: 1);
  }


  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('notifications', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

// ignore: must_be_immutable
class CRUDPage extends StatefulWidget  {
  List notification;
  String hotelName;
  CRUDPage({super.key,
  required this.notification,
  required this.hotelName});
  // const CRUDPage({Key? key}) : super(key: key);

  @override
  _CRUDPageState createState() => _CRUDPageState();
}

class _CRUDPageState extends State<CRUDPage> with TickerProviderStateMixin,WidgetsBindingObserver {
  bool?  isOnlineValue;
  String YourPlayerId = '';
  String senderPlayerId = '';
  List notificationIds =[];


  AcceptOffer(String customerIdValue, String rate,int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sidValue = prefs.getString('sid');
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
          "hotel_name": hotelName,
          "hotel_type": "5 star Hotel",
          "hotel_desc":
              hotelDesc,
          "sid":sidValue,
          "logo":"https://pauna.tukisoft.com.np/ServiceProviderProfile/$ServiceProviderLogo"
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
  callback(index);
   _refreshJournals();
  }
  
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
  List<Map<String, dynamic>> notifications = [];

  bool _isLoading = true;

  void _refreshJournals() async {
  
    final data = await SQLHelper.getItems();
    try{
      setState(() {
      notifications= data;
      _isLoading = false;
    });
    }
    catch(e){
      print(e.toString());
    }
    
  }
  final player = AudioPlayer();
 playNotification(){
  print("play sound");
  player.play(AssetSource('notification.wav'));
 }
  void _scrollListener() {
  if (_scrollController.position.userScrollDirection == ScrollDirection.forward || _scrollController.position.userScrollDirection == ScrollDirection.reverse ) {
    scrollabel = false;
    print("Scrolling ");
  } else{
    print("not scrolling");
    scrollabel =true;
  }
}
  String ServiceProviderLogo ='';
  getServiceProviderProfile()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');
    ServiceProviderProfileRepository repo  = ServiceProviderProfileRepository();
    ServiceProviderProfile data = await repo.getServiceProvideProfile(sid!);
    ServiceProviderLogo = data.logo!;
  }
  @override
  void initState() {
    super.initState();
    getServiceProviderProfile();
    WidgetsBinding.instance!.addObserver(this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    findOnlineValue();
    getData();
  
    
     FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
   if(isOnlineValue == true){
     List currentNotifications = [];
     currentNotifications.add(message.data);
     print(message.data);
     playNotification();
      _addItem(
         currentNotifications[0]['name']?.toString() ??'N/A',
         currentNotifications[0]["distance"]?.toString() ??'N/A',
         currentNotifications[0]["category"]?.toString() ??'N/A',
         currentNotifications[0]["noOfBed"]?.toString() ??'N/A',
         currentNotifications[0]["startRange"]?.toString() ??'N/A',
         currentNotifications[0]["endRange"]?.toString() ??'N/A',
         currentNotifications[0]["location"]?.toString() ??'N/A',
         currentNotifications[0]['rate']?.toString() ??'N/A',
         currentNotifications[0]["bedQuantity"]?.toString() ??'N/A',
         currentNotifications[0]["startDate"]?.toString() ??'N/A',
         currentNotifications[0]["endDate"]?.toString() ??'N/A',
         currentNotifications[0]["personCount"]?.toString() ??'N/A',
         currentNotifications[0]["note"]?.toString() ??'N/A',
         currentNotifications[0]["customerPlayerId"]?.toString() ??'N/A',
         currentNotifications[0]["hourlyBargain"]?.toString() ??'N/A',
          currentNotifications[0]["hours"]?.toString() ??'N/A',
          currentNotifications[0]["pickUpLocation"]?.toString() ??'N/A',
          currentNotifications[0]["pickUpLat"]?.toString() ??'N/A',
          currentNotifications[0]["pickUpLong"]?.toString() ??'N/A',
          currentNotifications[0]["pickUpPrice"]?.toString() ??'N/A',
      );
   }
     });
    
    _refreshJournals(); // Loading the diary when the app starts
  }

  @override
  void dispose() {
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // This method is called when the app's lifecycle state changes
    if (state == AppLifecycleState.resumed) {
      setState(() {
         _refreshJournals();
      });
     
      print('App is in the foreground');
    } else if (state == AppLifecycleState.paused) {
      // The app is in the background
      print('App is in the background');
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


// Insert a new journal to the database
  Future<void> _addItem(
  String name,
  String? fixedDistance,
  String category,
  String noOfBed,
  String startRange,
  String endRange,
  String location,
  String rate,
  String bedQuantity,
  String startDate,
  String endDate,
  String personCount,
  String note,
  String token,
   String hourlyBargain,
     String hours,
     String pickUpLocation,
     String pickUpLat,
     String pickUpLong,
     String pickUpPrice
  
    ) async {
      
    await SQLHelper.createItem(
        name, fixedDistance,category,
        noOfBed,startRange,endRange,
        location,rate,bedQuantity,startDate,
        endDate,personCount,note,token,
        hourlyBargain,hours,pickUpLocation,
        pickUpLat,pickUpLong,pickUpPrice);
    
    _refreshJournals();
  }
   void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    print('Successfully deleted a journal!');
    _refreshJournals();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }
  callback(int index){
    _deleteItem(notifications[index]['id']);
  }
  String hotelName='';
  String phoneno='';
  String address='';
  String city='';
  String hotelDesc ='';
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
  hotelDesc = model.description.toString();
  });
  }
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
     AppSize size = AppSize(context: context);
    return Scaffold(
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
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
            shrinkWrap: true,
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
                                        setState(() {
                                         isOnlineValue = position;
                                       });
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
                 height:notifications.length <= 3  ? notifications.length *Get.height*0.25 : Get.height-200,
                              
                  child: NotificationListener<ScrollNotification>(
                       onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              // User has finished scrolling
              print('Scrolling ended');
              setState(() {
                scrollabel = true;
              });
            }
            return false;
          }, child: ListView.builder(
                       addAutomaticKeepAlives: true,
                          controller: _scrollController,
                          reverse: true,
                          itemCount: notifications.length,
                          itemBuilder: (context, index){
                    return 
                    notifications[index]['hourlyBargain']?.toString() == "true" ?
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.23,
                          margin: const EdgeInsets.all(10),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    color:Colors.white,
                                                    height: 200,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child:
                                                            CounterOffer2(
                                                              callback:callback,
                                                              indexValue : index,
                                                              label: notifications[index]['name']
                                                                      ?.toString() ??
                                                                  'N/A',
                                                              image: 'assets/images/profile.jpg',
                                                              category:notifications[index]['category']
                                                                      ?.toString() ??
                                                                  'N/A',
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
                                                              hourlyBargain:notifications[index]['hourlyBargain']?.toString(),
                                                             
                                                              hours: notifications[index]['hours']?.toString(),
                                                              
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
                                                                      _deleteItem(notifications[index]['id']);                                              // deleteRequest(index);
                                                                    },
                                                                    bgcolor: PrimaryColors.primaryred,
                                                                    label: 'Decline',
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                
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
                                                                          return OfferDialogBox(
                                                                            indexValue:index,
                                                                            callback: callback,
                                                                              CustomerId: customerId,
                                                                              logo:"https://pauna.tukisoft.com.np/ServiceProviderProfile/$ServiceProviderLogo",
                                                                              description:hotelDesc);
                                                                     
                                                                    },
                                                                      );
                                                                    },
                                                                    bgcolor: PrimaryColors.primarygreen,
                                                                    label: 'Offer',
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(250,45,0,0),
                        child: Container(
                          width: 150,
                          height: 30,
                          child: Image.asset('assets/hourly_booking.png')),
                      ),
                      ],
                    )
                    :
                   
                        Container(
                          height: MediaQuery.of(context).size.height * 0.23,
                                                  margin: const EdgeInsets.all(10),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    color:Colors.white,
                                                    height: 200,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child:
                                                            CounterOffer(
                                                              callback:callback,
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
                                                              hourlyBargain:notifications[index]['hourlyBargain']?.toString(),
                                                             
                                                              hours: notifications[index]['hours']?.toString()??'N/A',
                                                              notes: notifications[index]['note']?.toString()??'N/A',
                                                            pickUpLocation:notifications[index]['pickUpLocation']?.toString()??'N/A',
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
                                                                      _deleteItem(notifications[index]['id']);                                              // deleteRequest(index);
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
                                                                            indexValue:index,
                                                                            callback: callback,
                                                                              CustomerId: customerId,
                                                                              logo:"https://pauna.tukisoft.com.np/ServiceProviderProfile/$ServiceProviderLogo",
                                                                              description:hotelDesc,
                                                                              );
                                                                     
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
                      
                          }
                        ),
                  ),
                ),
              ),
            ],
          ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.arrow_upward),
      //   onPressed: () {
      //   scrollListToTop();
      //   }
      //   // _showForm(null,context),
      // ),
      drawer: CustomerDrawer(
          scaffoldKey: _scaffoldKey,
          fullname:hotelName,
          phoneno:phoneno,
          address:address,
          city:city,
          logo:ServiceProviderLogo,
          //"https://pauna.tukisoft.com.np/ServiceProviderProfile/3BqroNLdp8GTIT80EHk1202303027266.jpeg"
        ),
      
    );
  }
}

scrollListToTop(){
  try{
     print("scroll called");
     scrollabel ?
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent+200, // Scroll to the top (position 0)
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    ):(){};
  }
  catch(e){
    print(e.toString());
  }
 
}


// ignore: must_be_immutable
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
  final String? hourlyBargain;
  final String? hours;
  final String? notes;
  final String? pickUpLocation;


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
      this.hourlyBargain,
      super.key,
      this.distance,
      this.hours,
      this.notes,
      this.pickUpLocation});

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
                    
                   widget.hourlyBargain == "true"? Container() :Text(
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
                       widget.hourlyBargain == "true" ?
                       Text("${widget.hours.toString()} Hours",
                       style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),): Text(
                          'Check In :  ${widget.Checked_in.toString().split(' ')[0]}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey.shade500),
                        ),
                        widget.hourlyBargain == "true"?
                    Container():
                        Text('${widget.distance} ',
                            style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.green))
                      ],
                    ),
                    widget.hourlyBargain == "true" ?
                    Container():
                    Text(
                      'Check Out :  ${widget.Checked_out.toString().split(' ')[0]}',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    Text(
                      'Room Quantity : ${widget.roomquantity} ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    Text(
                      'No of Guest : ${widget.noofguest} ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ),
                    widget.notes != ""? Text(
                      'Note : ${obscurePhoneNumbers(widget.notes.toString())} ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),
                    ):Container(),
                    widget.pickUpLocation != ''? SelectableText(
                      'Pick up location: ${widget.pickUpLocation} ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.blue),
                    ):Container(),
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
String obscurePhoneNumbers(String text) {
  final phoneRegex = RegExp(r'\b\d{10}\b');
  // Replace phone numbers with asterisks
  return text.replaceAllMapped(phoneRegex, (match) {
    final phoneNumber = match.group(0); // Get the matched phone number
    return '*' * phoneNumber!.length; // Replace with asterisks of the same length
  });
}
class CounterOffer2 extends StatefulWidget {
  Function callback;
  final int indexValue;
  final String label;
  final String image;
  final String category;
  final String amount;
  final String Checked_in;
  final String Checked_out;
  final String? roomquantity;
  final String? noofguest;
  final String? distance;
  final String? customerPlayerId;
  final String? hourlyBargain;
  final String? hours;
  final String? pickUpLocation;

   CounterOffer2(
      {required this.callback,
        required this.indexValue,
        required this.label,
      required this.image,
      required this.category,
      required this.amount,
      required this.Checked_in,
      required this.Checked_out,
      this.roomquantity,
      this.noofguest,
      this.customerPlayerId,
      this.hourlyBargain,
      super.key,
      this.distance,
      this.hours,
      this.pickUpLocation});

  @override
  State<CounterOffer2> createState() => _CounterOffer2State();
}

class _CounterOffer2State extends State<CounterOffer2>
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
              SizedBox(height: 10,),
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
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       widget.hourlyBargain == "true" ?
                       Text("Hours: ${widget.hours.toString()}",
                       style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500),): Text(
                          'Check In:  ${widget.Checked_in.toString().split(' ')[0]}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey.shade500),
                        ),
                        widget.hourlyBargain == "true"?
                    Container():
                        Text('${widget.distance} ',
                            style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.green,fontSize: 12))
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Room Quantity: ${widget.roomquantity} ',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey.shade500),
                        ),
                        Text(
                          '${widget.distance} ',
                           style: const TextStyle(
                                fontFamily: 'Poppins', color: Colors.green,fontSize: 12)),
                        
                      ],
                    ),
                    Text(
                      'Category: ${widget.category} ',
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

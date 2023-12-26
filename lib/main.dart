import 'package:android_intent_plus/android_intent.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paunalite/Views/splash.dart/splash.dart';
import 'package:paunalite/controller/manage_service/bloc/manage_service_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/internet_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:sqflite/sqflite.dart'as sql;

String notificationData='Hello';
List notifications =[];
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
 const notificationChannel = MethodChannel("notification");
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
)
    """);
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
    //  hours TEXT,
    // pickUpLocation TEXT,
    // pickUpLat TEXT,
    // pickUpLong TEXT,
    // pickUpPrice TEXT,
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
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
  return db.query('notifications', orderBy: "id DESC");
   
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('notifications', where: "id = ?", whereArgs: [id], limit: 1);
  }
}
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
  }
//    findOnlineValue()async{
 
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   setState(() {
//     print("The saved bool value is");
//     print(prefs.getBool('online'));
//   isOnlineValue = prefs.getBool('online')??true;
//   print("the is online value is");
//   print(isOnlineValue);
//   });
// }
 Future<void> backgroundHandler(RemoteMessage message) async {
  print("Background running");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isOnlineValue = prefs.getBool('online')??true;
  print("The online value is $isOnlineValue");
  if(isOnlineValue == true){
     List currentNotifications = [];
   currentNotifications.add(message.data);
     playNotification();
     print(currentNotifications);
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
    // print("bye");  
}

Future<void> main() async{
 
  

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // String? token = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // print("the token is"+ token.toString());
  // print(token);
    String token ='';
  await FirebaseMessaging.instance.requestPermission().then((value) {
            FirebaseMessaging.instance.getToken().then((value) {
              print('Token $value');
              token = value.toString();
            });
          });
  print("The token value is"+token.toString());
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("35bb0d4c-a9e5-454d-a850-d994ec27d094");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission:$accepted");
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}
  final player = AudioPlayer();
 playNotification(){
  print("play sound");
  player.play(AssetSource('notification.wav'));
 }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ManageServiceBloc>(
          create: (context) => ManageServiceBloc(),
        ),
      ],
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: BlocProvider(
              create: (context) => InternetBloc(),
              child: SplashScreen(notification: [],)
             // SplashScreen(notification: notifications)
              )),
    );
  }
}

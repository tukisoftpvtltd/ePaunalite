import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    // Add a notification event listener
     OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Handle the opened notification
      print("Opened Notification: ${result.notification.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OneSignal Notification List'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]['title'] ?? ''),
            subtitle: Text(notifications[index]['body'] ?? ''),
          );
        },
      ),
    );
  }
}
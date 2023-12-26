// // package your.package.name

// // import com.onesignal.NotificationExtenderService
// // import com.onesignal.OSNotificationReceivedResult

// // class CustomNotificationExtender : NotificationExtenderService() {
// //   protected override fun onNotificationProcessing(receivedResult: OSNotificationReceivedResult): Boolean {
// //     return false
// //   }
// // }
// package com.example.paunalite
// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler
// import android.content.Context
// import com.onesignal.OSNotificationReceivedEvent
// import android.os.Bundle
// import io.flutter.plugins.GeneratedPluginRegistrant
// import com.onesignal.OSNotification
// import com.onesignal.OneSignal
// import android.util.Log

// public class NotificationServiceExtension : OSRemoteNotificationReceivedHandler {
//     init {
//       println("testValue")
//     }
//     override fun remoteNotificationReceived(context: Context, 
//     notificationReceivedEvent: OSNotificationReceivedEvent) {
//       channel?.invokeMethod("test123", null)
//     }
//   }
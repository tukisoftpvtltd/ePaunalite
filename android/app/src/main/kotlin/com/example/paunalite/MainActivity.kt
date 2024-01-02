package com.tukisoft.ePaunaLite

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private val CHANNEL = "notification"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "getNotification") {
                // This block is executed when "getNotification" method is called from Flutter
                println("Message from android")
                // Create an Intent to launch the main activity of the Flutter app
                val intent = Intent(this, MainActivity::class.java)

                // Set the action to ACTION_MAIN, indicating that this is a main entry point
                intent.action = Intent.ACTION_MAIN

                // Add the CATEGORY_LAUNCHER category to indicate that it's a launcher activity
                intent.addCategory(Intent.CATEGORY_LAUNCHER)

                // Start the activity using the intent, which will bring the app to the foreground
                 startActivity(intent)

                // Example: Sending a result back to Flutter
                result.success("Notification data from native")
            } else {
                // result.notImplemented()
            }
        }
    }
}

// class MyBroadcastReceiver : BroadcastReceiver() {
//     override fun onReceive(context: Context?, intent: Intent?) {
//         println("Message from android123")
//         if (intent?.action == "OPEN_FLUTTER_APP") {
//             val launchIntent = context?.packageManager?.getLaunchIntentForPackage(context.packageName)
//             launchIntent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
//             context?.startActivity(launchIntent)
//         }
//     }
// }


// import android.content.*
// import io.flutter.embedding.android.FlutterActivity
// import androidx.annotation.NonNull
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// class MainActivity: FlutterActivity() {
//     private val CHANNEL = "notification"
//     private val channel: MethodChannel = MethodChannel(null, CHANNEL)
    
//     override fun configureFlutterEngine (@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine (flutterEngine)
        
//         // Use the already initialized 'channel'
//         channel.setMethodCallHandler { call, result ->
//             if (call.method == "getNotification") {
//                 // This block is executed when "getNotification" method is called from Flutter
//                 println("Message from android")
//                 // You can add your custom logic here
            
//                 // Example: Sending a result back to Flutter
//                 result.success("Notification data from native")
//             } else {
//                 // result.notImplemented()
//             }
//         }
//     }
// }



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

// var channel: MethodChannel? = null

// class MainActivity: FlutterActivity() {
//   private val CHANNEL = "notification"

//   override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//     super.configureFlutterEngine(flutterEngine)
//     channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    
//   }
// }
// import android.util.Log
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugins.GeneratedPluginRegistrant
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel

// class MainActivity : FlutterActivity() {
//     private val CHANNEL = 'notification'

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         GeneratedPluginRegistrant.registerWith(flutterEngine)

//         // Register the method channel
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             // Implement native code logic here based on method calls from Flutter
//             if (call.method == "getNotification") {
//                 Log.d("MyTag", "Your method was called") // Print a message to logcat
//                 // Call native functionality and send back the result to Flutter
//                 // result.success(yourNativeFunction())
//             } else {
//                 // result.notImplemented()
//             }
//         }
//     }
// }



// class NotificationServiceExtension : INotificationServiceExtension {

//   override fun onNotificationReceived(event: INotificationReceivedEvent) {
//       Log.v(Tag.LOG_TAG, "IRemoteNotificationReceivedHandler fired with INotificationReceivedEvent: ${event.toString()}")

//       // val notification = event.notification

//       // notification.actionButtons?.let {
//       //     for (button in it) {
//       //         Log.v(Tag.LOG_TAG, "ActionButton: ${button.toString()}")
//       //     }
//       // }

//       // notification.setExtender { builder ->
//       //     builder.setColor(event.context.resources.getColor(R.color.colorPrimary))
//       //     builder
//       // }
//   }
// }

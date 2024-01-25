import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:task/view_model/controller.dart';
import 'package:task/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:task/views/show_notification.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final DarwinInitializationSettings initializationSettingsDarwin =
  const DarwinInitializationSettings();

  String? initialMessage;


  String? fcmToken;
  getFcmToken() {
    firebaseMessaging.getToken().then((String? token) async {
      if (token == null) {
      } else {
        fcmToken = token;
        print("fcm Token=======$fcmToken");
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  void initState() {
    firebaseNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),

      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(deviceId: fcmToken ??"",),
      ),
    );
  }



  firebaseNotification() async {
    firebaseMessaging.requestPermission(alert: true);
    firebaseMessaging.isAutoInitEnabled;
    var android =
    const AndroidInitializationSettings('@drawable/launch_background');

    var ios = const DarwinInitializationSettings();
    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    firebaseMessaging.requestPermission(
        sound: true, alert: true, badge: true, provisional: true);
    initLocalNotification();

    getFcmToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;
      AppleNotification? appleNotification = message.notification?.apple;
      // data=message.notification?.body;
      print('message notification body=====${message.notification?.body.toString()}');

      if (notification != null && android != null) {
        showNotification(message.notification,message.notification?.body);


        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            print("abc525");
          } else {
            print("abc");
          }
        });
      } else if (notification != null && appleNotification != null) {
        showNotification(message.notification,message.notification?.body);
      } else {}
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.to(ShowNotification(notification: message.notification?.body ??""));
        // Get.offAll(NotificationScreen());
      }
    });



    firebaseMessaging.getToken().then((String? token) async {
      if (token == null) {
      } else {
        // MySharedPreferences.localStorage
        //     ?.setString(MySharedPreferences.deviceId, token);
        // print("token===$token");
      }
    }).catchError((error) {
      print(error.toString());
    });

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      print('FlutterFire Messaging Example: Getting APNs token...');
      String? token = await FirebaseMessaging.instance.getAPNSToken();
      print('FlutterFire Messaging Example: Got APNs token: $token');
    }
  }



  Future showNotification(RemoteNotification? notification,payload) async {
    var android = const AndroidNotificationDetails(
      'CHANNLEID',
      "CHANNLENAME",
      channelDescription: "channelDescription",
      importance: Importance.max,
      fullScreenIntent: true,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
    );
    var iOS = const DarwinNotificationDetails();

    var platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(DateTime.now().second,
        notification?.title, notification?.body, platform,payload: payload);

  }




  Future _selectNotification(String? message) async {
    print("show Notification ${message.toString()}");
    Get.to(ShowNotification(notification: message ??""));
  }



  Future initLocalNotification() async {

      var initializationSettingsAndroid =
      const AndroidInitializationSettings('@drawable/launch_background');

      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
         );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          _selectNotification(details.payload);},
        onDidReceiveBackgroundNotificationResponse: (details) {
          _selectNotification(details.payload);
        },

      );
    }


}

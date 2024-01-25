import 'package:flutter/material.dart';

class ShowNotification extends StatelessWidget {
  final String notification;
  const ShowNotification({super.key, required this.notification, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Notification"),
          backgroundColor: Theme.of(context).primaryColor),
      body:  SafeArea(child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
          Text(notification,style: TextStyle(fontWeight: FontWeight.w600),)

        ],),
      )),
    );
  }
}

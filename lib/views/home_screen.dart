import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/controller.dart';

class HomeScreen extends StatelessWidget {
  final String deviceId;
  const HomeScreen({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context,listen: false).timer(deviceId);
    return Consumer<HomeProvider>(

      builder: (context, provider, child) =>   Scaffold(
        appBar: AppBar(title: const Text("Home"),
        backgroundColor: Theme.of(context).primaryColor),
        body:  SafeArea(child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(provider.value,style: TextStyle(fontWeight: FontWeight.w600),)

          ],),
        ),),
      ),
    );
  }
}

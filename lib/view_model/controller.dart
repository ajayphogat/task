import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task/view_model/home_api.dart';

class HomeProvider extends ChangeNotifier {
  final HomeApi _homeApi = HomeApi();


  String value ="";
  int index = 1;




  timer(deviceId){
    Timer.periodic(Duration(seconds: 30), (timer) {
      callApi(deviceId);

    });
  }


  Future<void> callApi(deviceId) async {
    value ="";
    final res = await _homeApi.fetchData(index);
    if (res != null) {
      index++;
      value = res;
      await _homeApi.apiNotification(deviceId);

      // print("Get String =====$res");
      notifyListeners();
    }
  }
}

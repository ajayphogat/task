

import 'dart:convert';
import 'package:http/http.dart';

class HomeApi{
 String? apiResponse;
  Future<String?> fetchData(value) async {
    final response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts/$value"));

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

        apiResponse = data['body'];

       return apiResponse;

    } else {
      return null;
      // If the server did not return a 200 OK response,
      // throw an exception.

    }
  }

  apiNotification(String deviceId) async {
    print("call notification api");
    var headers = {
      'Authorization':
      'key=AAAA2MUEc-k:APA91bEJYntqI3safvlMCn2e7AcKaV36JkrZdOZCpd3a2BV3Ztf19hMZ5JhEM8YExiKZVKDUJlq4UyIXGRTZ8OBiFRVLBns_mD5B3I3OIw0HO0h_MKT0fWx-I173uFSqq58_Y2eVdJeW',
      'Content-Type': 'application/json'
    };
    var body = json.encode({
      "to": deviceId,
      "notification": {
        "title": " Success",
        "body": apiResponse
      },
      'data': {
        'payload': apiResponse, // Additional custom data
      },
    });
    var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: headers,body: body);




    if (response.statusCode == 200) {

    } else {
      print(response.reasonPhrase);
    }
  }

}
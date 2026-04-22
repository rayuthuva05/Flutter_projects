import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchService {
  static Future<List> fetchPayouts() async {
    final response = await http.get(
      Uri.parse("https://admin.mnursing.lk/api/v1/user/payouts"),
      headers: {
        "Authorization":
            "Bearer 129|3BYVX0V1J0XeLvYUE8lUHBJPsDWDhSANw8A0MF4ta15f7dc6",
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );

    final jsonData = jsonDecode(response.body);

    // print("Data3====>");
    // print(jsonData['data']['data']);

    // if (jsonData['data'] == null) {
    //   print(jsonData['message']);
    //   return [];
    // }

    return jsonData['data']['data'];
  }
}

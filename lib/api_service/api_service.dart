import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_module.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<Module> getModuleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('UID');
    if (uid == null) {
      throw Exception('UID not found in shared preferences');
    }

    final response = await http.get(Uri.parse('${baseUrl}/get_modules/$uid'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Module.fromJson(jsonResponse['modules'][0]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateStatus(String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('UID');
    if (uid == null) {
      throw Exception('UID not found in shared preferences');
    }

    final response = await http.put(
      Uri.parse('${baseUrl}/update_status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'UID': uid,
        'botid': 'bot_001', // Replace with actual bot ID if needed
        'status': newStatus,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }
}
import 'dart:convert';
import 'package:bot/api_service/api_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BotController extends GetxController {
  var isRunning = false.obs;
  var batteryLevel = 0.0.obs;
  var deviceName = ''.obs;
  var status = ''.obs;
  var frequency = ''.obs;
  var lastCleaned = ''.obs;
  var nextCleaning = ''.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    // fetchData();
  }

  void toggleStatus() async {
    isRunning.value = !isRunning.value;
    String newStatus = isRunning.value ? 'cleaning' : 'resting';
    // await _apiService.updateStatus(newStatus);
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('UID');
    if (uid == null) {
      print('UID not found in shared preferences');
      // throw Exception('UID not found in shared preferences');
    }

    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/get_modules/$uid'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      var module = jsonResponse['modules'][0];
      var moduleData = module['module_data'];

      deviceName.value = module['device_name'];
      status.value = module['status'];
      batteryLevel.value = double.parse(moduleData['battery_level']) / 100;
      frequency.value = moduleData['frequency'];
      lastCleaned.value = moduleData['last_cleaned'];
      nextCleaning.value = moduleData['next_cleaning'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}

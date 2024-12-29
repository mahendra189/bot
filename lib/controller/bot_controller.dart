// import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class BotController extends GetxController {
  BotController({required this.id});
  final num id;
  var isRunning = false.obs;
  var batteryLevel = 0.0.obs;
  var deviceName = ''.obs;
  var status = ''.obs;
  var frequency = ''.obs;
  var lastCleaned = ''.obs;
  var nextCleaning = ''.obs;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  // final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchRobotData();
  }

  Future<void> fetchRobotData() async {
    try {
      print("working");
      final snapshot = await _database.child('bots/$id').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Parse the data
        deviceName.value = data['device_name'] ?? 'Unknown Device';
        status.value = data['status'] ?? 'resting';
        batteryLevel.value = (data['battery_level'] ?? 0) / 100.0;
        frequency.value = data['frequency'] ?? 'N/A';
        lastCleaned.value = data['last_cleaned'] ?? 'N/A';
        nextCleaning.value = data['next_cleaning'] ?? 'N/A';

        // Update the running status
        isRunning.value = status.value == 'cleaning';
        print('Data fetched :$data');
      } else {
        print('No data available for robot ID: $id');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  void toggleStatus() async {
    try {
      isRunning.value = !isRunning.value;
      String newStatus = isRunning.value ? 'cleaning' : 'resting';

      // Update status in Firebase
      await _database.child('bots/$id/status').set(newStatus);
      status.value = newStatus;
    } catch (e) {
      print('Failed to update status: $e');
    }
  }

  // Future<void> fetchData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? uid = prefs.getString('UID');
  //   if (uid == null) {
  //     print('UID not found in shared preferences');
  //     // throw Exception('UID not found in shared preferences');
  //   }

  //   final response =
  //       await http.get(Uri.parse('http://10.0.2.2:5000/get_modules/$uid'));

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     var module = jsonResponse['modules'][0];
  //     var moduleData = module['module_data'];

  //     deviceName.value = module['device_name'];
  //     status.value = module['status'];
  //     batteryLevel.value = double.parse(moduleData['battery_level']) / 100;
  //     frequency.value = moduleData['frequency'];
  //     lastCleaned.value = moduleData['last_cleaned'];
  //     nextCleaning.value = moduleData['next_cleaning'];
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
}

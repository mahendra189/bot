import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class BotController extends GetxController {
  BotController({required this.id});
  final num id;

  // Reactive variables
  var isRunning = false.obs;
  var batteryLevel = 0.0.obs;
  var deviceName = ''.obs;
  var status = ''.obs;
  var frequency = ''.obs;
  var lastCleaned = ''.obs;
  var nextCleaning = ''.obs;
  var loading = true.obs;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void onInit() {
    super.onInit();
    fetchRobotData();
    subscribeToRealTimeUpdates(); // Add real-time updates
  }

  // Fetch data once
  Future<void> fetchRobotData() async {
    try {
      loading.value = true;

      // Fetch data from Firebase
      final snapshot = await _database.child('bots/$id').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Update reactive variables
        deviceName.value = data['device_name'] ?? 'Unknown Device';
        status.value = data['status'] ?? 'resting';
        batteryLevel.value = (data['battery_level'] ?? 0) / 100.0;
        frequency.value = data['frequency'] ?? 'N/A';
        lastCleaned.value = data['last_cleaned'] ?? 'N/A';
        nextCleaning.value = data['next_cleaning'] ?? 'N/A';
        isRunning.value = status.value == 'cleaning';

        print('Data fetched: $data');
      } else {
        print('No data available for robot ID: $id');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    } finally {
      loading.value = false; // Ensure loading stops
    }
  }

  // Listen for real-time updates
  void subscribeToRealTimeUpdates() {
    _database.child('bots/$id').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        // Update reactive variables in real-time
        deviceName.value = data['device_name'] ?? 'Unknown Device';
        status.value = data['status'] ?? 'resting';
        batteryLevel.value = (data['battery_level'] ?? 0) / 100.0;
        frequency.value = data['frequency'] ?? 'N/A';
        lastCleaned.value = data['last_cleaned'] ?? 'N/A';
        nextCleaning.value = data['next_cleaning'] ?? 'N/A';
        isRunning.value = status.value == 'cleaning';

        print('Real-time update: $data');
      }
    });
  }

  // Toggle status between cleaning and resting
  Future<void> toggleStatus() async {
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
}

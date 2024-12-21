class Module {
  final String uid;
  final String botId;
  final String deviceName;
  final String lastUpdated;
  final ModuleData moduleData;
  final String status;

  Module({
    required this.uid,
    required this.botId,
    required this.deviceName,
    required this.lastUpdated,
    required this.moduleData,
    required this.status,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      uid: json['UID'],
      botId: json['botid'],
      deviceName: json['device_name'],
      lastUpdated: json['last_updated'],
      moduleData: ModuleData.fromJson(json['module_data']),
      status: json['status'],
    );
  }
}

class ModuleData {
  final String batteryLevel;
  final String frequency;
  final String lastCleaned;
  final String nextCleaning;

  ModuleData({
    required this.batteryLevel,
    required this.frequency,
    required this.lastCleaned,
    required this.nextCleaning,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) {
    return ModuleData(
      batteryLevel: json['battery_level'],
      frequency: json['frequency'],
      lastCleaned: json['last_cleaned'],
      nextCleaning: json['next_cleaning'],
    );
  }
}
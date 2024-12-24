import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bot {
  final String name;
  final String status;
  final int batteryLevel;

  Bot({required this.name, required this.status, required this.batteryLevel});
}

// final databaseRef = FirebaseDatabase.instance.ref(); // Get a database reference

class BotModal {
  // Future<String?> _getUserId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("UID");
  // }

  // Future<void> _getBotList() async {
  //   String? userId = await _getUserId();
  //   if (userId != null) {}
  // }

  // List<Bot> getBotDetail() {
  //   return fetchBots(null);
  // }

  // Future<List<Bot>> fetchBots(String id) async {
  //   List<dynamic> bots = [];
  //   dynamic botInfo;
  //   Future<void> fetchBot() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? userId = prefs.getString("UID");
  //     if (userId != null) {
  //       DocumentSnapshot doc = await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(userId)
  //           .get();
  //       if (doc.exists) {
  //         var data = doc.data() as Map<String, dynamic>;
  //         List<dynamic> botsList = data["bots"];
  //         bots = botsList;
  //       }
  //     } else {
  //       bots = [];
  //     }
  //   }

  //   Future<void> fetchBotDetails(List<dynamic> bots) async {
  //     DatabaseReference usersRef = databaseRef.child('bots');
  //     dynamic which = id.isEmpty ? bots[0] : id;

  //     DatabaseEvent event = await usersRef.child("$which").once();
  //     Map<dynamic, dynamic>? data =
  //         event.snapshot.value as Map<dynamic, dynamic>?;
  //     if (data != null) {
  //       String name = data["name"];
  //       String status = data["status"];
  //       int batteryLevel = data["batteryLevel"];
  //       botInfo = Bot(name: name, status: status, batteryLevel: batteryLevel);
  //     }
  //   }

  //   await fetchBot();
  //   await fetchBotDetails(bots);

  //   return botInfo;
  // }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("UID");
  }

  Future<List<String>> fetchBotIds() async {
    String? userId = await _getUserId();
    if (userId == null) return [];

    DocumentSnapshot doc =
        await _firestore.collection("users").doc(userId).get();
    if (!doc.exists) return [];

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> botsList = data["bots"] ?? [];
    return List<String>.from(botsList);
  }

  Future<Bot?> fetchBotDetails(String botId) async {
    DatabaseEvent event = await _databaseRef.child("bots/$botId").once();
    if (event.snapshot.value == null) return null;

    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    return Bot(
      name: data["name"],
      status: data["status"],
      batteryLevel: data["batteryLevel"],
    );
  }

  Stream<List<Bot>> getBotsStream() async* {
    List<String> botIds = await fetchBotIds();
    for (String id in botIds) {
      Bot? bot = await fetchBotDetails(id);
      if (bot != null) yield [bot];
    }
  }
}

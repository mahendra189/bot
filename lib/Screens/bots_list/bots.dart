import 'package:bot/Screens/bots_list/bot_model.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/bot_model.dart';

// data structure
// bots
//    list of bots
final databaseRef = FirebaseDatabase.instance.ref(); // Get a database reference
// fetch data from database
Future<List<Bot>> fetchBots() async {
  List<dynamic> bots = [];
  List<Bot> botList = [];
  Future<void> fetchBot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("UID");
    if (userId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        List<dynamic> botsList = data["bots"];
        bots = botsList;
      }
    } else {
      bots = [];
    }
  }

  Future<void> fetchBotDetails(List<dynamic> bots) async {
    DatabaseReference usersRef = databaseRef.child('bots');
    for (var bot in bots) {
      DatabaseEvent event = await usersRef.child("$bot").once();
      Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      print(data);
      if (data != null) {
        String name = data["name"];
        String status = data["status"];
        int batteryLevel = data["batteryLevel"];
        botList
            .add(Bot(name: name, status: status, batteryLevel: batteryLevel));
      }
    }
  }

  await fetchBot();
  await fetchBotDetails(bots);

  return botList;
}

class BotsList extends StatelessWidget {
  const BotsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BAppBar(
        pageName: 'Bots List',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Bot>>(
        future: fetchBots(), // Await the Future from fetchBots()
        builder: (context, snapshot) {
          // Check the connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Handle errors
          } else if (snapshot.hasData) {
            List<Bot> bots = snapshot.data!; // Get the data
            return ListView.builder(
              itemCount: bots.length,
              itemBuilder: (context, index) {
                return BotListItem(bot: bots[index]);
              },
            );
          }
          return const Center(
              child: Text('No data available')); // Handle no data
        },
      ),
    );
  }
}

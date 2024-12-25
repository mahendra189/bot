import 'package:bot/Screens/bots_list/bot_model.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:bot/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: BAppBar(
        pageName: 'Bots List',
        icon: Icons.add,
        onIconPressed: () {
          print("Clicki");
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return bottomSheet(context);
              });
        },
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
            if (bots.isEmpty) {
              return const ListTile(
                leading: Icon(Icons.wifi),
                title: Text("No Bots Available!"),
              );
            } else {
              return ListView.builder(
                itemCount: bots.length,
                itemBuilder: (context, index) {
                  return BotListItem(bot: bots[index]);
                },
              );
            }
          }
          return const Center(
              child: Text('No data available')); // Handle no data
        },
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    TextEditingController botNameController = TextEditingController();
    TextEditingController botUIController = TextEditingController();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Add a Bot',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: botNameController,
                  decoration: const InputDecoration(
                    labelText: 'Bot Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: botUIController,
                  decoration: const InputDecoration(
                    labelText: 'Bot ID',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      onPressed: () => {print("Add Bot")},
                      child: const Text(
                        'Add Bot',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: ButtonStyle(),
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

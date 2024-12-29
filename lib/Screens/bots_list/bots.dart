import 'package:bot/Screens/bots_list/bot_model.dart';
import 'package:bot/Screens/device_details/robot_details.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:bot/utils/constants/sizes.dart';
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
        for (var bot in botsList) {
          botList.add(Bot(id: bot['id'], name: bot['name']));
        }
      } else {
        botList = [];
      }
    }
  }

  await fetchBot();

  return botList;
}

Future<void> handleAddBot(String id, String name) async {
  // Function to get the last list of bots from Firestore
  Future<List<dynamic>> getLastList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("UID");
    if (userId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        print("data $data");
        List<dynamic> botsList = (data['bots'] ?? []) as List<dynamic>;
        return botsList;
      } else {
        return [];
      }
    }
    return [];
  }

  // Function to add the bot to Firestore and Realtime Database
  Future<void> addBot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("UID");

    if (userId != null) {
      // Get the last list of bots
      List<dynamic> past = await getLastList();
      print("Past: $past");

      // Add the bot to Firestore (User's bot list)
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'bots': FieldValue.arrayUnion([
          ...past,
          {
            'id': int.parse(id),
            'name': name,
          }
        ])
      });

      // Add the bot to Firebase Realtime Database
      DatabaseReference _database = FirebaseDatabase.instance.ref();
      await _database.child('bots/$id').set({
        'device_name': name,
        'status': 'resting', // Default status
        'battery_level': 100, // Default battery level
        'frequency': 'N/A', // Default frequency
        'last_cleaned': 'N/A', // Default last cleaned
        'next_cleaning': 'N/A', // Default next cleaning
      });
    }
  }

  // Call the addBot function to add the bot
  await addBot();
}

class BotsList extends StatefulWidget {
  const BotsList({super.key});
  @override
  State<BotsList> createState() => _BotsListState();
}

class _BotsListState extends State<BotsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BAppBar(
          pageName: 'Bots List',
          icon: Icons.add,
          onIconPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return AddBotModel(onAddBot: () {
                    setState(() {});
                  });
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
                  leading: Icon(Icons.wifi_off),
                  title: Text("No Bots Available!"),
                );
              } else {
                return ListView.builder(
                  itemCount: bots.length,
                  itemBuilder: (context, index) {
                    return BotListItem(
                      bot: bots[index],
                      onBotPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RobotManagementPage(bot: bots[index]);
                        }));
                      },
                    );
                  },
                );
              }
            }
            return const Center(
                child: Text('No data available')); // Handle no data
          },
        ));
  }
}

class AddBotModel extends StatefulWidget {
  final VoidCallback onAddBot; // Callback to trigger reload

  const AddBotModel({super.key, required this.onAddBot});
  @override
  State<AddBotModel> createState() => _AddBotModel();
}

class _AddBotModel extends State<AddBotModel> {
  final TextEditingController botNameController = TextEditingController();
  final TextEditingController botUIController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                TextField(
                  controller: botNameController,
                  decoration: const InputDecoration(
                    labelText: 'Bot Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextField(
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
                              WidgetStateProperty.all(Colors.blue)),
                      onPressed: () async {
                        // Handle adding the bot to the Firestore
                        await handleAddBot(
                            botUIController.text, botNameController.text);

                        // Notify parent widget to refresh the list
                        widget.onAddBot();

                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Add Bot',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
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

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
      }
    }
  }

  await fetchBot();

  return botList;
}

Future<void> handleAddBot(String id, String name) async {
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
        List<dynamic> botsList = data["bots"];
        return botsList;
      } else {
        return [];
      }
    }
    return [];
  }

  Future<void> addBot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("UID");
    if (userId != null) {
      List<dynamic> past = await getLastList();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'bots': FieldValue.arrayUnion([
          ...past,
          {
            'id': int.parse(id),
            'name': name,
          }
        ])
      });
    }
  }

  await addBot();
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
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return const AddBotModel();
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
                          MaterialPageRoute(builder: (BuildContext context) {
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
      ),
    );
  }
}

class AddBotModel extends StatefulWidget {
  const AddBotModel({super.key});

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
                      onPressed: () {
                        handleAddBot(
                            botUIController.text, botNameController.text);
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

import 'package:bot/Screens/bots_list/bot_model.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:flutter/material.dart';

import '../../models/bot_model.dart';

// data structure
// bots
//    list of bots


class BotsList extends StatelessWidget {
  const BotsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Bot> bots = fetchBots();

    return Scaffold(
      appBar: const BAppBar(
        pageName: 'Bots List',
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: bots.length,
        itemBuilder: (context, index) {
          return BotListItem(bot: bots[index]);
        },
      ),
    );
  }
}

List<Bot> fetchBots() {
  // Simulate fetching data
  return [
    Bot(name: 'Bot 1', status: 'Cleaning', batteryLevel: 85),
    Bot(name: 'Bot 2', status: 'Idle', batteryLevel: 60),
    Bot(name: 'Bot 3', status: 'Charging', batteryLevel: 100),
    Bot(name: 'Bot 4', status: 'Charging', batteryLevel: 20),
    Bot(name: 'Bot 1', status: 'Cleaning', batteryLevel: 85),
    Bot(name: 'Bot 2', status: 'Idle', batteryLevel: 60),
    Bot(name: 'Bot 3', status: 'Charging', batteryLevel: 100),
    Bot(name: 'Bot 4', status: 'Charging', batteryLevel: 20),
    Bot(name: 'Bot 1', status: 'Cleaning', batteryLevel: 85),
    Bot(name: 'Bot 2', status: 'Idle', batteryLevel: 60),
    Bot(name: 'Bot 3', status: 'Charging', batteryLevel: 100),
    Bot(name: 'Bot 4', status: 'Charging', batteryLevel: 20),
  ];
}

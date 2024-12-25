import 'package:bot/models/bot_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BotListItem extends StatelessWidget {
  final Bot bot;

  const BotListItem({super.key, required this.bot});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.grey[100],
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Iconsax.cpu_charge,
                  size: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  bot.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // const SizedBox(height: 5),
            // Text('Status: ${bot.status}'),
            // const SizedBox(height: 5),
            // Text('Battery Level: ${bot.batteryLevel}%'),
          ],
        ),
      ),
    );
  }
}

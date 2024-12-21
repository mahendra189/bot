import 'package:bot/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/bot_controller.dart';

class BotDetails extends StatelessWidget {
  const BotDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the BotController
    final BotController botController = Get.put(BotController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding:
        const EdgeInsets.only(top: 10, left: 23, right: 23, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Robot Management",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
            const SizedBox(height: TSizes.md / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    Obx(
                        () => Text(botController.isRunning.value ? "Cleaning" : "Resting...",
                          style: const TextStyle(fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
                Obx(() => OutlinedButton(
                  onPressed: () => botController.toggleStatus(),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      textStyle: const TextStyle(color: Colors.black)),
                  child: Text(
                    botController.isRunning.value ? "Pause" : "Start",
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16),
                  ),
                )),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Battery Level",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    Text("${(botController.batteryLevel.value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
                Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: 5,
                    width: 150,
                    child: LinearProgressIndicator(
                      value: botController.batteryLevel.value,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.black),
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

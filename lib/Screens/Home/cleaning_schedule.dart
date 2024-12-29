import 'package:bot/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/bot_controller.dart';

class CleaningSchedule extends StatelessWidget {
  const CleaningSchedule({super.key, required this.botController});
  final BotController botController;
  @override
  Widget build(BuildContext context) {
    // Initialize the BotController

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 1,
        //     blurRadius: 7,
        //     offset: const Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cleaning Schedule",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
            const SizedBox(height: TSizes.md / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Next Cleaning",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    Obx(
                      () => Text(botController.nextCleaning.value,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade600)),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      textStyle: const TextStyle(color: Colors.black)),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Frequency",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    Obx(
                      () => Text(botController.frequency.value,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade600)),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      textStyle: const TextStyle(color: Colors.black)),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Last Cleaned",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    Obx(
                      () => Text(botController.lastCleaned.value,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade600)),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      textStyle: const TextStyle(color: Colors.black)),
                  child: const Text(
                    "View History",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
          ],
        ),
      ),
    );
  }
}

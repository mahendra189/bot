import 'package:bot/Screens/Home/cleaning_schedule.dart';
import 'package:bot/controller/bot_controller.dart';
import 'package:bot/models/bot_model.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:bot/utils/time_calculation/time_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../utils/constants/sizes.dart';

// realtime database
// bot
//    unique id
//    current status
//    battery
//    next cleaning time -> time
//    frequency -> daily/weekly

class RobotManagementPage extends StatelessWidget {
  RobotManagementPage({super.key, required this.bot});

  final ValueNotifier<bool> isStarted = ValueNotifier<bool>(false);
  final Bot bot;
  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchData(); // Fetch data when the controller is initialized
  // }

  @override
  Widget build(BuildContext context) {
    final BotController botController =
        Get.put(BotController(id: bot.id), tag: 'BotController_${bot.id}');
    // Initialize the BotController
    // Replace this with the time fetched from the API
    final relativeTime = botController.nextCleaning.value;
    final scheduledTime = parseRelativeTime(relativeTime);
    final remainingTime = getRemainingTime(scheduledTime);
    DateFormat('h:mma').format(scheduledTime);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const BAppBar(
          pageName: 'Robot Details',
          icon: null,
        ),
        body: Obx(() {
          if (botController.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
              padding: const EdgeInsets.only(
                top: TSizes.md,
                left: TSizes.lg * 1.5,
                right: TSizes.lg * 2,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(botController.deviceName.value,
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    Divider(
                        color: Colors.grey[400],
                        thickness: 0.7,
                        indent: 0,
                        endIndent: 0),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Obx(() => Text(
                                botController.isRunning.value
                                    ? "Cleaning"
                                    : "At Rest",
                                style: const TextStyle(fontSize: 23))),
                            const SizedBox(width: TSizes.md),
                            Obx(
                              () => Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: botController.isRunning.value
                                      ? Colors.green
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => OutlinedButton(
                            onPressed: () => {
                              if (!botController.isRunning.value)
                                {botController.toggleStatus()},
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: botController.isRunning.value
                                  ? Colors.grey[300]
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: BorderSide(
                                color: botController.isRunning.value
                                    ? Colors.grey[300] ?? Colors.grey
                                    : Colors.black,
                              ),
                              textStyle: const TextStyle(color: Colors.black),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0,
                              ),
                            ),
                            child: Text(
                              "Start",
                              style: TextStyle(
                                  color: botController.isRunning.value
                                      ? Colors.grey[500]
                                      : Colors.black,
                                  fontSize: 25),
                            ),
                          ),
                        ),
                        Obx(
                          () => OutlinedButton(
                            onPressed: () => {
                              if (botController.isRunning.value)
                                {botController.toggleStatus()},
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: botController.isRunning.value
                                  ? null
                                  : Colors.grey[300] ?? Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: BorderSide(
                                color: botController.isRunning.value
                                    ? Colors.black
                                    : Colors.grey[100] ?? Colors.grey,
                              ),
                              textStyle: const TextStyle(color: Colors.black),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 10.0,
                              ),
                            ),
                            child: Text(
                              "Pause",
                              style: TextStyle(
                                color: botController.isRunning.value
                                    ? Colors.black
                                    : Colors.grey[500] ?? Colors.grey,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: const StepProgressIndicator(
                        totalSteps: 10,
                        currentStep: 6,
                        size: 12,
                        roundedEdges: Radius.circular(10),
                        selectedColor: Colors.green,
                        unselectedColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    Row(
                      children: [
                        Text('Starts in $remainingTime',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: TSizes.md * 1.5),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 3),
                    Divider(
                        color: Colors.grey[400],
                        thickness: 0.7,
                        indent: 0,
                        endIndent: 0),
                    const SizedBox(height: TSizes.spaceBtwSections / 3),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Battery Level',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "${(botController.batteryLevel.value * 100).toStringAsFixed(0)}%",
                                  style: const TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems * 1.5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            height: 8,
                            width: 300,
                            child: LinearProgressIndicator(
                              value: botController.batteryLevel.value,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems * 1.5),
                        Divider(
                          color: Colors.grey[400],
                          thickness: 0.7,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 1.7),
                    Column(
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: TSizes.md),
                            Icon(Iconsax.cloud, size: 35),
                            SizedBox(width: TSizes.lg),
                            Text('Wind Speed', style: TextStyle(fontSize: 23)),
                            SizedBox(width: TSizes.lg),
                            Text('10 ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('kmph', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Divider(
                          color: Colors.grey[400],
                          thickness: 0.7,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 1.7),
                    Column(
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: TSizes.md),
                            Icon(Iconsax.cloud_drizzle, size: 37),
                            SizedBox(width: TSizes.lg),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Partly Cloudy',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500)),
                                Text('Safe to operate',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Divider(
                          color: Colors.grey[400],
                          thickness: 0.7,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 1.7),
                    const Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: TSizes.md),
                            Icon(Iconsax.setting, size: 37),
                            SizedBox(width: TSizes.lg),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Maintenance',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500)),
                                Text('Due in 2 weeks',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    CleaningSchedule(
                      botController: botController,
                    ),
                  ],
                ),
              ));
        }));
  }
}

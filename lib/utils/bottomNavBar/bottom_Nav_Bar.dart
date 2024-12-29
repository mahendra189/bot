import 'package:bot/Screens/Home/home.dart';
import 'package:bot/Screens/bots_list/bots.dart';
import 'package:bot/Screens/device_details/robot_details.dart';
import 'package:bot/Screens/profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkUser() async {
  SharedPreferences pred = await SharedPreferences.getInstance();
  String? userId = pred.getString("UID");
  if (userId != null) {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (!doc.exists) {
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        'firstName': "",
        'lastName': "",
        'phoneNumber': "",
        'profileImageUrl': "",
        'bots': []
      });
    }
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            // NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            // NavigationDestination(
            //     icon: Icon(Iconsax.devices5), label: 'Robot Details'),
            NavigationDestination(icon: Icon(Iconsax.driver), label: 'Bots'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    // const HomeScreen(),
    // RobotManagementPage(),
    const BotsList(),
    const ProfilePage(),
  ];
}

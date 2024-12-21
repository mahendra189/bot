import 'package:bot/Screens/Home/cleaning_schedule.dart';
import 'package:bot/Screens/Home/bot_details.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:bot/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: BAppBar(
        pageName: 'Home',
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: TSizes.md * 1.5, right: TSizes.md * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome," , style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Text("User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              SizedBox(height: TSizes.md),

              BotDetails(),

              SizedBox(height: TSizes.md),

              CleaningSchedule(),

            ],
          ),
        ),
      ),
    );
  }
}

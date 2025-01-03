import 'package:bot/Screens/login/login_page.dart';
import 'package:bot/Screens/profile/profile_model.dart';
import 'package:bot/main.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:bot/utils/constants/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleLogOut() {
  Future<void> logOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  logOut();
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileModel model = ProfileModel();
    model.fetchUserID();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BAppBar(
        pageName: 'Profile',
        icon: Iconsax.logout_1,
        onIconPressed: () {
          handleLogOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthWrapper()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: model.profileFormKey,
              child: Column(
                children: [
                  Center(
                    child: ValueListenableBuilder<String>(
                      valueListenable: model.profileImageNotifier,
                      // Listen for image URL changes
                      builder: (context, profileImageUrl, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl) as ImageProvider
                              : const AssetImage(
                                  'assets/images/default_profile.png'), // Default image
                          child: profileImageUrl.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        );
                      },
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => model.pickProfileImage(context),
                      child: const Text('Change Profile Picture'),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: model.fNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields / 1.5),
                      Expanded(
                        child: TextFormField(
                          controller: model.lNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: model.phoneNoController,
                    decoration: const InputDecoration(
                      labelText: 'Phone No.',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: model.systemIDController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'System ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  ElevatedButton(
                    onPressed: () => model.updateUserData(context),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

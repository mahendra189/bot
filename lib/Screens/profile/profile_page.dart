import 'package:bot/Screens/profile/profile_model.dart';
import 'package:bot/utils/appBar/bAppBar.dart';
import 'package:bot/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileModel model = ProfileModel();
    model.fetchUserID();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BAppBar(
        pageName: 'Profile',
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
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
      ),
    );
  }
}

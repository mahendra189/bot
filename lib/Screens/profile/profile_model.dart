import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController systemIDController = TextEditingController();

  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();

  // Notifier for profile image URL
  final ValueNotifier<String> profileImageNotifier = ValueNotifier<String>('');

  Future<void> fetchUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('UID');
    if (userId != null) {
      await fetchUserData(userId);
    }
  }

  Future<void> pickProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String? userId = await _getUserId();
      if (userId != null) {
        String downloadUrl = await _uploadImageToStorage(pickedFile, userId);
        await _updateProfileImageUrl(userId, downloadUrl);
        profileImageNotifier.value =
            downloadUrl; // Notify UI about new image URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated')),
        );
      }
    } else {
      // print("Select a image");
    }
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UID');
  }

  Future<String> _uploadImageToStorage(XFile pickedFile, String userId) async {
    try {
      // Create a reference to Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userId/${pickedFile.name}');

      // Upload the image file
      UploadTask uploadTask = storageRef.putFile(File(pickedFile.path));

      // Get the download URL once the upload is complete
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> _updateProfileImageUrl(String userId, String downloadUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
      });
    } catch (e) {
      // print('Error updating profile image URL: $e');
    }
  }

  Future<void> fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        fNameController.text = data['firstName'] ?? '';
        lNameController.text = data['lastName'] ?? '';
        phoneNoController.text = data['phoneNumber'] ?? '';
        systemIDController.text = data['systemId'] ?? '';
        profileImageNotifier.value = data['profileImageUrl'] ?? ''; // Notify UI
      }
    } catch (e) {
      // print('Error fetching user data: $e');
    }
  }

  Future<void> updateUserData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('UID');
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'firstName': fNameController.text,
        'lastName': lNameController.text,
        'phoneNumber': phoneNoController.text,
        'profileImageUrl': profileImageNotifier.value, // Use current image URL
      });
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Updating Profile!!')),
      );
    }
  }
}

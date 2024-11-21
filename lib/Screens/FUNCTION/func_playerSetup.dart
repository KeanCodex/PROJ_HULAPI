import 'dart:io';

import 'package:basic/helpers/app_init.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:basic/models/playerData.dart';
import 'package:basic/utils/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerSetupViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final PageController pageController = PageController(viewportFraction: 0.3);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int selectedAvatarIndex = 0;
  int playerScore = 0; // Default score, modify as needed

  final List<String> avatarImages = [
    Application().avatar.avatar1,
    Application().avatar.avatar2,
    Application().avatar.avatar3,
    Application().avatar.avatar4,
    Application().avatar.avatar5,
    Application().avatar.avatar6,
  ];
  final OutlineInputBorder borderCust = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: AppColor().white, width: 1),
  );
  List<Color> listOfColors = const [
    Colors.green,
    Colors.yellow,
    Colors.green,
    Colors.yellow,
    Colors.green,
    Colors.yellow
  ];
  List<Color> listBackground = const [
    Color(0xFF88C273), // Medium Green
    Color(0xFFFFB38E), // Bright Yellow
    Color(0xFF789DBC), // Dark Green
    Color(0xFFE4C087), // Amber Yellow
    Color(0xFF697565), // Light Green
    Color(0xFFE6B9A6), // Light Yellow
  ];

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Android ID as device identifier
      print('Running on ${androidInfo.model}');
    }
    return deviceId;
  }

  Future<void> startGame(BuildContext context, Player player) async {
    if (validateName(context)) {
      bool isConnected = await checkInternetConnection();
      String deviceId = await getDeviceId();

      try {
        if (isConnected) {
          // Save to Firestore
          await _firestore.collection('hulapi_player').doc(deviceId).set({
            'name': player.name,
            'image': player.image,
            'level': player.level,
            'score': player.score,
          });
          print('Player data saved to Firestore.');
        } else {
          // Save to Hive
          var box = await Hive.openBox('hulapi_player');
          await box.put(deviceId, {
            'name': player.name,
            'image': player.image,
            'level': player.level,
            'score': player.score,
          });
          print('Player data saved to Hive.');
        }

        // Success notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Player data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to play screen
        GoRouter.of(context).push('/play');
      } catch (e) {
        // Error handling
        print('Error saving player data: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "An error occurred while saving your data. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  void onPageChanged(double page) {
    int selectedIndex = page.round();
    if (selectedAvatarIndex != selectedIndex) {
      selectedAvatarIndex = selectedIndex;
      notifyListeners();
    }
  }

  bool validateName(BuildContext context) {
    if (nameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Name"),
          content: const Text("Player name cannot be empty."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    pageController.dispose();
    super.dispose();
  }
}

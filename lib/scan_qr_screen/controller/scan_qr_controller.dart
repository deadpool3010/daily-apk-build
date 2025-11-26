import 'dart:async';
import 'dart:convert';

import 'package:bandhucare_new/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrController extends GetxController {
  // Timer countdown
  final isScanning = true.obs;
  final mobileScannerController = Rxn<MobileScannerController>();
  final cameraError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        autoStart: false, // Don't auto-start, we'll start manually
      );

      // Start the camera manually after a short delay
      await Future.delayed(Duration(milliseconds: 300));

      try {
        await controller.start();
        mobileScannerController.value = controller;
        cameraError.value = null; // Clear any previous errors
      } catch (startError) {
        print('Error starting camera: $startError');
        try {
          await controller.dispose();
        } catch (_) {}

        // Check if it's a MissingPluginException
        if (startError.toString().contains('MissingPluginException')) {
          cameraError.value =
              'Camera plugin not registered.\n\n'
              'Please:\n'
              '1. Stop the app completely\n'
              '2. Run: flutter clean\n'
              '3. Run: flutter pub get\n'
              '4. Rebuild the app (not hot reload)';
        } else {
          cameraError.value = 'Camera failed to start. Please restart the app.';
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');

      // Check if it's a MissingPluginException
      if (e.toString().contains('MissingPluginException')) {
        cameraError.value =
            'Camera plugin not registered.\n\n'
            'Please:\n'
            '1. Stop the app completely\n'
            '2. Run: flutter clean\n'
            '3. Run: flutter pub get\n'
            '4. Rebuild the app (not hot reload)';
      } else {
        cameraError.value =
            'Camera not available. Please restart the app after installing dependencies.';
      }
      // If camera fails, still proceed with countdown
      // The UI will show an error message
    }
  }

  void handleBarcode(String rawValue) async {
    if (!isScanning.value) return;

    isScanning.value = false;
    await mobileScannerController.value?.stop();

    try {
      dynamic parsedData = jsonDecode(rawValue);
      Get.offNamed(AppRoutes.joinGroupScreen, arguments: parsedData);
    } catch (e) {
      isScanning.value = true;
      mobileScannerController.value?.start();
      Get.snackbar(
        'Invalid QR',
        'Unable to read group information. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    mobileScannerController.value?.dispose();
    super.onClose();
  }
}

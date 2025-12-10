import 'dart:async';
import 'dart:convert';

import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class ScanQrController extends GetxController {
  // Timer countdown
  final isScanning = true.obs;
  final mobileScannerController = Rxn<MobileScannerController>();
  final cameraError = Rxn<String>();
  final isLoadingImage = false.obs;
  final isFlashOn = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  // Debounce timer to prevent multiple rapid scans
  Timer? _debounceTimer;
  String? _lastScannedCode;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final controller = MobileScannerController(
        detectionSpeed: DetectionSpeed
            .normal, // Changed from noDuplicates to normal for faster scanning
        facing: CameraFacing.back,
        autoStart: true, // Auto-start for faster initialization
      );

      // Reduced delay for faster startup
      await Future.delayed(Duration(milliseconds: 100));

      try {
        // Since autoStart is true, the controller should start automatically
        // Just assign it to the reactive variable
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

    // Prevent duplicate scans of the same code
    if (_lastScannedCode == rawValue) {
      return;
    }
    _lastScannedCode = rawValue;

    // Cancel any existing debounce timer
    _debounceTimer?.cancel();

    // Process immediately with minimal delay (50ms) to prevent rapid duplicate scans
    _debounceTimer = Timer(Duration(milliseconds: 50), () async {
      if (!isScanning.value) return;

      isScanning.value = false;
      await mobileScannerController.value?.stop();

      try {
        dynamic parsedData = jsonDecode(rawValue);
        print("parsedData:::::::::::::::::::: $parsedData");
        Get.offNamed(AppRoutes.joinGroupScreen, arguments: parsedData);
      } catch (e) {
        isScanning.value = true;
        _lastScannedCode = null; // Reset to allow retry
        mobileScannerController.value?.start();
        Fluttertoast.showToast(
          msg: 'Unable to read group information. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });
  }

  // Pick image from gallery and scan for QR code
  Future<void> pickImageFromGallery() async {
    try {
      isLoadingImage.value = true;

      // Pick image from gallery
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) {
        isLoadingImage.value = false;
        return;
      }

      // Create a temporary scanner controller for image analysis
      final tempController = MobileScannerController();

      try {
        // Analyze the image for QR codes using the file path
        final result = await tempController.analyzeImage(image.path);

        if (result != null && result.barcodes.isNotEmpty) {
          final rawValue = result.barcodes.first.rawValue;
          if (rawValue != null) {
            isLoadingImage.value = false;
            await tempController.dispose();
            handleBarcode(rawValue);
            return;
          }
        }

        // If no QR code found
        await tempController.dispose();
        isLoadingImage.value = false;

        // Use Fluttertoast which doesn't require overlay
        Fluttertoast.showToast(
          msg:
              'The selected image does not contain a valid QR code. Please try another image.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      } catch (analyzeError) {
        await tempController.dispose();
        isLoadingImage.value = false;

        // Use Fluttertoast which doesn't require overlay
        Fluttertoast.showToast(
          msg: 'Failed to process image. Please try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      isLoadingImage.value = false;

      // Use Fluttertoast which doesn't require overlay
      Fluttertoast.showToast(
        msg: 'Failed to access gallery. Please check permissions.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Toggle flash on/off
  Future<void> toggleFlash() async {
    try {
      final controller = mobileScannerController.value;
      if (controller == null) return;

      // Toggle the torch
      await controller.toggleTorch();
      // Manually update the state since torchState listener is not available
      isFlashOn.value = !isFlashOn.value;
    } catch (e) {
      print('Error toggling flash: $e');
      Get.snackbar(
        'Error',
        'Failed to toggle flash. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    mobileScannerController.value?.dispose();
    super.onClose();
  }
}

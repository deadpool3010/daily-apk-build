import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/tiptap_renderer_registration.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class BlogScreenController extends GetxController with GetTickerProviderStateMixin {
  final RxInt currentImagePage = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxString currentTime = '00:32'.obs;
  final RxList<double> waveformHeights = <double>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Map<String, dynamic>?> contentData = Rx<Map<String, dynamic>?>(null);
  
  Timer? _audioTimer;
  Timer? _carouselTimer;
  Timer? _waveformTimer;
  late AnimationController _waveformAnimationController;
  int _audioSeconds = 32;
  
  // Waveform bar count
  static const int waveformBarCount = 35;
  // Waveform bar width (can be changed)
  double waveformBarWidth = 0.3;

  // Image pages with timestamps
  final List<List<Map<String, String>>> imagePages = [
    [
      {'image': ImageConstant.care_hub_img_2, 'time': '4:00 pm'},
      {'image': ImageConstant.care_hub_img_3, 'time': '8:00 am'},
      {'image': ImageConstant.care_hub_img_2, 'time': '8:00 pm'},
      {'image': ImageConstant.care_hub_img_3, 'time': '12:00 pm'},
    ],
    [
      {'image': ImageConstant.care_hub_healthy_diet_img, 'time': '6:00 am'},
      {'image': ImageConstant.care_hub_new_treatments_img, 'time': '10:00 am'},
      {'image': ImageConstant.care_hub_self_care_img, 'time': '2:00 pm'},
      {'image': ImageConstant.care_hub_basic_exercises_img, 'time': '6:00 pm'},
    ],
    [
      {'image': ImageConstant.care_hub_img_2, 'time': '7:00 am'},
      {'image': ImageConstant.care_hub_img_3, 'time': '12:00 pm'},
      {'image': ImageConstant.care_hub_img_2, 'time': '4:00 pm'},
      {'image': ImageConstant.care_hub_img_3, 'time': '8:00 pm'},
    ],
  ];

  @override
  void onInit() {
    super.onInit();
    // Register TipTap renderers
    registerTiptapRenderers();
    // Initialize waveform with default heights
    waveformHeights.value = List.generate(waveformBarCount, (index) => 10.0);
    // Initialize animation controller
    _waveformAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // Auto-scroll image carousel
    _startImageCarousel();
  }

  @override
  void onClose() {
    _stopImageCarousel();
    _stopAudio();
    _stopWaveform();
    _waveformAnimationController.dispose();
    super.onClose();
  }

  void _startImageCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      currentImagePage.value = (currentImagePage.value + 1) % imagePages.length;
    });
  }

  void _stopImageCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = null;
  }

  void toggleAudio() {
    if (isPlaying.value) {
      _stopAudio();
    } else {
      _startAudio();
    }
  }

  void _startAudio() {
    isPlaying.value = true;
    _audioTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _audioSeconds++;
      final minutes = _audioSeconds ~/ 60;
      final seconds = _audioSeconds % 60;
      currentTime.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
    _startWaveform();
  }

  void _stopAudio() {
    isPlaying.value = false;
    _audioTimer?.cancel();
    _audioTimer = null;
    _stopWaveform();
  }

  void _startWaveform() {
    _waveformAnimationController.repeat();
    _waveformTimer?.cancel();
    final random = Random();
    int tickCount = 0;
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      tickCount++;
      // Generate realistic waveform heights with multiple sine waves
      waveformHeights.value = List.generate(waveformBarCount, (index) {
        // Base height
        final baseHeight = 10.0;
        // Create multiple overlapping sine waves for realistic audio visualization
        final wave1 = sin((index * 0.4) + (tickCount * 0.15)) * 0.5 + 0.5;
        final wave2 = sin((index * 0.7) + (tickCount * 0.2)) * 0.3 + 0.3;
        final wave3 = sin((index * 1.2) + (tickCount * 0.1)) * 0.2 + 0.2;
        // Combine waves with some randomness
        final combinedWave = (wave1 + wave2 + wave3) / 3;
        final randomFactor = 0.7 + (random.nextDouble() * 0.3);
        // Calculate height (min 6, max 32)
        final height = baseHeight + (combinedWave * randomFactor * 40.0);
        return height.clamp(6.0, 32.0);
      });
    });
  }

  void _stopWaveform() {
    _waveformTimer?.cancel();
    _waveformTimer = null;
    _waveformAnimationController.stop();
    // Reset to default heights
    waveformHeights.value = List.generate(waveformBarCount, (index) => 8.0);
  }

  Future<void> loadContentById(String contentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await getContentByIdApi(contentId);
      
      if (response['success'] == true && response['data'] != null) {
        final content = response['data']['content'] as Map<String, dynamic>;
        
        // Parse TipTap content if it's a string
        if (content['content'] != null && content['content'] is String) {
          try {
            content['tiptapContent'] = jsonDecode(content['content'] as String);
          } catch (e) {
            print('Error parsing TipTap content: $e');
          }
        }
        
        contentData.value = content;
      } else {
        throw Exception(response['message'] ?? 'Failed to load content');
      }
    } catch (e) {
      print('Error loading content: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}


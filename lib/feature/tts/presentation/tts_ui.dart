import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/feature/tts/controller/controller.dart';

class TtsUi extends StatefulWidget {
  const TtsUi({super.key, required this.base64});
  final String base64;
  @override
  State<TtsUi> createState() => _TtsUiState();
}

class _TtsUiState extends State<TtsUi> {
  bool showTts = false;

  void showTtsContainer() {
    setState(() {
      showTts = true;
    });
  }

  void onShut() {
    // Immediately trigger animation by setting showTts to false
    // AnimatedPositioned will handle the smooth slide-up animation
    if (mounted) {
      setState(() {
        showTts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Button
          /// Animated TTS Container (from top)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500), // Slower animation
            curve: Curves
                .easeInOut, // Smooth animation for both opening and closing
            top: showTts ? 200 : -300, // Slide up and hide when closing
            left: 0,
            right: 0,
            child: Center(child: TtsContainer(base64: widget.base64)),
          ),
        ],
      ),
    );
  }
}

class TtsContainer extends StatefulWidget {
  const TtsContainer({super.key, required this.base64, this.onClose});
  final String base64;
  final VoidCallback? onClose;

  @override
  State<TtsContainer> createState() => _TtsContainerState();
}

class _TtsContainerState extends State<TtsContainer> {
  late final TtsController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller
    if (Get.isRegistered<TtsController>()) {
      _controller = Get.find<TtsController>();
    } else {
      _controller = Get.put(TtsController());
    }
    // Prepare audio from base64
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    try {
      await _controller.prepareAudioFromBase64(widget.base64);
    } catch (e) {
      print('Error preparing audio: $e');
      // Show error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      child: Container(
        height: 70,
        width: 370,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue.withOpacity(0.9),
        ),
        child: Obx(() {
          // Show loading indicator while preparing audio
          if (_controller.isLoading.value) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Text("Loading...", style: TextStyle(color: Colors.white)),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Play/Pause button
              InkWell(
                onTap: _controller.togglePlayPause,
                child: Icon(
                  _controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              // Current time / Total time
              Text(
                "${_controller.formatDuration(_controller.currentPosition.value)} / ${_controller.formatDuration(_controller.totalDuration.value)}",
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              // Replay 5 seconds
              InkWell(
                onTap: _controller.seekBackward,
                child: const Icon(Icons.replay_5, color: Colors.white),
              ),
              const SizedBox(width: 5),
              // Forward 5 seconds
              InkWell(
                onTap: _controller.seekForward,
                child: const Icon(Icons.forward_5, color: Colors.white),
              ),
              const SizedBox(width: 5),
              // Close button
              InkWell(
                onTap: () {
                  _controller.stop();
                  widget.onClose?.call();
                },
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          );
        }),
      ),
    );
  }
}

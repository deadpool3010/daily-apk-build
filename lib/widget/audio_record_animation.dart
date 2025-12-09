import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderController {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _amplitudeTimer;
  List<double> amplitudeList = [];
  List<double> targetAmplitudeList = [];
  List<double> currentAmplitudeList = [];
  bool isRecording = false;
  int _maxItemCount = 200;
  String? _recordingPath;
  Function(List<double>)? onAmplitudeUpdate;

  String? get recordingPath => _recordingPath;

  Future<void> startRecording(
    BuildContext context, [
    Function(List<double>)? onUpdate,
  ]) async {
    onAmplitudeUpdate = onUpdate;
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return;
    }

    if (await _recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      _recordingPath =
          '${directory.path}/temp_recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      final screenWidth = MediaQuery.of(context).size.width;
      const double horizontalPadding = 40.0;
      const double spacing = 3.0;
      final int itemCount = ((screenWidth - horizontalPadding) / spacing)
          .ceil()
          .clamp(60, 200);
      const double silentValue = -50.0;

      isRecording = true;
      _maxItemCount = itemCount;
      amplitudeList = List.filled(itemCount, silentValue, growable: true);
      targetAmplitudeList = List.filled(itemCount, silentValue, growable: true);
      currentAmplitudeList = List.filled(
        itemCount,
        silentValue,
        growable: true,
      );

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: _recordingPath!,
      );

      // Send initial silent values immediately so dots show up right away
      if (onAmplitudeUpdate != null && amplitudeList.isNotEmpty) {
        onAmplitudeUpdate!(List.from(amplitudeList));
      }

      _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 50), (
        timer,
      ) async {
        if (!isRecording) {
          timer.cancel();
          return;
        }

        try {
          final amplitude = await _recorder.getAmplitude();
          double ampValue = amplitude.current;

          // Handle invalid readings: treat as silence (will show dots)
          // -160 dB, -Infinity, NaN, or 0 means no sound detected
          if (ampValue.isNaN ||
              ampValue.isInfinite ||
              ampValue < -100 ||
              ampValue == 0.0) {
            ampValue = -50.0; // Set to silent range (will show small dots)
          }

          targetAmplitudeList.add(ampValue);

          // Initialize current amplitude for new bars
          if (currentAmplitudeList.length < targetAmplitudeList.length) {
            currentAmplitudeList.add(
              -50.0,
            ); // Start from silence (will show dots)
          }

          // Smooth interpolation for all bars
          for (int i = 0; i < currentAmplitudeList.length; i++) {
            double target = targetAmplitudeList[i];
            double current = currentAmplitudeList[i];

            // Lerp (linear interpolation) with 0.3 smoothing factor
            // Lower value = smoother but slower, higher = faster response
            currentAmplitudeList[i] = current + (target - current) * 0.3;
          }

          amplitudeList = List.from(currentAmplitudeList);

          // Keep only latest bars (maintain full-width buffer)
          if (amplitudeList.length > _maxItemCount) {
            amplitudeList.removeAt(0);
            targetAmplitudeList.removeAt(0);
            currentAmplitudeList.removeAt(0);
          }

          // Always notify listener of amplitude updates - create new list instance to trigger rebuild
          if (onAmplitudeUpdate != null && amplitudeList.isNotEmpty) {
            onAmplitudeUpdate!(List.from(amplitudeList));
          }
        } catch (e) {
          print('Error getting amplitude: $e');
          // Continue with silent value if error occurs
          if (onAmplitudeUpdate != null && amplitudeList.isNotEmpty) {
            onAmplitudeUpdate!(List.from(amplitudeList));
          }
        }
      });
    }
  }

  Future<File?> stopRecording() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;

    File? audioFile;
    if (await _recorder.isRecording()) {
      final path = await _recorder.stop();
      if (path != null && _recordingPath != null) {
        audioFile = File(_recordingPath!);
      }
    }

    isRecording = false;
    amplitudeList.clear();
    targetAmplitudeList.clear();
    currentAmplitudeList.clear();
    _recordingPath = null;

    return audioFile;
  }

  void dispose() {
    _amplitudeTimer?.cancel();
    _recorder.dispose();
  }
}

class AudioWavePainter extends CustomPainter {
  final List<double> amplitudes;

  AudioWavePainter(this.amplitudes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff397BE9)
      ..style = PaintingStyle.fill;

    if (amplitudes.isEmpty) return;

    // Calculate spacing to fill the entire width with tighter gaps
    const double startMargin = 0.0; // Small margin on the left
    const double endMargin = 0.0; // Small margin on the right
    double availableWidth = size.width - startMargin - endMargin;
    // Reduce spacing by 40% to pack items closer together
    double spacing = (availableWidth / amplitudes.length) * 0.6;

    // Center the items to still fill the full width
    double totalUsedWidth = spacing * amplitudes.length;
    double x = startMargin + (availableWidth - totalUsedWidth) / 2;

    for (var amp in amplitudes) {
      // Based on your data: silent is -35 to -40 dB, speaking is -10 to -6 dB
      // Threshold: -30 dB (below = dots, above = bars)
      const double silenceThreshold = -30.0;

      if (amp < silenceThreshold) {
        // Silent: draw small dots (circles)
        // Normalize silent range (-160 to -30) to small dot size (2-4 pixels)
        double dotSize;
        if (amp <= -100 || amp.isInfinite || amp.isNaN) {
          // Very silent or invalid: smallest dot
          dotSize = 0.1;
        } else {
          // Map -40 to -30 dB -> smaller dots for tighter spacing
          dotSize = 1.8 + ((amp + 40) / 10) * 0.1;
          dotSize = dotSize.clamp(1.0, 2.5); // Smaller dots
        }

        canvas.drawCircle(Offset(x, size.height / 2), dotSize / 2, paint);
      } else {
        // Speaking: draw bars (vertical lines) that grow with amplitude
        // Map -30 dB to -6 dB -> 0.1 to 1.0 normalized height
        double normalized =
            ((amp - silenceThreshold) / (-silenceThreshold - (-6.0))).clamp(
              0.1,
              1.0,
            );
        double barHeight = normalized * size.height * 0.95;

        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 0.8; // Thinner bars for closer appearance
        paint.strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(x, size.height / 2 - barHeight / 2),
          Offset(x, size.height / 2 + barHeight / 2),
          paint,
        );

        paint.style = PaintingStyle.fill; // Reset for next iteration
      }

      x += spacing;
    }
  }

  @override
  bool shouldRepaint(AudioWavePainter oldDelegate) {
    // Repaint if data length changed or if any values differ significantly
    if (oldDelegate.amplitudes.length != amplitudes.length) {
      return true;
    }
    // Check if any amplitude value changed significantly (more than 0.1 difference)
    for (
      int i = 0;
      i < amplitudes.length && i < oldDelegate.amplitudes.length;
      i++
    ) {
      if ((amplitudes[i] - oldDelegate.amplitudes[i]).abs() > 0.1) {
        return true;
      }
    }
    return false;
  }
}

class AudioWaveForm extends StatefulWidget {
  final List<double> data;

  const AudioWaveForm({required this.data, super.key});

  @override
  State<AudioWaveForm> createState() => _AudioWaveFormState();
}

class _AudioWaveFormState extends State<AudioWaveForm> {
  @override
  Widget build(BuildContext context) {
    // Always rebuild when data changes - use data length as part of key
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: CustomPaint(
        painter: AudioWavePainter(widget.data),
        willChange: true, // Hint that this will change frequently
      ),
    );
  }
}

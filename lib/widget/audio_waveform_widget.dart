import 'dart:async';
import 'dart:io';
import 'package:bandhucare_new/helper_classes/play_sound_helpler.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioWaveformWidget extends StatefulWidget {
  final VoidCallback? onRecordingStarted;
  final VoidCallback? onRecordingStopped;
  final Function(File?)? onAudioFileReady;

  const AudioWaveformWidget({
    super.key,
    this.onRecordingStarted,
    this.onRecordingStopped,
    this.onAudioFileReady,
  });

  @override
  State<AudioWaveformWidget> createState() => AudioWaveformWidgetState();
}

class AudioWaveformWidgetState extends State<AudioWaveformWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _amplitudeTimer;
  List<double> amplitudeList = [];
  List<double> targetAmplitudeList = []; // Target values
  List<double> currentAmplitudeList = []; // Current animated values
  bool isRecording = false;
  int _maxItemCount = 500; // Will be recalculated based on available width
  String? _recordingPath;

  Future<void> startRecording() async {
    // Show UI immediately for instant feedback

    final screenWidth = MediaQuery.of(context).size.width;
    const double desiredSpacing = 10.0;
    final int itemCount = (screenWidth / desiredSpacing).ceil().clamp(100, 500);
    const double silentValue = -50.0;

    if (mounted) {
      setState(() {
        isRecording = true;
        _maxItemCount = itemCount;
        amplitudeList = List.filled(itemCount, silentValue, growable: true);
        targetAmplitudeList = List.filled(
          itemCount,
          silentValue,
          growable: true,
        );
        currentAmplitudeList = List.filled(
          itemCount,
          silentValue,
          growable: true,
        );
      });
    }

    // Call callback immediately so UI updates
    widget.onRecordingStarted?.call();

    // Do async work in background
    await UiSoundPlayer.playAsset('sounds/start_recording.mp3', volume: 1.0);
    await Future.delayed(const Duration(milliseconds: 800));
    _startRecordingAsync();
  }

  Future<void> _startRecordingAsync() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted || !mounted) {
      if (mounted) {
        setState(() {
          isRecording = false;
        });
        widget.onRecordingStopped?.call();
      }
      return;
    }

    if (!await _recorder.hasPermission() || !mounted) {
      if (mounted) {
        setState(() {
          isRecording = false;
        });
        widget.onRecordingStopped?.call();
      }
      return;
    }

    if (!mounted) return;

    final directory = await getApplicationDocumentsDirectory();
    // Ensure WAV format: Use AudioEncoder.wav to create proper WAV file with headers
    _recordingPath =
        '${directory.path}/temp_recording_${DateTime.now().millisecondsSinceEpoch}.wav';

    if (!mounted || !isRecording) return;

    // Record in WAV format: AudioEncoder.wav creates proper WAV file with headers
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav, // Creates proper WAV file with headers
        sampleRate: 44100,
        numChannels: 1, // Mono audio
      ),
      path: _recordingPath!, // .wav extension
    );

    if (!mounted || !isRecording) return;

    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) async {
      if (!mounted || !isRecording) {
        timer.cancel();
        return;
      }

      final amplitude = await _recorder.getAmplitude();
      double ampValue = amplitude.current;

      // Handle invalid readings: treat as silence (will show dots)
      // -160 dB, -Infinity, or NaN means no sound detected
      if (ampValue.isNaN || ampValue.isInfinite || ampValue < -100) {
        ampValue = -50.0; // Set to silent range (will show small dots)
      }

      if (!mounted) return;

      setState(() {
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
      });
    });
  }

  Future<void> stopRecording() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;

    File? audioFile;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
      if (_recordingPath != null) {
        audioFile = File(_recordingPath!);
      }
    }

    if (mounted) {
      setState(() {
        isRecording = false;
      });
    }

    widget.onRecordingStopped?.call();
    widget.onAudioFileReady?.call(audioFile);
  }

  Future<void> cancelRecording() async {
    await UiSoundPlayer.playAsset('sounds/delete_recording2.mp3', volume: 0.8);

    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    if (mounted) {
      setState(() {
        isRecording = false;
      });
    }

    widget.onRecordingStopped?.call();
  }

  @override
  void dispose() {
    _amplitudeTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isRecording) {
      return const SizedBox.shrink();
    }

    return AudioWaveForm(data: amplitudeList);
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

    // Calculate spacing to fill the entire width edge to edge
    double availableWidth = size.width;
    // With more items, spacing will automatically be tighter while filling full width
    // Distribute items evenly across full width (first at 0, last at width)
    double spacing = amplitudes.length > 1
        ? availableWidth / (amplitudes.length - 1)
        : 0.0;

    // Start from the very left edge
    double x = 0.0;

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
          dotSize = 2.0 + ((amp + 40) / 10) * 0.1;
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
  bool shouldRepaint(AudioWavePainter oldDelegate) => true;
}

class AudioWaveForm extends StatelessWidget {
  final List<double> data;

  const AudioWaveForm({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Match text field height
      width: double.infinity,
      child: CustomPaint(painter: AudioWavePainter(data)),
    );
  }
}

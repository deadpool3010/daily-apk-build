import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class TtsController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Observable states
  var isLoading = false.obs;
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var errorMessage = RxnString();

  String? _tempAudioPath;

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayerListeners();
  }

  void onReady() {
    super.onReady();
    play();
  }

  void _setupAudioPlayerListeners() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
      if (state == PlayerState.completed) {
        // Reset when audio completes
        currentPosition.value = Duration.zero;
        isPlaying.value = false;
      }
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((position) {
      currentPosition.value = position;
    });
  }

  /// Prepare audio from base64 string
  Future<void> prepareAudioFromBase64(String base64String) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Stop any currently playing audio
      await _audioPlayer.stop();
      currentPosition.value = Duration.zero;
      isPlaying.value = false;

      // Clean up previous temp file if exists
      if (_tempAudioPath != null) {
        try {
          final oldFile = File(_tempAudioPath!);
          if (oldFile.existsSync()) {
            oldFile.deleteSync();
          }
        } catch (e) {
          print('Error deleting old temp file: $e');
        }
      }

      // Decode base64 to bytes
      final audioBytes = base64Decode(base64String);

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'tts_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final filePath = '${tempDir.path}/$fileName';

      // Write bytes to file
      final file = File(filePath);
      await file.writeAsBytes(audioBytes);
      _tempAudioPath = filePath;

      // Prepare audio player with the file
      await _audioPlayer.setSource(DeviceFileSource(filePath));

      // Get duration
      final duration = await _audioPlayer.getDuration();
      if (duration != null) {
        totalDuration.value = duration;
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Error preparing audio: $e';
      print('Error preparing audio from base64: $e');
      rethrow;
    }
  }

  /// Play audio
  Future<void> play() async {
    try {
      if (_tempAudioPath == null) {
        throw Exception(
          'No audio prepared. Call prepareAudioFromBase64 first.',
        );
      }

      // Check current player state (state is a Future)
      final state = await _audioPlayer.state;

      // If paused, resume
      if (state == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        // If stopped or completed, set source and play from current position
        await _audioPlayer.setSource(DeviceFileSource(_tempAudioPath!));

        // If we have a valid position and duration, seek to current position
        if (currentPosition.value > Duration.zero &&
            currentPosition.value < totalDuration.value &&
            totalDuration.value > Duration.zero) {
          await _audioPlayer.seek(currentPosition.value);
        }

        // Resume playback
        await _audioPlayer.resume();
      }
    } catch (e) {
      errorMessage.value = 'Error playing audio: $e';
      print('Error playing audio: $e');
      rethrow;
    }
  }

  /// Pause audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      errorMessage.value = 'Error pausing audio: $e';
      print('Error pausing audio: $e');
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await pause();
    } else {
      await play();
    }
  }

  /// Seek to specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      errorMessage.value = 'Error seeking: $e';
      print('Error seeking: $e');
    }
  }

  /// Seek backward by 5 seconds
  Future<void> seekBackward() async {
    final newPosition = currentPosition.value - const Duration(seconds: 5);
    await seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  /// Seek forward by 5 seconds
  Future<void> seekForward() async {
    final newPosition = currentPosition.value + const Duration(seconds: 5);
    if (newPosition > totalDuration.value) {
      await seek(totalDuration.value);
    } else {
      await seek(newPosition);
    }
  }

  /// Stop and reset audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      currentPosition.value = Duration.zero;
      isPlaying.value = false;
    } catch (e) {
      errorMessage.value = 'Error stopping audio: $e';
      print('Error stopping audio: $e');
    }
  }

  /// Format duration to MM:SS string
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    // Clean up temporary file
    if (_tempAudioPath != null) {
      try {
        final file = File(_tempAudioPath!);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        print('Error deleting temp file: $e');
      }
    }
    super.onClose();
  }
}

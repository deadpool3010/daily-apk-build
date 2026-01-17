import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlayerService {
  PlayerController? _playerController;
  String? _localAudioPath;
  int _currentDuration = 0;
  int _totalDuration = 0;
  bool _isPlaying = false;
  bool _hasWaveform = false;
  bool _isLoading = true;

  PlayerController? get playerController => _playerController;
  int get currentDuration => _currentDuration;
  int get totalDuration => _totalDuration;
  bool get isPlaying => _isPlaying;
  bool get hasWaveform => _hasWaveform;
  double get progress =>
      _totalDuration > 0 ? _currentDuration / _totalDuration : 0.0;

  void initialize() {
    _playerController = PlayerController();
  }

  Future<String> downloadAudio(String url) async {
    final dir = await getTemporaryDirectory();
    final fileName = url.split('/').last;
    final filePath = "${dir.path}/$fileName";

    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }

  Future<void> loadAudio({
    required String audioUrl,
    bool shouldExtractWaveform = true,
    int noOfSamples = 150,
    Function(int duration)? onDurationChanged,
    Function(bool isPlaying)? onStateChanged,
  }) async {
    if (audioUrl.isEmpty) return;

    try {
      final localPath = await downloadAudio(audioUrl);
      _localAudioPath = localPath;
      await _loadLocalAudio(
        localPath: localPath,
        shouldExtractWaveform: shouldExtractWaveform,
        noOfSamples: noOfSamples,
        onDurationChanged: onDurationChanged,
        onStateChanged: onStateChanged,
      );
    } catch (e) {
      print('Error loading audio: $e');
      throw Exception(e);
    }
  }

  Future<void> loadLocalAudioFile({
    required String filePath,
    bool shouldExtractWaveform = true,
    int noOfSamples = 150,
    Function(int duration)? onDurationChanged,
    Function(bool isPlaying)? onStateChanged,
  }) async {
    if (filePath.isEmpty) return;

    try {
      _localAudioPath = filePath;
      await _loadLocalAudio(
        localPath: filePath,
        shouldExtractWaveform: shouldExtractWaveform,
        noOfSamples: noOfSamples,
        onDurationChanged: onDurationChanged,
        onStateChanged: onStateChanged,
      );
    } catch (e) {
      print('Error loading local audio file: $e');
      throw Exception(e);
    }
  }

  Future<void> _loadLocalAudio({
    required String localPath,
    bool shouldExtractWaveform = true,
    int noOfSamples = 150,
    Function(int duration)? onDurationChanged,
    Function(bool isPlaying)? onStateChanged,
  }) async {
    _isLoading = true;
    try {
      await _playerController!.preparePlayer(
        path: localPath,
        shouldExtractWaveform: shouldExtractWaveform,
        noOfSamples: noOfSamples,
      );
      _playerController!.onCurrentDurationChanged.listen((duration) {
        _currentDuration = duration;

        // Check if audio finished
        if (_totalDuration > 0 && duration >= _totalDuration) {
          _isPlaying = false;
          _currentDuration = _totalDuration;
        }

        onDurationChanged?.call(duration);
      });

      // Listen to player state changes
      _playerController!.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;

        // When playback stops at the end
        if (state == PlayerState.stopped &&
            _totalDuration > 0 &&
            _currentDuration >= _totalDuration) {
          _isPlaying = false;
          _currentDuration = _totalDuration;
        }

        onStateChanged?.call(_isPlaying);
      });

      // Get total duration
      _totalDuration = await _playerController!.getDuration(DurationType.max);
      _hasWaveform = shouldExtractWaveform;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      print('Error loading local audio: $e');
      throw Exception(e);
    }
  }

  Future<void> togglePlayPause() async {
    try {
      final currentState = await _playerController!.playerState;
      if (currentState == PlayerState.playing) {
        await _playerController!.pausePlayer();
      } else {
        if (currentState == PlayerState.stopped) {
          if (_localAudioPath != null) {
            await _playerController!.preparePlayer(
              path: _localAudioPath!,
              shouldExtractWaveform: false,
              noOfSamples: 150,
            );
          }
          if (_totalDuration > 0 && _currentDuration >= _totalDuration) {
            await _playerController!.seekTo(0);
            _currentDuration = 0;
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
        await _playerController!.startPlayer();
      }
    } catch (e) {
      print('Error toggling play pause: $e');
      throw Exception(e);
    }
  }

  Future<void> seekTo(int milliseconds) async {
    if (_playerController == null) return;

    try {
      await _playerController!.seekTo(milliseconds);
    } catch (e) {
      print('Error seeking: $e');
      rethrow;
    }
  }

  void dispose() {
    _playerController?.dispose();
    _playerController = null;
    _localAudioPath = null;
    _currentDuration = 0;
    _totalDuration = 0;
    _isPlaying = false;
    _hasWaveform = false;
  }

  /// Reset the player to initial state
  void reset() {
    _currentDuration = 0;
    _isPlaying = false;
  }
}

import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bandhucare_new/core/services/audio_service.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/avatar.dart';
import 'package:flutter/material.dart';

class AudioPreviewInChat extends StatefulWidget {
  final String? profileImageUrl;
  final VoidCallback? onDelete;
  final bool isLoading;
  final AudioPlayerService audioPlayerService;
  const AudioPreviewInChat({
    super.key,
    this.profileImageUrl,
    this.onDelete,
    this.isLoading = false,
    required this.audioPlayerService,
  });

  @override
  State<AudioPreviewInChat> createState() => _AudioPreviewInChatState();
}

class _AudioPreviewInChatState extends State<AudioPreviewInChat> {
  bool _isPlaying = false;
  int _currentDuration = 0;
  int _totalDuration = 0;

  StreamSubscription<int>? _durationSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupListeners();
      _updateDurations();
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _stateSubscription?.cancel();
    super.dispose();
  }

  void _setupListeners() {
    final controller = widget.audioPlayerService.playerController;
    if (controller == null) return;

    // Cancel existing subscriptions if any
    _durationSubscription?.cancel();
    _stateSubscription?.cancel();

    // Listen to duration changes
    _durationSubscription = controller.onCurrentDurationChanged.listen((
      duration,
    ) {
      if (mounted) {
        setState(() {
          _currentDuration = duration;
          // Check if audio finished
          if (_totalDuration > 0 && duration >= _totalDuration) {
            _isPlaying = false;
            _currentDuration = _totalDuration;
          }
        });
      }
    });

    // Listen to player state changes
    _stateSubscription = controller.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          // When playback stops at the end
          if (state == PlayerState.stopped &&
              _totalDuration > 0 &&
              _currentDuration >= _totalDuration) {
            _isPlaying = false;
            _currentDuration = _totalDuration;
          }
        });
      }
    });
  }

  Future<void> _updateDurations() async {
    final controller = widget.audioPlayerService.playerController;
    if (controller == null) return;

    try {
      final duration = await controller.getDuration(DurationType.max);
      if (mounted) {
        setState(() {
          _totalDuration = duration;
          _currentDuration = widget.audioPlayerService.currentDuration;
        });
      }
    } catch (e) {
      print('Error getting duration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: 282,
      decoration: BoxDecoration(
        color: const Color(0xFF1E4DB7),
        borderRadius: BorderRadius.circular(7.75),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MicAvatar(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.audioPlayerService.togglePlayPause,
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: widget.isLoading
                ? const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : widget.audioPlayerService.hasWaveform &&
                      widget.audioPlayerService.playerController != null
                ? buildWaveformWithProgress(
                    context,
                    widget.audioPlayerService,
                    _currentDuration,
                    _totalDuration,
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: widget.onDelete,
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

class MicAvatar extends StatelessWidget {
  const MicAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Constrain avatar size to fit in audio preview (container is 53px high with padding)
        SizedBox(
          height: 32,
          width: 32,
          child: Avatar(), // your existing avatar
        ),
        Positioned(
          bottom: -1,
          right: -1,
          child: Container(
            height: 14,
            width: 14,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, size: 9, color: Color(0xFF3865FF)),
          ),
        ),
      ],
    );
  }
}

Widget buildWaveformWithProgress(
  BuildContext context,
  AudioPlayerService audioPlayerService,
  int currentDuration,
  int totalDuration,
) {
  final progress = totalDuration > 0 ? currentDuration / totalDuration : 0.0;

  // Use LayoutBuilder to get the actual available width in the Expanded widget
  return LayoutBuilder(
    builder: (context, constraints) {
      final double availableWidth = constraints.maxWidth;

      return SizedBox(
        height: 40,
        width: double.infinity,
        child: Stack(
          children: [
            // Full waveform in light color (background/inactive)
            AudioFileWaveforms(
              animationCurve: Curves.easeInOut,
              continuousWaveform: true,
              size: Size(availableWidth, 40),
              playerController: audioPlayerService.playerController!,
              waveformType: WaveformType.fitWidth, // Static waveform
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.white38, // Dim/light color
                liveWaveColor: Colors.white38,
                spacing: 3,
                showSeekLine: false,
                waveThickness: 2,
                scaleFactor: 100, // Controls wave height variation
              ),
              enableSeekGesture: true,
            ),
            // Progress overlay - fills with white from left
            Positioned.fill(
              child: ClipRect(
                clipper: _ProgressClipper(progress.clamp(0.0, 1.0)),
                child: AudioFileWaveforms(
                  continuousWaveform: true,
                  size: Size(availableWidth, 40),
                  playerController: audioPlayerService.playerController!,
                  waveformType: WaveformType.fitWidth, // Same static waveform
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.white, // Bright white for progress
                    liveWaveColor: Colors.white,
                    spacing: 3,
                    showSeekLine: false,
                    waveThickness: 2,
                    scaleFactor: 100,
                    // Must match background
                  ),
                  enableSeekGesture: false,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;

  _ProgressClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(_ProgressClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

import 'package:bandhucare/core/utils/image_constant.dart';
import 'package:bandhucare/presentation/chat_screen/e.dart';
import 'package:bandhucare/routes/app_routes.dart';
import 'package:bandhucare/services/Apires.dart';
import 'package:bandhucare/theme/app_theme.dart';
import 'package:bandhucare/theme/custom_textstyle.dart';
import 'package:bandhucare/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const Color chatIconColor = Color(0xFFeef5ff);
List<String> faq = [
  "How can I book an appointment?",
  "Can I reschedule or cancel my appointment?",
  "How do I access my medical reports?",
  "Can I consult a doctor online?",
  "How do I update my health details?",
  "Is my medical data safe?",
  "What should I do in case of emergency?",
];

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<double> _dotPositions = [0, 0, 0];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _dotPositions = List.generate(3, (index) {
          final delay = index * 0.2;
          final progress = (_controller.value - delay) % 1.0;
          if (progress < 0) return 0.0;
          return -4 * progress * (progress - 1); // Parabolic motion
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(left: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF1D2873)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Color(0xFF1D2873),
              shape: BoxShape.circle,
            ),
            transform: Matrix4.translationValues(0, _dotPositions[index], 0),
          );
        }),
      ),
    );
  }
}

class AudioWaveform extends StatefulWidget {
  const AudioWaveform({super.key});

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barHeights = List.generate(40, (index) => 5.0);
  final Random _random = Random();
  late List<double> _phases;
  late List<double> _frequencies;
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _phases = List.generate(40, (_) => _random.nextDouble() * 2 * pi);
    _frequencies = List.generate(40, (_) => _random.nextDouble() * 0.5 + 0.5);

    _controller.addListener(() {
      setState(() {
        _time += 0.03;
        for (int i = 0; i < _barHeights.length; i++) {
          final sinValue = sin(_phases[i] + _time * _frequencies[i]);
          final normalizedSin = (sinValue + 1) / 2;
          _barHeights[i] = (normalizedSin * 30) + 5;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          40,
          (index) => Container(
            width: 2.5,
            height: _barHeights[index],
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

class AudioMessageBubble extends StatefulWidget {
  final bool isUser;
  final String duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final bool isPreview;

  const AudioMessageBubble({
    Key? key,
    required this.isUser,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    this.isPreview = false,
  }) : super(key: key);

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveformController;
  final List<double> _barHeights = List.generate(40, (index) => 0);
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.isPlaying) {
      _waveformController.repeat(reverse: true);
    }

    _waveformController.addListener(() {
      setState(() {
        for (int i = 0; i < _barHeights.length; i++) {
          _barHeights[i] = _random.nextDouble() * 15 + 5;
        }
      });
    });
  }

  @override
  void didUpdateWidget(AudioMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _waveformController.repeat(reverse: true);
      } else {
        _waveformController.stop();
      }
    }
  }

  @override
  void dispose() {
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = !widget.isUser || widget.isPreview;
    final primaryColor = isLight ? const Color(0xFF1D2873) : Colors.white;
    final backgroundColor = isLight ? Colors.white : const Color(0xFF1D2873);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: const Color(0xFF1D2873), width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.duration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: StaticWaveform(isPlaying: widget.isPlaying)),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  widget.isPreview ? const Color(0xFF1D2873) : backgroundColor,
              border: Border.all(color: const Color(0xFF1D2873), width: 1.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                widget.isPreview
                    ? Icons.send
                    : (widget.isPlaying ? Icons.pause : Icons.play_arrow),
                size: 20,
                color: widget.isPreview ? Colors.white : primaryColor,
              ),
              onPressed: widget.onPlayPause,
            ),
          ),
        ],
      ),
    );
  }
}

class ModernAudioPlayer extends StatelessWidget {
  final bool isUser;
  final String duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final String? audioTranscript;
  final bool isUploading;
  final Duration? playbackPosition;
  final Duration? totalDuration;
  final String? createdAt;

  const ModernAudioPlayer({
    Key? key,
    required this.isUser,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    this.audioTranscript,
    this.isUploading = false,
    this.playbackPosition,
    this.totalDuration,
    this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = isUser ? Colors.white : const Color(0xFF1D2873);
    final backgroundColor = isUser ? const Color(0xFF1D2873) : Colors.white;
    final borderColor = isUser ? Colors.transparent : const Color(0xFF1D2873);

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
        minWidth: 170,
      ),
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2873),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Play/Pause button
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D2873).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: const Color(0xFF1D2873),
                          size: 14,
                        ),
                        onPressed: isUploading ? null : onPlayPause,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Waveform
                    Expanded(
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: CustomWaveform(
                          isPlaying: isPlaying && !isUploading,
                          color: const Color(0xFF1D2873),
                          playbackPosition: playbackPosition,
                          totalDuration: totalDuration,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Duration
                    Container(
                      constraints: const BoxConstraints(minWidth: 35),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1D2873),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              if (audioTranscript != null &&
                  audioTranscript!.isNotEmpty &&
                  !isUploading) ...[
                const SizedBox(height: 8),
                Text(
                  audioTranscript!,
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryColor.withOpacity(0.9),
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ],
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  createdAt == null
                      ? ''
                      : DateFormat.jm().format(
                        DateTime.parse(createdAt!).toLocal(),
                      ),
                  style: TextStyle(
                    fontSize: 10,
                    color: primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomWaveform extends StatefulWidget {
  final bool isPlaying;
  final Color color;
  final Duration? playbackPosition;
  final Duration? totalDuration;

  const CustomWaveform({
    Key? key,
    required this.isPlaying,
    required this.color,
    this.playbackPosition,
    this.totalDuration,
  }) : super(key: key);

  @override
  State<CustomWaveform> createState() => _CustomWaveformState();
}

class _CustomWaveformState extends State<CustomWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _waveformBars = [
    0.3,
    0.7,
    0.4,
    0.9,
    0.6,
    0.8,
    0.5,
    0.7,
    0.9,
    0.4,
    0.6,
    0.8,
    0.3,
    0.9,
    0.5,
    0.7,
    0.4,
    0.8,
    0.6,
    0.9,
    0.3,
    0.7,
    0.5,
    0.8,
    0.4,
    0.9,
    0.6,
    0.7,
    0.5,
    0.8,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.isPlaying) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(CustomWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              _waveformBars.asMap().entries.map((entry) {
                final index = entry.key;
                final baseHeight = entry.value;

                // Calculate progress for visual feedback
                double progress = 0.0;
                if (widget.totalDuration != null &&
                    widget.playbackPosition != null) {
                  progress =
                      widget.playbackPosition!.inMilliseconds /
                      widget.totalDuration!.inMilliseconds;
                }

                final isActive = (index / _waveformBars.length) <= progress;

                // Animate height when playing
                double animatedHeight = baseHeight;
                if (widget.isPlaying) {
                  final animationOffset = (index * 0.1) % 1.0;
                  final animationValue =
                      (_animationController.value + animationOffset) % 1.0;
                  animatedHeight =
                      baseHeight * (0.7 + 0.3 * sin(animationValue * 2 * pi));
                }

                return Container(
                  width: 3.5,
                  height: 26 * animatedHeight,
                  decoration: BoxDecoration(
                    color:
                        isActive && widget.isPlaying
                            ? widget.color
                            : widget.color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}

class StaticWaveform extends StatefulWidget {
  final bool isPlaying;
  const StaticWaveform({Key? key, required this.isPlaying}) : super(key: key);

  @override
  State<StaticWaveform> createState() => _StaticWaveformState();
}

class _StaticWaveformState extends State<StaticWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<double> _staticBarHeights = [
    10.0,
    20.0,
    28.0,
    25.0,
    20.0,
    18.0,
    22.0,
    26.0,
    23.0,
    19.0,
    15.0,
    20.0,
    24.0,
    21.0,
    17.0,
    14.0,
    11.0,
    8.0,
    6.0,
    4.0,
    10.0,
    20.0,
    28.0,
    25.0,
    20.0,
    18.0,
    22.0,
    26.0,
    23.0,
    19.0,
    15.0,
    20.0,
    24.0,
    21.0,
    17.0,
    14.0,
    11.0,
    8.0,
    6.0,
    4.0,
  ];
  late List<double> _animatedBarHeights;
  late List<double> _phases;
  late List<double> _frequencies;
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    _animatedBarHeights = List.from(_staticBarHeights);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _phases = List.generate(
      _staticBarHeights.length,
      (_) => _random.nextDouble() * 2 * pi,
    );
    _frequencies = List.generate(
      _staticBarHeights.length,
      (_) => _random.nextDouble() * 0.5 + 0.5,
    );

    _controller.addListener(() {
      setState(() {
        _time += 0.03;
        for (int i = 0; i < _animatedBarHeights.length; i++) {
          final sinValue = sin(_phases[i] + _time * _frequencies[i]);
          final normalizedSin = (sinValue + 1) / 2;
          _animatedBarHeights[i] = (normalizedSin * 25) + 5;
        }
      });
    });

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(StaticWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barHeights =
        widget.isPlaying ? _animatedBarHeights : _staticBarHeights;
    const barWidth = 2.5;

    return SizedBox(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          barHeights.length,
          (index) => Container(
            width: barWidth,
            height: barHeights[index],
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isUser;
  final String imageUrl;
  final String caption;
  final bool isUploading;
  final String? createdAt;

  const ImageMessageBubble({
    Key? key,
    required this.isUser,
    required this.imageUrl,
    required this.caption,
    this.isUploading = false,
    this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
        minWidth: 170,
      ),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF1D2873) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUser ? Colors.transparent : const Color(0xFF1D2873),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    '/image-viewer',
                    arguments: {'imageUrl': imageUrl, 'caption': caption},
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xFF1D2873),
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              LucideIcons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (caption.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caption,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isUser ? Colors.white : const Color(0xFF1D2873),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          createdAt == null
                              ? ''
                              : DateFormat.jm().format(
                                DateTime.parse(createdAt!).toLocal(),
                              ),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isUser
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class VideoMessageBubble extends StatefulWidget {
  final bool isUser;
  final String videoUrl;
  final String caption;
  final bool isUploading;
  final String? createdAt;

  const VideoMessageBubble({
    Key? key,
    required this.isUser,
    required this.videoUrl,
    required this.caption,
    this.isUploading = false,
    this.createdAt,
  }) : super(key: key);

  @override
  State<VideoMessageBubble> createState() => _VideoMessageBubbleState();
}

class _VideoMessageBubbleState extends State<VideoMessageBubble> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isNotEmpty) {
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
              });
            }
          })
          .catchError((error) {
            print('Error initializing video: $error');
          });

    _controller?.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller?.value.isPlaying ?? false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
        _startHideControlsTimer();
      }
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    if (_isPlaying) {
      _startHideControlsTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
        minWidth: 170,
      ),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: widget.isUser ? const Color(0xFF1D2873) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isUser ? Colors.transparent : const Color(0xFF1D2873),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.black,
                  child:
                      _isInitialized && _controller != null
                          ? GestureDetector(
                            onTap: _showControlsTemporarily,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                ),
                                if (_showControls || !_isPlaying)
                                  GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                          : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Icon(
                                    LucideIcons.video,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (widget.videoUrl.isNotEmpty)
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              else
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                ),
              ),
              if (widget.caption.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.caption,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.isUser
                                  ? Colors.white
                                  : const Color(0xFF1D2873),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.createdAt == null
                              ? ''
                              : DateFormat.jm().format(
                                DateTime.parse(widget.createdAt!).toLocal(),
                              ),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                widget.isUser
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (widget.isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DocumentMessageBubble extends StatelessWidget {
  final bool isUser;
  final String fileName;
  final String caption;
  final bool isUploading;
  final String? fileUrl;
  final String? createdAt;

  const DocumentMessageBubble({
    Key? key,
    required this.isUser,
    required this.fileName,
    required this.caption,
    this.isUploading = false,
    this.fileUrl,
    this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/document-viewer',
          arguments: {
            'fileName': fileName,
            'caption': caption,
            'fileUrl': fileUrl ?? '',
          },
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
          minWidth: 170,
        ),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF1D2873) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUser ? Colors.transparent : const Color(0xFF1D2873),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (isUser ? Colors.white : const Color(0xFF1D2873))
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        LucideIcons.fileText,
                        size: 20,
                        color: isUser ? Colors.white : const Color(0xFF1D2873),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fileName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              isUser ? Colors.white : const Color(0xFF1D2873),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isUser
                              ? Colors.white.withOpacity(0.9)
                              : const Color(0xFF1D2873).withOpacity(0.8),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    createdAt == null
                        ? ''
                        : DateFormat.jm().format(
                          DateTime.parse(createdAt!).toLocal(),
                        ),
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          isUser ? Colors.white.withOpacity(0.7) : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if (isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AudioRecordingPreview extends StatelessWidget {
  final String duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSend;
  final VoidCallback onCancel;

  const AudioRecordingPreview({
    Key? key,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSend,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1D2873).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
                size: 20,
              ),
              onPressed: onCancel,
            ),
          ),
          const SizedBox(width: 12),

          // Play/Pause button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1D2873).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: const Color(0xFF1D2873),
                size: 20,
              ),
              onPressed: onPlayPause,
            ),
          ),
          const SizedBox(width: 12),

          // Waveform and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: CustomWaveform(
                    isPlaying: isPlaying,
                    color: const Color(0xFF1D2873),
                    playbackPosition: null,
                    totalDuration: null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1D2873),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Send button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF1D2873),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(LucideIcons.send, color: Colors.white, size: 18),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioMessageWithTranscript extends StatelessWidget {
  final bool isUser;
  final String duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final String? audioTranscript;
  final bool isUploading;

  const AudioMessageWithTranscript({
    Key? key,
    required this.isUser,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    this.audioTranscript,
    this.isUploading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Audio player bubble
        Stack(
          children: [
            AudioMessageBubble(
              isUser: isUser,
              duration: duration,
              isPlaying: isPlaying,
              onPlayPause: onPlayPause,
              isPreview: false,
            ),
            if (isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Transcription text below audio
        if (audioTranscript != null &&
            audioTranscript!.isNotEmpty &&
            !isUploading)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  isUser
                      ? const Color(0xFF1D2873).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isUser
                        ? const Color(0xFF1D2873).withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.transcribe,
                  size: 16,
                  color: isUser ? const Color(0xFF1D2873) : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    audioTranscript!,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isUser ? const Color(0xFF1D2873) : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class Chatscreen extends StatefulWidget {
  final AuthService authService;
  const Chatscreen({super.key, required this.authService});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen>
    with WidgetsBindingObserver, EdgeToEdgeMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<Map<String, dynamic>> messages = [];
  String? conversationId;
  bool isLoading = true;
  bool isTyping = false;
  bool isWaitingForResponse = false;

  // --- Pagination & Scroll Management ---
  int currentPage = 1;
  int pageLimit = 10;
  bool hasMoreMessages = true;
  bool isLoadingMore = false;
  bool isInitialLoad = true;
  Timer? _scrollDebouncer;
  int _newlyLoadedMessageCount = 0;

  // Improved scroll state tracking
  bool _isScrolling = false;
  bool _isRestoringScroll = false;
  double? _lastScrollPosition;
  Timer? _scrollRestorationTimer;

  String selectedLanguage = 'eng'; // Default language
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  Timer? _recordingTimer;
  String _recordingDuration = "0:00";
  String? _lastRecordedPath;
  Duration _playbackPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  String? _currentlyPlayingId;

  // Text-to-speech variables
  bool _isTTSPlaying = false;
  String? _currentlyPlayingTTSId;
  Duration _ttsPlaybackPosition = Duration.zero;
  Duration _ttsDuration = Duration.zero;

  final List<Map<String, String>> languages = ([
    {'name': 'English', 'code': 'eng', 'sample': 'Hello'},
    {'name': 'Hindi', 'code': 'hin', 'sample': 'नमस्ते'},
    {'name': 'Bengali', 'code': 'ben', 'sample': 'হ্যালো'},
    {'name': 'Telugu', 'code': 'tel', 'sample': 'హలో'},
    {'name': 'Tamil', 'code': 'tam', 'sample': 'வணக்கம்'},
    {'name': 'Marathi', 'code': 'mar', 'sample': 'नमस्कार'},
    {'name': 'Kannada', 'code': 'kan', 'sample': 'ಹಲೋ'},
    {'name': 'Gujarati', 'code': 'guj', 'sample': 'નમસ્તે'},
    {'name': 'Malayalam', 'code': 'mal', 'sample': 'ഹലോ'},
    {'name': 'Assamese', 'code': 'asm', 'sample': 'নমস্কাৰ'},
  ]..sort((a, b) => a['name']!.compareTo(b['name']!)));

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _startChat();
    _setupScrollListener();

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() => _playbackPosition = position);
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() => _audioDuration = duration);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _playbackPosition = Duration.zero;
        _currentlyPlayingId = null;
        _isTTSPlaying = false;
        _ttsPlaybackPosition = Duration.zero;
        _currentlyPlayingTTSId = null;
      });
    });

    _textFieldFocus.addListener(() {
      if (_textFieldFocus.hasFocus) {
        _scrollToTop();
      }
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_isRestoringScroll || isLoadingMore)
        return; // Don't process scroll events during restoration or loading

      final position = _scrollController.position;

      // Only trigger load more when user has manually scrolled near the end
      if (position.pixels >= position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMoreMessages &&
          !isInitialLoad) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    if (isLoadingMore || !hasMoreMessages) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await widget.authService.getChatHistory(
        page: currentPage + 1,
        limit: pageLimit,
      );

      if (response['success'] == true) {
        final messagesList = response['data']['messages'] as List?;

        if (messagesList != null && messagesList.isNotEmpty) {
          final List<Map<String, dynamic>> flattenedMessages = [];
          for (var dateGroup in messagesList) {
            final messagesInDate = dateGroup['messages'] as List? ?? [];
            flattenedMessages.addAll(
              messagesInDate.cast<Map<String, dynamic>>(),
            );
          }

          // Sort the page's messages newest-to-oldest before appending
          flattenedMessages.sort(
            (a, b) => DateTime.parse(
              b['createdAt'],
            ).compareTo(DateTime.parse(a['createdAt'])),
          );

          final newMessages =
              flattenedMessages.map((msg) => _processMessage(msg)).toList();

          if (newMessages.isNotEmpty) {
            setState(() {
              messages.addAll(newMessages);
              currentPage++;
              if (flattenedMessages.length < pageLimit) {
                hasMoreMessages = false;
              }
            });
          } else {
            setState(() {
              hasMoreMessages = false;
            });
          }
        } else {
          setState(() {
            hasMoreMessages = false;
          });
        }
      }
    } catch (e) {
      print('Error loading more messages: $e');
    } finally {
      if (mounted) {
        setState(() => isLoadingMore = false);
      }
    }
  }

  Map<String, dynamic> _processMessage(Map<String, dynamic> msg) {
    // Debug: Print each message being processed
    print(
      'Processing message: ${msg['_id']}, fileType: ${msg['file']?['fileType']}, senderType: ${msg['senderType']}',
    );

    // Check if message has file data and fileType is not null
    if (msg['file'] != null &&
        msg['file']['fileType'] != null &&
        msg['file']['fileType'] != 'null' &&
        msg['file']['fileType'].toString().trim().isNotEmpty) {
      final fileData = msg['file'];
      final fileType = fileData['fileType'] as String;

      print('  -> Treating as ${fileType.toUpperCase()} message');

      if (fileType == 'audio') {
        return {
          'type': 'audio',
          'senderType': msg['senderType'],
          'conversationId': msg['conversationId'],
          'messageId': msg['_id'],
          'fileUrl': fileData['fileUrl'],
          'fileName': fileData['fileName'],
          'audioTranscript': fileData['audioTranscript'],
          'duration': '0:00',
          'durationRaw': Duration.zero,
          'isUploading': false,
          'createdAt': msg['createdAt'],
        };
      } else if (fileType == 'image') {
        return {
          'type': 'image',
          'senderType': msg['senderType'],
          'conversationId': msg['conversationId'],
          'messageId': msg['_id'],
          'fileUrl': fileData['fileUrl'],
          'fileName': fileData['fileName'],
          'caption': fileData['caption'],
          'isUploading': false,
          'createdAt': msg['createdAt'],
        };
      } else if (fileType == 'video') {
        return {
          'type': 'video',
          'senderType': msg['senderType'],
          'conversationId': msg['conversationId'],
          'messageId': msg['_id'],
          'fileUrl': fileData['fileUrl'],
          'fileName': fileData['fileName'],
          'caption': fileData['caption'],
          'isUploading': false,
          'createdAt': msg['createdAt'],
        };
      } else if (fileType == 'document') {
        return {
          'type': 'document',
          'senderType': msg['senderType'],
          'conversationId': msg['conversationId'],
          'messageId': msg['_id'],
          'fileUrl': fileData['fileUrl'],
          'fileName': fileData['fileName'],
          'caption': fileData['caption'],
          'isUploading': false,
          'createdAt': msg['createdAt'],
        };
      }
    }

    // Regular text message (file is null or fileType is null/empty)
    print('  -> Treating as TEXT message');
    final messageText = msg['text']?.toString() ?? '';

    return {
      'senderType': msg['senderType'],
      'text': messageText,
      'conversationId': msg['conversationId'],
      'messageId': msg['_id'],
      'isLiked': msg['isLiked'] ?? false,
      'isDisliked': msg['isDisliked'] ?? false,
      'createdAt': msg['createdAt'],
    };
  }

  Future<void> _initializeRecorder() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      print('Microphone permission not granted');
    }
  }

  void _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _currentlyPlayingId = null;
      });
    }

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        // Show permission error dialog
        return;
      }

      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/audio_message_$timestamp.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = "0:00";
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final duration = timer.tick;
        final minutes = duration ~/ 60;
        final seconds = duration % 60;
        setState(() {
          _recordingDuration = "$minutes:${seconds.toString().padLeft(2, '0')}";
        });
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();
      if (path == null) return;

      final player = AudioPlayer();
      await player.setSourceDeviceFile(path);
      final duration = await player.getDuration();
      await player.dispose();

      setState(() {
        _isRecording = false;
        _lastRecordedPath = path;
        _audioDuration = duration ?? Duration.zero;
        _recordingDuration = _formatDuration(_audioDuration);
      });
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  Future<void> _sendRecording() async {
    if (_lastRecordedPath == null || conversationId == null) return;

    // Store the path and duration - don't modify playback at all
    final recordedPath = _lastRecordedPath!;
    final recordedDuration = _audioDuration;

    // Add temporary message to show upload progress
    final tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      messages.insert(0, {
        'type': 'audio',
        'senderType': 'patient',
        'duration': _formatDuration(recordedDuration),
        'durationRaw': recordedDuration,
        'path': recordedPath,
        'messageId': tempMessageId,
        'isUploading': true,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _lastRecordedPath = null;
      _audioDuration = Duration.zero;
    });
    _scrollToTopAfterBuild();

    try {
      // Upload the audio file with target language
      final uploadResponse = await widget.authService.uploadMedia(
        filePath: recordedPath,
        conversationId: conversationId!,
        fileType: 'audio',
        targetLanguage: selectedLanguage,
      );

      print('Upload Response: $uploadResponse');

      if (uploadResponse['success'] == true && uploadResponse['data'] != null) {
        // Check if we have both audio message and bot response
        if (uploadResponse['data']['audioMessage'] != null &&
            uploadResponse['data']['botResponse'] != null) {
          // Handle the new structure with both audio message and bot response
          final audioData = uploadResponse['data']['audioMessage'];
          final botData = uploadResponse['data']['botResponse'];
          final fileData = audioData['file'];

          // Update the temporary audio message
          setState(() {
            final messageIndex = messages.indexWhere(
              (msg) => msg['messageId'] == tempMessageId,
            );
            if (messageIndex != -1) {
              messages[messageIndex] = {
                'type': 'audio',
                'senderType': audioData['senderType'],
                'duration': _formatDuration(recordedDuration),
                'durationRaw': recordedDuration,
                // Keep local path temporarily for continued playback until file is deleted
                'path': recordedPath,
                'messageId': audioData['_id'],
                'fileUrl': fileData['fileUrl'],
                'fileName': fileData['fileName'],
                'audioTranscript': fileData['audioTranscript'],
                'conversationId': audioData['conversationId'],
                'isUploading': false,
                'createdAt': audioData['createdAt'],
              };
            }
          });

          // Add bot response message
          setState(() {
            messages.insert(0, {
              'senderType': botData['senderType'],
              'text': botData['text'],
              'conversationId': botData['conversationId'],
              'messageId': botData['_id'],
              'isLiked': botData['isLiked'] ?? false,
              'isDisliked': botData['isDisliked'] ?? false,
              'createdAt': botData['createdAt'],
            });
          });

          _scrollToTopAfterBuild();
          print('Audio message and bot response added successfully.');
        } else {
          // Handle the old structure (just audio message)
          final data = uploadResponse['data']['message'];
          final fileData = data['file'];

          // Update the temporary message with the response data
          setState(() {
            final messageIndex = messages.indexWhere(
              (msg) => msg['messageId'] == tempMessageId,
            );
            if (messageIndex != -1) {
              messages[messageIndex] = {
                'type': 'audio',
                'senderType': data['senderType'],
                'duration': _formatDuration(recordedDuration),
                'durationRaw': recordedDuration,
                // Keep local path temporarily for continued playback until file is deleted
                'path': recordedPath,
                'messageId': data['_id'],
                'fileUrl': fileData['fileUrl'],
                'fileName': fileData['fileName'],
                'audioTranscript': fileData['audioTranscript'],
                'conversationId': data['conversationId'],
                'isUploading': false,
                'createdAt': data['createdAt'],
              };
            }
          });
          _scrollToTopAfterBuild();
          print('Audio message sent successfully (no bot response).');
        }
      } else {
        // Remove the temporary message on failure
        setState(() {
          messages.removeWhere((msg) => msg['messageId'] == tempMessageId);
        });
        print('Upload failed: ${uploadResponse['message']}');
      }
    } catch (e) {
      // Remove the temporary message on error
      setState(() {
        messages.removeWhere((msg) => msg['messageId'] == tempMessageId);
      });
      print('Error uploading audio: $e');
    }

    // Clean up the recorded file - keep it simple
    try {
      final file = File(recordedPath);
      if (await file.exists()) {
        await file.delete();
        print('Deleted local audio file after upload: $recordedPath');
      }
    } catch (e) {
      print('Error deleting uploaded file: $e');
    }
  }

  Future<void> _cancelRecordingPreview() async {
    if (_lastRecordedPath != null) {
      try {
        final file = File(_lastRecordedPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting preview file: $e');
      }
    }
    setState(() {
      _lastRecordedPath = null;
      _isPlaying = false;
      _playbackPosition = Duration.zero;
      _audioDuration = Duration.zero;
    });
  }

  Future<void> _togglePlayback(String? audioPath) async {
    if (_lastRecordedPath == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        // Set up audio source if not already set
        if (_audioPlayer.source == null) {
          await _audioPlayer.setSourceDeviceFile(_lastRecordedPath!);
        }
        await _audioPlayer.resume();
        setState(() {
          _isPlaying = true;
          _currentlyPlayingId = null; // Clear message ID for preview
        });
      }
    } catch (e) {
      print('Error in preview playback: $e');
      setState(() {
        _isPlaying = false;
        _currentlyPlayingId = null;
      });
    }
  }

  // Method to handle incoming bot messages
  void _handleIncomingBotMessage(Map<String, dynamic> messageData) {
    // Add the bot message to the chat as TEXT message (no type field)
    setState(() {
      messages.insert(0, {
        'senderType': messageData['senderType'],
        'text': messageData['text'],
        'conversationId': messageData['conversationId'],
        'messageId': messageData['_id'], // Store message ID for like/dislike
        'isLiked': messageData['isLiked'] ?? false,
        'isDisliked': messageData['isDisliked'] ?? false,
        'createdAt': messageData['createdAt'],
        // No 'type' field means it's a text message
      });
    });
    _scrollToTopAfterBuild();
  }

  // Like message function with toggle functionality
  Future<void> _likeMessage(String messageId, int messageIndex) async {
    try {
      final currentLikeState = messages[messageIndex]['isLiked'] ?? false;

      print('Current like state: $currentLikeState');
      print('Toggling like for message: $messageId');

      final response = await widget.authService.likeMessage(
        messageId: messageId,
      );

      if (response['success'] == true) {
        setState(() {
          // Toggle the like state
          messages[messageIndex]['isLiked'] = !currentLikeState;
          // If we're liking, remove dislike
          if (!currentLikeState) {
            messages[messageIndex]['isDisliked'] = false;
          }
        });

        // Show appropriate toast based on the action
        if (!currentLikeState) {
          // Message was liked
          print('Message liked successfully');
          Fluttertoast.showToast(
            msg: "Thanks For Your Feedback!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // Message was unliked
          print('Message unliked successfully');
          Fluttertoast.showToast(
            msg: "Feedback removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        print('Failed to toggle like: ${response['message']}');
        Fluttertoast.showToast(
          msg: "Failed to update feedback",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error toggling like: $e');
      Fluttertoast.showToast(
        msg: "Error occurred while updating feedback",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Dislike message function with toggle functionality
  Future<void> _dislikeMessage(String messageId, int messageIndex) async {
    try {
      final currentDislikeState = messages[messageIndex]['isDisliked'] ?? false;

      print('Current dislike state: $currentDislikeState');
      print('Toggling dislike for message: $messageId');

      final response = await widget.authService.dislikeMessage(
        messageId: messageId,
      );

      if (response['success'] == true) {
        setState(() {
          // Toggle the dislike state
          messages[messageIndex]['isDisliked'] = !currentDislikeState;
          // If we're disliking, remove like
          if (!currentDislikeState) {
            messages[messageIndex]['isLiked'] = false;
          }
        });

        // Show appropriate toast based on the action
        if (!currentDislikeState) {
          // Message was disliked
          print('Message disliked successfully');
          Fluttertoast.showToast(
            msg: "We will improve our responses",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // Message dislike was removed
          print('Message dislike removed successfully');
          Fluttertoast.showToast(
            msg: "Feedback removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        print('Failed to toggle dislike: ${response['message']}');
        Fluttertoast.showToast(
          msg: "Failed to update feedback",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error toggling dislike: $e');
      Fluttertoast.showToast(
        msg: "Error occurred while updating feedback",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _handleTTSPlayPause(Map<String, dynamic> message) async {
    final messageId = message['messageId'] as String;
    final isCurrentlyPlaying =
        messageId == _currentlyPlayingTTSId && _isTTSPlaying;

    if (isCurrentlyPlaying) {
      // Currently playing this TTS, so pause it
      await _audioPlayer.pause();
      setState(() {
        _isTTSPlaying = false;
      });
    } else if (messageId == _currentlyPlayingTTSId && !_isTTSPlaying) {
      // Currently paused this TTS, so resume it
      await _audioPlayer.resume();
      setState(() {
        _isTTSPlaying = true;
      });
    } else {
      // Playing a different TTS or starting fresh
      await _audioPlayer.stop();

      try {
        print('Getting TTS audio for message: $messageId');
        final response = await widget.authService.getAudioFromMessage(
          messageId,
        );

        if (response['success'] == true && response['data'] != null) {
          final audioData = response['data'];

          // Handle base64 audio data
          if (audioData['audioBase64'] != null) {
            final base64Audio = audioData['audioBase64'] as String;

            // Convert base64 to bytes and play
            final audioBytes = base64.decode(base64Audio);
            await _audioPlayer.setSource(BytesSource(audioBytes));

            setState(() {
              _currentlyPlayingTTSId = messageId;
              _isTTSPlaying = true;
              _ttsPlaybackPosition = Duration.zero;
            });

            await _audioPlayer.resume();

            print('TTS audio started playing for message: $messageId');
          } else {
            print('No audio data found in response');
            Fluttertoast.showToast(
              msg: "No audio available for this message",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
            );
          }
        } else {
          print('Failed to get TTS audio: ${response['message']}');
          Fluttertoast.showToast(
            msg: "Failed to get audio for this message",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        print('Error getting TTS audio: $e');
        Fluttertoast.showToast(
          msg: "Error getting audio for this message",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _handleAudioPlayPause(Map<String, dynamic> message) async {
    final audioPath = message['path'] as String?;
    final audioUrl = message['fileUrl'] as String?;

    print('Playing audio - Path: $audioPath, URL: $audioUrl');

    // Check if we have either local path or remote URL
    if (audioPath == null && audioUrl == null) {
      print('No audio source available for message: ${message['messageId']}');
      return;
    }

    final messageId = message['messageId'] as String;

    if (messageId == _currentlyPlayingId && _isPlaying) {
      // Currently playing this message, so pause it
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else if (messageId == _currentlyPlayingId && !_isPlaying) {
      // Currently paused this message, so resume it
      await _audioPlayer.resume();
      setState(() {
        _isPlaying = true;
      });
    } else {
      // Playing a different message or starting fresh
      await _audioPlayer.stop();

      try {
        // Use local path if available, otherwise use remote URL
        if (audioPath != null) {
          print('Setting audio source to local file: $audioPath');
          // Check if local file still exists
          final file = File(audioPath);
          if (await file.exists()) {
            await _audioPlayer.setSourceDeviceFile(audioPath);
          } else {
            print(
              'Local file no longer exists, switching to remote URL: $audioUrl',
            );
            if (audioUrl != null) {
              await _audioPlayer.setSourceUrl(audioUrl);
            } else {
              throw Exception('No audio source available');
            }
          }
        } else if (audioUrl != null) {
          print('Setting audio source to remote URL: $audioUrl');
          await _audioPlayer.setSourceUrl(audioUrl);
        }

        await _audioPlayer.resume();
        setState(() {
          _currentlyPlayingId = messageId;
          _isPlaying = true;
          _playbackPosition = Duration.zero;
        });
      } catch (e) {
        print('Error playing audio: $e');
        setState(() {
          _isPlaying = false;
          _currentlyPlayingId = null;
          _playbackPosition = Duration.zero;
        });
      }
    }
  }

  // Simplified scroll to top function - only used for new messages
  void _scrollToTop({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    if (animate) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
      );
    } else {
      _scrollController.jumpTo(0.0);
    }
  }

  // Only scroll to top for new messages, not for loaded old messages
  void _scrollToTopAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToTop(animate: true);
      }
    });
  }

  Future<void> _startChat() async {
    try {
      final response = await widget.authService.startChat();
      print('Chat Screen - StartChat Response: $response');

      if (response['success'] == true) {
        if (response['message'] == "Conversation already exist") {
          // Load existing conversation with pagination
          await _loadChatHistory();
        } else {
          // Handle new conversation
          if (response['data'] != null &&
              response['data']['messages'] != null) {
            final messageData = response['data']['messages'];
            setState(() {
              conversationId = messageData['conversationId'];
              messages.insert(0, {
                'senderType': messageData['senderType'],
                'text': messageData['text'],
                'conversationId': messageData['conversationId'],
                'messageId':
                    messageData['_id'], // Store message ID for like/dislike
                'isLiked': messageData['isLiked'] ?? false,
                'isDisliked': messageData['isDisliked'] ?? false,
                'createdAt': messageData['createdAt'],
              });
              isLoading = false;
              isInitialLoad = false;
            });
            // Auto scroll to top (newest message) after adding first message
            _scrollToTopAfterBuild();
          } else {
            // No initial message, just set loading to false
            setState(() {
              isLoading = false;
              isInitialLoad = false;
            });
          }
        }
      } else {
        // API call failed
        setState(() {
          isLoading = false;
          isInitialLoad = false;
        });
        print('StartChat API failed: ${response['message']}');
      }
    } catch (e) {
      print('Error starting chat: $e');
      setState(() {
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final response = await widget.authService.getChatHistory(
        page: currentPage,
        limit: pageLimit,
      );
      print('Chat Screen - History Response: $response');

      if (response['success'] == true && response['data'] != null) {
        final messagesList = response['data']['messages'] as List?;

        if (messagesList != null && messagesList.isNotEmpty) {
          final List<Map<String, dynamic>> flattenedMessages = [];
          for (var dateGroup in messagesList) {
            final messagesInDate = dateGroup['messages'] as List? ?? [];
            flattenedMessages.addAll(
              messagesInDate.cast<Map<String, dynamic>>(),
            );
          }

          // Sort all messages newest to oldest for the reversed list
          flattenedMessages.sort((a, b) {
            final aTime = DateTime.parse(a['createdAt']);
            final bTime = DateTime.parse(b['createdAt']);
            return bTime.compareTo(aTime); // DESCENDING order
          });

          setState(() {
            messages.clear();
            if (flattenedMessages.isNotEmpty) {
              conversationId = flattenedMessages[0]['conversationId'];

              final processedMessages =
                  flattenedMessages.map((msg) {
                    return _processMessage(msg);
                  }).toList();

              messages.addAll(processedMessages);

              if (flattenedMessages.length < pageLimit) {
                hasMoreMessages = false;
              }
            }
            isLoading = false;
            isInitialLoad = false;
          });

          if (messages.isNotEmpty) {
            _scrollToTopAfterBuild();
          }
        } else {
          setState(() {
            isLoading = false;
            isInitialLoad = false;
            hasMoreMessages = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          isInitialLoad = false;
        });
      }
    } catch (e) {
      print('Error loading chat history: $e');
      setState(() {
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  Future<void> _handleSend() async {
    if (_controller.text.trim().isEmpty) return;

    final message = _controller.text.trim();
    _controller.clear();

    if (conversationId == null) {
      print('No conversationId found, attempting to start new conversation');
      await _startChat();
      if (conversationId == null) {
        print('Failed to get conversationId');
        return;
      }
    }

    setState(() {
      // Insert new message at the beginning for the reversed list
      messages.insert(0, {
        'senderType': 'patient',
        'text': message,
        'conversationId': conversationId,
        'createdAt': DateTime.now().toIso8601String(),
      });
      isWaitingForResponse = true;
      isTyping = false;
    });

    _scrollToTopAfterBuild();

    try {
      final response = await widget.authService.sendMessage(
        conversationId: conversationId!,
        content: message,
        targetLanguage: selectedLanguage,
      );

      print('Send Message Response: $response');

      if (response['success'] == true && response['data'] != null) {
        final messageData = response['data']['messages'];
        setState(() {
          isWaitingForResponse = false;
        });
        // Use the new method to handle bot messages
        _handleIncomingBotMessage(messageData);
      } else {
        setState(() {
          isWaitingForResponse = false;
        });
        print('Send message failed: ${response['message']}');
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        isWaitingForResponse = false;
      });
    }
  }

  void _showAttachmentDialog(BuildContext context) {
    final picker = ImagePicker();

    Future<void> pickImage() async {
      Navigator.of(context).pop();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('Selected image path: ${pickedFile.path}');
        final result = await Get.toNamed(
          AppRoutes.imagePreviewRoute,
          arguments: {
            'imagePath': pickedFile.path,
            'conversationId': conversationId,
          },
        );

        if (result != null) {
          setState(() {
            messages.insert(0, result);
          });
          _scrollToTopAfterBuild();
        }
      }
    }

    Future<void> pickCamera() async {
      Navigator.of(context).pop();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        print('Captured image path: ${pickedFile.path}');
        final result = await Get.toNamed(
          AppRoutes.imagePreviewRoute,
          arguments: {
            'imagePath': pickedFile.path,
            'conversationId': conversationId,
          },
        );

        if (result != null) {
          setState(() {
            messages.insert(0, result);
          });
          _scrollToTopAfterBuild();
        }
      }
    }

    Future<void> pickVideo() async {
      Navigator.of(context).pop();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        final result = await Get.toNamed(
          AppRoutes.videoPreviewRoute,
          arguments: {
            'videoPath': pickedFile.path,
            'conversationId': conversationId,
          },
        );
        if (result != null) {
          setState(() {
            messages.insert(0, result);
          });
          _scrollToTopAfterBuild();
        }
      }
    }

    Future<void> pickDocument() async {
      Navigator.of(context).pop();
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
        ],
      );
      if (result != null && result.files.single.path != null) {
        final navigationResult = await Get.toNamed(
          AppRoutes.documentPreviewRoute,
          arguments: {
            'filePath': result.files.single.path!,
            'conversationId': conversationId,
          },
        );
        if (navigationResult != null) {
          setState(() {
            messages.insert(0, navigationResult);
          });
          _scrollToTopAfterBuild();
        }
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Attachment Dialog",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              alignment: Alignment.bottomCenter,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.only(
                bottom: 90,
                left: 16,
                right: 16,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF1D2873),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.start,
                  children: [
                    _buildDialogIcon(
                      icon: LucideIcons.image,
                      onPressed: pickImage,
                    ),
                    _buildDialogIcon(
                      icon: LucideIcons.camera,
                      onPressed: pickCamera,
                    ),
                    _buildDialogIcon(
                      icon: LucideIcons.video,
                      onPressed: pickVideo,
                    ),
                    _buildDialogIcon(
                      icon: LucideIcons.headphones,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    _buildDialogIcon(
                      icon: LucideIcons.fileText,
                      onPressed: pickDocument,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogIcon({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: chatIconColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1D2873), width: 1),
        ),
        child: Icon(icon, size: 24, color: AppColors.primaryColor),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'Select Language',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...languages.map((lang) {
                            final isSelected = selectedLanguage == lang['code'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLanguage = lang['code']!;
                                });
                                setModalState(() {
                                  selectedLanguage = lang['code']!;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primaryColor.withOpacity(
                                            0.15,
                                          )
                                          : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.language,
                                      color:
                                          isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lang['name']!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  isSelected
                                                      ? Theme.of(
                                                        context,
                                                      ).primaryColor
                                                      : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${lang['sample'] ?? 'Hello'}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color:
                                          isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textFieldFocus.dispose();
    _controller.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    _scrollDebouncer?.cancel();
    _scrollRestorationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 20,
        title: CustomImageView(imagePath: ImageConstant.appIconSvg),
        actions: [
          InkWell(
            onTap: _showLanguagePicker,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (_) {
                      final selected = languages.firstWhere(
                        (lang) => lang['code'] == selectedLanguage,
                        orElse: () => {'name': 'Language', 'sample': ''},
                      );
                      return Text(
                        '${selected['name']}',
                        style: const TextStyle(
                          color: Color(0xFF1D2873),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF1D2873),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        bottom:
            isLoadingMore
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(2),
                  child: Container(
                    height: 2,
                    child: const LinearProgressIndicator(
                      color: Color(0xFF1D2873),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                )
                : null,
      ),
      // This ensures the keyboard doesn't cover the content
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              "Today · 11:18 PM",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1D2873),
                        ),
                      )
                      : messages.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Start a conversation!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Send a message to begin chatting',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Stack(
                          children: [
                            ListView.builder(
                              controller: _scrollController,
                              reverse: true, // Key change for chat behavior
                              padding: EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 16,
                                bottom: isWaitingForResponse ? 80 : 16,
                              ),
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              shrinkWrap: false,
                              cacheExtent:
                                  500, // Optimized cache for smooth scrolling without memory overhead
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isUser =
                                    message['senderType'] == 'patient';

                                // Animate newly appended (older) messages
                                final isNewlyLoaded =
                                    index >=
                                    (messages.length -
                                        _newlyLoadedMessageCount);

                                // The actual message bubble widget is built here
                                Widget messageWidget = Align(
                                  alignment:
                                      isUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        isUser
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: [
                                      if (!isUser)
                                        CircleAvatar(
                                          backgroundColor: const Color(
                                            0xFF1D2873,
                                          ),
                                          radius: 16,
                                          child: const Text(
                                            'B',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      if (!isUser) const SizedBox(width: 8),
                                      Flexible(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.8,
                                            minWidth: 100.0,
                                          ),
                                          child: IntrinsicWidth(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: isUser ? 20 : 0,
                                                    right: isUser ? 0 : 20,
                                                    top: 6,
                                                    bottom: 6,
                                                  ),
                                                  child: Builder(
                                                    builder: (context) {
                                                      // Dynamically build the correct message bubble based on type
                                                      if (message['type'] ==
                                                          'audio') {
                                                        final isCurrentlyPlaying =
                                                            message['messageId'] ==
                                                            _currentlyPlayingId;
                                                        String displayDuration;
                                                        final totalDuration =
                                                            message['durationRaw']
                                                                as Duration?;

                                                        if (isCurrentlyPlaying &&
                                                            _isPlaying) {
                                                          displayDuration =
                                                              _formatDuration(
                                                                _playbackPosition,
                                                              );
                                                        } else {
                                                          displayDuration =
                                                              message['duration']
                                                                  as String? ??
                                                              _formatDuration(
                                                                totalDuration ??
                                                                    Duration
                                                                        .zero,
                                                              );
                                                        }

                                                        return ModernAudioPlayer(
                                                          isUser: isUser,
                                                          duration:
                                                              displayDuration,
                                                          isPlaying:
                                                              isCurrentlyPlaying &&
                                                              _isPlaying,
                                                          onPlayPause:
                                                              () =>
                                                                  _handleAudioPlayPause(
                                                                    message,
                                                                  ),
                                                          audioTranscript:
                                                              message['audioTranscript']
                                                                  as String?,
                                                          isUploading:
                                                              message['isUploading'] ==
                                                              true,
                                                          playbackPosition:
                                                              isCurrentlyPlaying
                                                                  ? _playbackPosition
                                                                  : null,
                                                          totalDuration:
                                                              totalDuration,
                                                          createdAt:
                                                              message['createdAt'],
                                                        );
                                                      } else if (message['type'] ==
                                                          'image') {
                                                        return ImageMessageBubble(
                                                          isUser: isUser,
                                                          imageUrl:
                                                              message['fileUrl'] ??
                                                              '',
                                                          caption:
                                                              message['caption'] ??
                                                              '',
                                                          isUploading:
                                                              message['isUploading'] ==
                                                              true,
                                                          createdAt:
                                                              message['createdAt'],
                                                        );
                                                      } else if (message['type'] ==
                                                          'video') {
                                                        return VideoMessageBubble(
                                                          isUser: isUser,
                                                          videoUrl:
                                                              message['fileUrl'] ??
                                                              '',
                                                          caption:
                                                              message['caption'] ??
                                                              '',
                                                          isUploading:
                                                              message['isUploading'] ==
                                                              true,
                                                          createdAt:
                                                              message['createdAt'],
                                                        );
                                                      } else if (message['type'] ==
                                                          'document') {
                                                        return DocumentMessageBubble(
                                                          isUser: isUser,
                                                          fileName:
                                                              message['fileName'] ??
                                                              '',
                                                          caption:
                                                              message['caption'] ??
                                                              '',
                                                          fileUrl:
                                                              message['fileUrl'],
                                                          isUploading:
                                                              message['isUploading'] ==
                                                              true,
                                                          createdAt:
                                                              message['createdAt'],
                                                        );
                                                      } else {
                                                        // This is a standard text message
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                isUser
                                                                    ? const Color(
                                                                      0xFF1D2873,
                                                                    )
                                                                    : Colors
                                                                        .white,
                                                            border: Border.all(
                                                              color:
                                                                  isUser
                                                                      ? Colors
                                                                          .transparent
                                                                      : const Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (isUser)
                                                                Text(
                                                                  message['text'] ??
                                                                      'No content',
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                )
                                                              else
                                                                MarkdownBody(
                                                                  data:
                                                                      message['text'] ??
                                                                      'No content',
                                                                  styleSheet: MarkdownStyleSheet(
                                                                    p: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    h1: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                      fontSize:
                                                                          24,
                                                                    ),
                                                                    h2: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                    h3: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                    strong: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                    ),
                                                                    em: const TextStyle(
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                    ),
                                                                    code: TextStyle(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      color: const Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                      fontFamily:
                                                                          'monospace',
                                                                    ),
                                                                    codeblockDecoration: BoxDecoration(
                                                                      color:
                                                                          Colors
                                                                              .grey[100],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                      border: Border.all(
                                                                        color:
                                                                            Colors.grey[300]!,
                                                                      ),
                                                                    ),
                                                                    blockquote: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .grey[600],
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                    blockquoteDecoration: BoxDecoration(
                                                                      color:
                                                                          Colors
                                                                              .grey[50],
                                                                      border: const Border(
                                                                        left: BorderSide(
                                                                          color: Color(
                                                                            0xFF1D2873,
                                                                          ),
                                                                          width:
                                                                              4,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    listBullet: const TextStyle(
                                                                      color: Color(
                                                                        0xFF1D2873,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  selectable:
                                                                      true,
                                                                ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const SizedBox.shrink(),
                                                                  Text(
                                                                    message['createdAt'] ==
                                                                            null
                                                                        ? ''
                                                                        : DateFormat.jm().format(
                                                                          DateTime.parse(
                                                                            message['createdAt'],
                                                                          ).toLocal(),
                                                                        ),
                                                                    style: CustomTextStyles.medium.copyWith(
                                                                      color:
                                                                          isUser
                                                                              ? Colors.white.withOpacity(
                                                                                0.7,
                                                                              )
                                                                              : Colors.grey,
                                                                      fontSize:
                                                                          11.0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                // Like/Dislike buttons for bot messages
                                                if (!isUser &&
                                                    message['messageId'] !=
                                                        null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8,
                                                          left: 8,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap:
                                                              () => _likeMessage(
                                                                message['messageId']!,
                                                                index,
                                                              ),
                                                          child:
                                                              message['isLiked'] ==
                                                                      true
                                                                  ? CustomImageView(
                                                                    imagePath:
                                                                        ImageConstant
                                                                            .likeIcon,
                                                                    height: 20,
                                                                    width: 20,
                                                                  )
                                                                  : const Icon(
                                                                    LucideIcons
                                                                        .thumbsUp,
                                                                    size: 20,
                                                                    color: Color(
                                                                      0xFF1D2873,
                                                                    ),
                                                                  ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        GestureDetector(
                                                          onTap:
                                                              () => _dislikeMessage(
                                                                message['messageId']!,
                                                                index,
                                                              ),
                                                          child:
                                                              message['isDisliked'] ==
                                                                      true
                                                                  ? CustomImageView(
                                                                    imagePath:
                                                                        ImageConstant
                                                                            .dislikeIcon,
                                                                    height: 20,
                                                                    width: 20,
                                                                  )
                                                                  : const Icon(
                                                                    LucideIcons
                                                                        .thumbsDown,
                                                                    size: 20,
                                                                    color: Color(
                                                                      0xFF1D2873,
                                                                    ),
                                                                  ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        // Text-to-Speech button
                                                        GestureDetector(
                                                          onTap:
                                                              () =>
                                                                  _handleTTSPlayPause(
                                                                    message,
                                                                  ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  message['messageId'] ==
                                                                              _currentlyPlayingTTSId &&
                                                                          _isTTSPlaying
                                                                      ? const Color(
                                                                        0xFF1D2873,
                                                                      ).withOpacity(
                                                                        0.1,
                                                                      )
                                                                      : Colors
                                                                          .transparent,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    6,
                                                                  ),
                                                            ),
                                                            child: Icon(
                                                              message['messageId'] ==
                                                                          _currentlyPlayingTTSId &&
                                                                      _isTTSPlaying
                                                                  ? Icons
                                                                      .volume_up
                                                                  : Icons
                                                                      .volume_up_outlined,
                                                              size: 20,
                                                              color:
                                                                  message['messageId'] ==
                                                                              _currentlyPlayingTTSId &&
                                                                          _isTTSPlaying
                                                                      ? const Color(
                                                                        0xFF1D2873,
                                                                      )
                                                                      : const Color(
                                                                        0xFF1D2873,
                                                                      ).withOpacity(
                                                                        0.7,
                                                                      ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                // Conditionally wrap the message widget with an animation for newly loaded items
                                if (isNewlyLoaded) {
                                  return TweenAnimationBuilder<double>(
                                    key: ValueKey(message['messageId']),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset: Offset(
                                            0,
                                            -40 * (1 - value),
                                          ), // Animate from top
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: messageWidget,
                                  );
                                } else {
                                  return messageWidget;
                                }
                              },
                            ),
                            if (isWaitingForResponse)
                              const Positioned(
                                bottom: 0,
                                left: 0,
                                child: TypingIndicator(),
                              ),

                            // Floating Quick Suggestions Button
                            if (messages.isNotEmpty)
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: Tooltip(
                                  message: 'Quick Suggestions',
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      _showQuickSuggestionsDialog(context);
                                    },
                                    backgroundColor: const Color(0xFF1D2873),
                                    foregroundColor: Colors.white,
                                    elevation: 8,
                                    child: const Icon(
                                      Icons.lightbulb_outline,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: _buildBottomInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInput() {
    if (_isRecording) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Recording indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _recordingDuration,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: SizedBox(
                height: 24,
                child: CustomWaveform(
                  isPlaying: true,
                  color: Colors.red,
                  playbackPosition: null,
                  totalDuration: null,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Stop recording button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.stop_rounded,
                  color: Colors.red,
                  size: 24,
                ),
                onPressed: _stopRecording,
              ),
            ),
          ],
        ),
      );
    } else if (_lastRecordedPath != null) {
      String displayDuration;
      if (_isPlaying) {
        displayDuration = _formatDuration(_playbackPosition);
      } else {
        displayDuration = _formatDuration(_audioDuration);
      }

      return AudioRecordingPreview(
        duration: displayDuration,
        isPlaying: _isPlaying,
        onPlayPause: () => _togglePlayback(_lastRecordedPath),
        onSend: _sendRecording,
        onCancel: _cancelRecordingPreview,
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1D2873), width: 1.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _textFieldFocus,
                      onChanged: (text) {
                        setState(() {
                          isTyping = text.trim().isNotEmpty;
                        });
                      },
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 400), () {
                          _scrollToTop();
                        });
                      },
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (isTyping) {
                          _handleSend();
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        hintText: 'Type your question here',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      LucideIcons.paperclip,
                      color: Color(0xFF1D2873),
                    ),
                    onPressed: () {
                      _showAttachmentDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1D2873),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                isTyping ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onPressed: isTyping ? _handleSend : _startRecording,
            ),
          ),
        ],
      );
    }
  }

  // Handle FAQ button taps - auto-send the FAQ text
  Future<void> _handleFaqTap(String faqText) async {
    if (conversationId == null) {
      print('No conversationId found, attempting to start new conversation');
      await _startChat();
      if (conversationId == null) {
        print('Failed to get conversationId');
        return;
      }
    }

    setState(() {
      // Insert new message at the beginning for the reversed list
      messages.insert(0, {
        'senderType': 'patient',
        'text': faqText,
        'conversationId': conversationId,
        'createdAt': DateTime.now().toIso8601String(),
      });
      isWaitingForResponse = true;
      isTyping = false;
    });

    _scrollToTopAfterBuild();

    try {
      final response = await widget.authService.sendMessage(
        conversationId: conversationId!,
        content: faqText,
        targetLanguage: selectedLanguage,
      );

      print('FAQ Send Message Response: $response');

      if (response['success'] == true && response['data'] != null) {
        final messageData = response['data']['messages'];
        setState(() {
          isWaitingForResponse = false;
        });
        // Use the new method to handle bot messages
        _handleIncomingBotMessage(messageData);
      } else {
        setState(() {
          isWaitingForResponse = false;
        });
        print('FAQ send message failed: ${response['message']}');
      }
    } catch (e) {
      print('Error sending FAQ message: $e');
      setState(() {
        isWaitingForResponse = false;
      });
    }
  }

  // Build FAQ category with modern UI
  Widget _buildFaqCategory(
    String title,
    List<String> questions,
    IconData icon,
    Color categoryColor, {
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: categoryColor.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: categoryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                ),
              ],
            ),
          ),
          // Questions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children:
                  questions.map((question) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Close the dialog first
                            Navigator.of(context).pop();
                            // Then send the FAQ message
                            _handleFaqTap(question);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    question,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Show Quick Suggestions Dialog
  void _showQuickSuggestionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D2873), Color(0xFF4A90E2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Quick Suggestions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Tap any question below to get instant help:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // FAQ Categories
                        _buildFaqCategory(
                          'Appointments',
                          [
                            'How can I book an appointment?',
                            'Can I reschedule or cancel my appointment?',
                          ],
                          Icons.calendar_today,
                          const Color(0xFF4CAF50),
                          context: context,
                        ),
                        const SizedBox(height: 16),

                        _buildFaqCategory(
                          'Medical Services',
                          [
                            'How do I access my medical reports?',
                            'Can I consult a doctor online?',
                          ],
                          Icons.medical_services,
                          const Color(0xFF2196F3),
                          context: context,
                        ),
                        const SizedBox(height: 16),

                        _buildFaqCategory(
                          'Account & Safety',
                          [
                            'How do I update my health details?',
                            'Is my medical data safe?',
                            'What should I do in case of emergency?',
                          ],
                          Icons.security,
                          const Color(0xFFFF9800),
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

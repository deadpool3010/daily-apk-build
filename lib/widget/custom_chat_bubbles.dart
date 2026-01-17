import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

class ChatBubblePdf extends StatefulWidget {
  final String fileName;
  final String? fileUrl;
  final String? caption;
  final String? fileSize;
  final bool isLoading; // Show loading state until response received

  const ChatBubblePdf({
    super.key,
    required this.fileName,
    this.fileUrl,
    this.caption,
    this.fileSize,
    this.isLoading = false,
  });

  @override
  State<ChatBubblePdf> createState() => _ChatBubblePdfState();
}

class _ChatBubblePdfState extends State<ChatBubblePdf> {
  PdfController? _pdfController;
  bool _loadingPreview = false;
  String? _previewError;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void didUpdateWidget(ChatBubblePdf oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload preview if fileUrl changed
    if (oldWidget.fileUrl != widget.fileUrl) {
      _loadPreview();
    }
  }

  Future<void> _loadPreview() async {
    if (widget.fileUrl == null) return;
    setState(() {
      _loadingPreview = true;
      _previewError = null;
    });
    try {
      final resp = await http.get(Uri.parse(widget.fileUrl!));
      if (resp.statusCode == 200) {
        final docFuture = PdfDocument.openData(resp.bodyBytes);
        _pdfController?.dispose();
        _pdfController = PdfController(document: docFuture);
      } else {
        _previewError = 'Preview unavailable';
      }
    } catch (e) {
      _previewError = 'Preview unavailable';
    } finally {
      if (mounted) {
        setState(() {
          _loadingPreview = false;
        });
      }
    }
  }

  Future<void> _downloadFile(String url) async {
    try {
      // TODO: Implement file download/opening
      // For now, just print the URL
      print('Opening file: $url');
      // You can use url_launcher package here if needed
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Color(0xff3865FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(0),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // White container with documentation
              Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Documentation content
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fileName,
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          _buildPreview(),
                          const SizedBox(height: 8),
                          Container(
                            height: 3,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // PDF blue bar at bottom of white container
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E4DB7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          // PDF icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "PDF",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // File info text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.fileName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  widget.fileSize != null &&
                                          widget.fileSize!.isNotEmpty
                                      ? "PDF • ${widget.fileSize}"
                                      : "PDF",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Download icon
                          if (widget.fileUrl != null)
                            GestureDetector(
                              onTap: () => _downloadFile(widget.fileUrl!),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Blue message text below (caption)
              if (widget.caption != null && widget.caption!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.caption!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
          // Loading overlay with blur
          if (widget.isLoading || (widget.fileUrl == null && !_loadingPreview))
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF3865FF),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final double containerWidth = constraints.maxWidth;

          if (_loadingPreview) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (_previewError != null) {
            return _PreviewPlaceholder(text: _previewError!);
          }

          if (_pdfController == null) {
            return const _PreviewPlaceholder(text: 'Preview unavailable');
          }

          return PdfView(
            controller: _pdfController!,
            scrollDirection: Axis.horizontal,
            pageSnapping: false,
            physics: const NeverScrollableScrollPhysics(),

            // 🔥 IMPORTANT: now we pass the real container size
            // renderer: (page) => _render(page, containerWidth, 140),
            builders: PdfViewBuilders<DefaultBuilderOptions>(
              options: const DefaultBuilderOptions(),
              documentLoaderBuilder: (_) => const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              pageLoaderBuilder: (_) => const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  final String text;

  const _PreviewPlaceholder({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
    );
  }
}

class AudioChatBubble extends StatefulWidget {
  final String? audioUrl;
  final String? audioTranscript;
  final String? profileImageUrl;
  final bool isLoading;

  const AudioChatBubble({
    super.key,
    this.audioUrl,
    this.audioTranscript,
    this.profileImageUrl,
    this.isLoading = false,
  });

  @override
  State<AudioChatBubble> createState() => _AudioChatBubbleState();
}

class _AudioChatBubbleState extends State<AudioChatBubble> {
  bool _isPlaying = false;
  bool _isLoading = true;
  PlayerController? _playerController;
  bool _hasWaveform = false;
  int _currentDuration = 0;
  int _totalDuration = 0;
  String? _localAudioPath; // Store local path for re-preparing

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
      _loadWaveform();
    } else {
      _isLoading = false;
    }
  }

  @override
  void didUpdateWidget(AudioChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reload if audioUrl actually changed and we haven't loaded yet
    if (widget.audioUrl != oldWidget.audioUrl) {
      if (widget.audioUrl != null &&
          widget.audioUrl!.isNotEmpty &&
          !_hasWaveform) {
        // Only reload if we haven't successfully loaded yet
        _loadWaveform();
      } else if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
        // If URL was removed, reset state
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasWaveform = false;
          });
        }
      }
      // If URL is the same, don't reload - preserve current state
    }
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  Future<void> _loadWaveform() async {
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    // Skip invalid file paths like 'cc' that cause ExoPlayer errors
    if (widget.audioUrl == 'cc' || widget.audioUrl!.length < 3) {
      print('Invalid audio URL: ${widget.audioUrl}');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      // Check if it's a local file path or a URL
      final String localPath;
      if (widget.audioUrl!.startsWith('http://') ||
          widget.audioUrl!.startsWith('https://')) {
        // It's a URL, download it
        localPath = await _downloadAudio(widget.audioUrl!);
      } else {
        // It's a local file path, verify it exists
        final file = File(widget.audioUrl!);
        if (await file.exists()) {
          localPath = widget.audioUrl!;
        } else {
          print('Local audio file does not exist: ${widget.audioUrl}');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        }
      }
      _localAudioPath = localPath; // Store for later use
      await _playerController!.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
        noOfSamples: 150,
      );

      // Listen to duration changes for progress
      _playerController!.onCurrentDurationChanged.listen((duration) {
        if (mounted) {
          setState(() {
            _currentDuration = duration;
            // Check if audio finished
            if (_totalDuration > 0 && duration >= _totalDuration) {
              _isPlaying = false; // Show play button when finished
              _currentDuration = _totalDuration; // Keep progress at end
            }
          });
        }
      });

      // Listen to player state changes
      _playerController!.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state == PlayerState.playing;
            // When playback stops and we're at the end, ensure play button shows
            if (state == PlayerState.stopped &&
                _totalDuration > 0 &&
                _currentDuration >= _totalDuration) {
              _isPlaying = false;
              _currentDuration = _totalDuration; // Ensure progress stays at end
            }
          });
        }
      });

      // Get total duration
      final duration = await _playerController!.getDuration(DurationType.max);
      if (mounted) {
        setState(() {
          _totalDuration = duration;
          _hasWaveform = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading waveform: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _downloadAudio(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      // Extract filename from URL, use a safe default if extraction fails
      String fileName = url.split('/').last;
      if (fileName.isEmpty || !fileName.contains('.')) {
        // Generate a unique filename if extraction fails
        fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      }
      final filePath = "${dir.path}/$fileName";

      print('Downloading audio from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to download audio: ${response.statusCode}');
      }

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('Audio downloaded to: $filePath');
      return filePath;
    } catch (e) {
      print('Error downloading audio: $e');
      rethrow;
    }
  }

  void _togglePlayPause() async {
    if (_playerController == null || !_hasWaveform) return;

    try {
      final currentState = await _playerController!.playerState; //
      print('Current player state: $currentState, _isPlaying: $_isPlaying');

      if (currentState == PlayerState.playing) {
        // Currently playing, so pause
        await _playerController!.pausePlayer();
      } else {
        // Not playing - check if player is stopped and needs re-preparation
        if (currentState == PlayerState.stopped) {
          // Player is stopped, need to re-prepare
          if (_localAudioPath != null) {
            print('Player stopped, re-preparing...');
            await _playerController!.preparePlayer(
              path: _localAudioPath!,
              shouldExtractWaveform: false, // Already extracted
              noOfSamples: 150,
            );
            print('Player re-prepared');
          }
        }

        // Check if at the end
        if (_totalDuration > 0 && _currentDuration >= _totalDuration) {
          // At the end, restart from beginning
          print('Audio finished, restarting from beginning');
          await _playerController!.seekTo(0);
          if (mounted) {
            setState(() {
              _currentDuration = 0; // Reset progress
            });
          }
          // Small delay to ensure seek completes
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Start playback
        print('Starting player...');
        await _playerController!.startPlayer();
        print('Player started');
      }
      // State will be updated by onPlayerStateChanged listener
    } catch (e, stackTrace) {
      print('Error toggling playback: $e');
      print('Stack trace: $stackTrace');
      // Fallback: manually update state if listener fails
      if (mounted) {
        setState(() {
          _isPlaying = !_isPlaying;
        });
      }
    }
  }

  Widget _buildWaveformWithProgress() {
    final progress = _totalDuration > 0
        ? _currentDuration / _totalDuration
        : 0.0;

    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Stack(
        children: [
          // Full waveform in light color (background/inactive)
          AudioFileWaveforms(
            animationCurve: Curves.easeInOut,
            continuousWaveform: true,
            size: Size(MediaQuery.of(context).size.width, 40),
            playerController: _playerController!,
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
                size: Size(MediaQuery.of(context).size.width, 40),
                playerController: _playerController!,
                waveformType: WaveformType.fitWidth, // Same static waveform
                playerWaveStyle: PlayerWaveStyle(
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Color(0xff3865FF),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(0),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Audio Player Section
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E4DB7), // Darker blue for player
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile Picture
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                image: widget.profileImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          widget.profileImageUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: widget.profileImageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : null,
                            ),
                            // Microphone icon overlay
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.mic,
                                  color: Color(0xFF3865FF),
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Play/Pause Button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 0),
                      // Audio Waveform
                      Expanded(
                        child: _isLoading
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
                            : _hasWaveform && _playerController != null
                            ? _buildWaveformWithProgress()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              // Transcription Section
              if (widget.audioTranscript != null &&
                  widget.audioTranscript!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Transcription",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.audioTranscript!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          // Loading overlay with blur
          // Only show loading if we don't have a valid audioUrl yet
          // If audioUrl is present, waveform loading happens in background without overlay
          // if ((widget.isLoading &&
          //         (widget.audioUrl == null || widget.audioUrl!.isEmpty)) ||
          //     (_isLoading && widget.audioUrl == null))
          //   Positioned.fill(
          //     child: ClipRRect(
          //       borderRadius: const BorderRadius.only(
          //         bottomLeft: Radius.circular(20),
          //         bottomRight: Radius.circular(20),
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(0),
          //       ),
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          //         child: Container(
          //           color: Colors.white.withOpacity(0.3),
          //           child: const Center(
          //             child: CircularProgressIndicator(
          //               strokeWidth: 2,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

// Future<PdfPageImage?> _render(PdfPage page) async {
//   // final double previewHeight = 140; // your container
//   final double cropHeight = page.height * 0.25; // top 25%

//   return page.render(
//     width: page.width, // keep full width (no scaling)
//     height: cropHeight, // crop only top part
//     format: PdfPageImageFormat.jpeg,
//     backgroundColor: '#FFFFFF',

//     // Crop TOP part of the page
//     cropRect: Rect.fromLTWH(
//       10,
//       50,
//       100,
//       100,
//       // cropped height
//     ),
//   );
// }

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

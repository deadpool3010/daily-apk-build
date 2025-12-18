import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bandhucare_new/presentation/chat_screen/controller/chat_screeen_controller.dart';
import 'package:bandhucare_new/widget/add_media_chat_screen_bottomsheet.dart';
import 'package:bandhucare_new/widget/selected_pdf_in_chat_bottom.dart';
import 'package:bandhucare_new/widget/audio_waveform_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatScreenBottom extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String, {File? file, String? fileType}) onSend;

  const ChatScreenBottom({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  @override
  State<ChatScreenBottom> createState() => _ChatScreenBottomState();
}

class _ChatScreenBottomState extends State<ChatScreenBottom>
    with SingleTickerProviderStateMixin {
  bool _hasText = false;
  File? _selectedPdfFile;
  String? _pdfFileName;
  String? _pdfFileSize;
  final GlobalKey<AudioWaveformWidgetState> _audioWaveformKey =
      GlobalKey<AudioWaveformWidgetState>();
  bool _isRecording = false;

  bool _isCancelledBySwipe = false;
  double _startY = 0.0;

  // Animation variables for pulsing arrow
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulsePosition;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _pulseScale = Tween(begin: 0.8, end: 1.2).animate(_pulseController);
    _pulsePosition = Tween(begin: 0.0, end: 15.0).animate(_pulseController);

    widget.messageController.addListener(() {
      final hasTextNow = widget.messageController.text.trim().isNotEmpty;
      if (hasTextNow != _hasText) {
        setState(() => _hasText = hasTextNow);
      }
    });
  }

  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        setState(() {
          _selectedPdfFile = file;
          _pdfFileName = fileName;
          _pdfFileSize = _formatFileSize(fileSize);
        });
      }
    } catch (e) {
      print('Error picking PDF file: $e');
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  void _removePdfFile() {
    setState(() {
      _selectedPdfFile = null;
      _pdfFileName = null;
      _pdfFileSize = null;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check keyboard visibility using MediaQuery (no setState needed)
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardOpen = keyboardHeight > 0;
    final bool hasPdf =
        _selectedPdfFile != null &&
        _pdfFileName != null &&
        _pdfFileSize != null;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 0, 16, isKeyboardOpen ? 10 : 30),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            // LEFT CIRCLE PLUS BUTTON (Translucent)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    barrierColor: Colors.black.withOpacity(0.5),
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: AddMediaChatScreenBottomSheet(
                        onDocumentSelected: _pickPdfFile,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 26,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // TEXT FIELD + SEND BUTTON (Translucent iOS-style)
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 50,
                      maxHeight: 300,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.30),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: hasPdf ? 8 : 0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasPdf && !_isRecording)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    8,
                                  ),
                                  child: SelectedPdfFile(
                                    fileName: _pdfFileName!,
                                    fileSize: _pdfFileSize!,
                                    onDelete: _removePdfFile,
                                  ),
                                ),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _isRecording
                                          ? SizedBox(
                                              height: 50,
                                              child: AudioWaveformWidget(
                                                key: _audioWaveformKey,
                                                onRecordingStarted: () =>
                                                    setState(
                                                      () => _isRecording = true,
                                                    ),
                                                onRecordingStopped: () =>
                                                    setState(
                                                      () =>
                                                          _isRecording = false,
                                                    ),
                                                onAudioFileReady: (file) {
                                                  if (file != null) {
                                                    widget.onSend(
                                                      '',
                                                      file: file,
                                                      fileType: 'audio',
                                                    );
                                                  }
                                                },
                                              ),
                                            )
                                          : IntrinsicHeight(
                                              child: Stack(
                                                children: [
                                                  //  SizedBox(width: 20),
                                                  Opacity(
                                                    opacity: 0,
                                                    child: SizedBox(
                                                      height: 5,
                                                      child: AudioWaveformWidget(
                                                        key: _audioWaveformKey,
                                                        onRecordingStarted:
                                                            () => setState(
                                                              () =>
                                                                  _isRecording =
                                                                      true,
                                                            ),
                                                        onRecordingStopped:
                                                            () => setState(
                                                              () =>
                                                                  _isRecording =
                                                                      false,
                                                            ),
                                                        onAudioFileReady:
                                                            (file) {
                                                              if (file !=
                                                                  null) {
                                                                widget.onSend(
                                                                  '',
                                                                  file: file,
                                                                  fileType:
                                                                      'audio',
                                                                );
                                                              }
                                                            },
                                                      ),
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller: widget
                                                        .messageController,
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                    maxLines: null,
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.newline,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Hi, How can I help you today?',
                                                      hintStyle: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.32),
                                                        fontSize: 16,
                                                        fontFamily: 'Lato',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                            vertical: hasPdf
                                                                ? 8
                                                                : 12,
                                                            horizontal: 0,
                                                          ),
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                    SizedBox(width: _isRecording ? 68 : 48),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: (hasPdf && !_isRecording) ? 8 : 6,
                    child: Material(
                      color: Colors.transparent,
                      child: Listener(
                        onPointerDown: (details) {
                          _startY = details.localPosition.dy;
                          _isCancelledBySwipe = false;
                          final chatController =
                              Get.find<ChatScreenController>();
                          chatController.onPointerDown(() {
                            if (mounted) {
                              setState(() => _isRecording = true);
                              _pulseController.repeat(reverse: true);
                            }
                            _audioWaveformKey.currentState?.startRecording();
                          });
                        },
                        onPointerMove: (details) {
                          if (_isRecording) {
                            double displacement =
                                _startY - details.localPosition.dy;
                            bool shouldCancel = displacement > 80;
                            if (shouldCancel != _isCancelledBySwipe) {
                              setState(
                                () => _isCancelledBySwipe = shouldCancel,
                              );
                            }
                          }
                        },
                        onPointerUp: (details) {
                          final chatController =
                              Get.find<ChatScreenController>();
                          chatController.onPointerUp(
                            () {
                              if (_hasText || _selectedPdfFile != null) {
                                widget.onSend(
                                  widget.messageController.text,
                                  file: _selectedPdfFile,
                                  fileType: _selectedPdfFile != null
                                      ? 'document'
                                      : null,
                                );
                                _removePdfFile();
                              }
                            },
                            () {
                              if (_isCancelledBySwipe) {
                                _audioWaveformKey.currentState
                                    ?.cancelRecording();
                              } else {
                                _audioWaveformKey.currentState?.stopRecording();
                              }
                              if (mounted) {
                                setState(() {
                                  _isRecording = false;
                                  _isCancelledBySwipe = false;
                                });
                                _pulseController.stop();
                                _pulseController.reset();
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(25),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.fastOutSlowIn,
                              width: _isRecording ? 48 : 35,
                              height: _isRecording ? 160 : 35,
                              padding: EdgeInsets.symmetric(
                                vertical: _isRecording ? 12 : 5,
                              ),
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: _isCancelledBySwipe
                                      ? [Colors.red, Colors.redAccent]
                                      : _isRecording
                                      ? [
                                          const Color(
                                            0xFF6595FF,
                                          ).withOpacity(0.95),
                                          const Color(
                                            0xFF3865FF,
                                          ).withOpacity(0.95),
                                        ]
                                      : [
                                          const Color(0xFF6595FF),
                                          const Color(0xFF3865FF),
                                        ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      _isRecording ? 0.3 : 0.0,
                                    ),
                                    blurRadius: _isRecording ? 12 : 0,
                                    offset: _isRecording
                                        ? const Offset(0, 4)
                                        : Offset.zero,
                                  ),
                                ],
                              ),
                              child: _isRecording
                                  ? SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: SizedBox(
                                        height: 136, // 160 - (12 * 2)
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            AnimatedBuilder(
                                              animation: _pulseController,
                                              builder: (_, __) =>
                                                  Transform.translate(
                                                    offset: Offset(
                                                      0,
                                                      -_pulsePosition.value,
                                                    ),
                                                    child: Transform.scale(
                                                      scale: _pulseScale.value,
                                                      child: const Icon(
                                                        Icons.keyboard_arrow_up,
                                                        color: Colors.white,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                            Icon(
                                              _isCancelledBySwipe
                                                  ? Icons.delete
                                                  : Icons.mic,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        _hasText
                                            ? Icons.arrow_upward
                                            : Icons.mic_none,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                            ),
                          ),
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
    );
  }
}

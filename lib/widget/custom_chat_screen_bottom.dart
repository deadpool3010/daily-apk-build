import 'dart:io';
import 'dart:ui';
import 'package:bandhucare_new/widget/add_media_chat_screen_bottomsheet.dart';
import 'package:bandhucare_new/widget/selected_pdf_in_chat_bottom.dart';
import 'package:bandhucare_new/widget/audio_waveform_widget.dart';
import 'package:file_picker/file_picker.dart';

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

class _ChatScreenBottomState extends State<ChatScreenBottom> {
  bool _hasText = false;
  File? _selectedPdfFile;
  String? _pdfFileName;
  String? _pdfFileSize;
  final GlobalKey<AudioWaveformWidgetState> _audioWaveformKey =
      GlobalKey<AudioWaveformWidgetState>();
  bool _isRecording = false;
  @override
  void initState() {
    super.initState();

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
    // Do NOT dispose messageController here; it is owned by parent (ChatBotScreen)
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

    // Floating iOS-style input bar

    return Container(
      width: double.infinity,
      color: Colors.transparent,

      /// 🔥 Keyboard open → small padding
      /// 🔥 Keyboard closed → larger padding
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
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
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

            const SizedBox(width: 12),

            // TEXT FIELD + SEND BUTTON (Translucent iOS-style)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      maxHeight:
                          300, // Fixed max height, will scroll after this
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: hasPdf ? 8 : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show selected PDF if available (inside the container)
                        if (hasPdf && !_isRecording)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: SelectedPdfFile(
                              fileName: _pdfFileName!,
                              fileSize: _pdfFileSize!,
                              onDelete: _removePdfFile,
                            ),
                          ),

                        // TEXT FIELD ROW or AUDIO WAVEFORM
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(width: 16),

                              // TEXT FIELD or AUDIO WAVEFORM
                              Expanded(
                                child: _isRecording
                                    ? SizedBox(
                                        height: 50,
                                        child: AudioWaveformWidget(
                                          key: _audioWaveformKey,
                                          onRecordingStarted: () {
                                            setState(() {
                                              _isRecording = true;
                                            });
                                          },
                                          onRecordingStopped: () {
                                            setState(() {
                                              _isRecording = false;
                                            });
                                          },
                                          onAudioFileReady: (file) {
                                            // Automatically send audio file when recording stops
                                            if (file != null) {
                                              widget.onSend(
                                                '', // Empty content for audio
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
                                            // Always keep AudioWaveformWidget in tree for GlobalKey (hidden)
                                            Opacity(
                                              opacity: 0,
                                              child: SizedBox(
                                                height: 50,
                                                child: AudioWaveformWidget(
                                                  key: _audioWaveformKey,
                                                  onRecordingStarted: () {
                                                    setState(() {
                                                      _isRecording = true;
                                                    });
                                                  },
                                                  onRecordingStopped: () {
                                                    setState(() {
                                                      _isRecording = false;
                                                    });
                                                  },
                                                  onAudioFileReady: (file) {
                                                    // Automatically send audio file when recording stops
                                                    if (file != null) {
                                                      widget.onSend(
                                                        '', // Empty content for audio
                                                        file: file,
                                                        fileType: 'audio',
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            // TextField that can expand
                                            TextField(
                                              controller:
                                                  widget.messageController,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              maxLines: null,
                                              minLines: 1,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onSubmitted: (text) {
                                                // Don't send on enter, allow new lines
                                              },
                                              scrollController:
                                                  ScrollController(),
                                              scrollPhysics:
                                                  const ClampingScrollPhysics(),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Hi, How can I help you today?',
                                                hintStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.32),
                                                  fontSize: 16,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: hasPdf ? 8 : 12,
                                                      horizontal: 0,
                                                    ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),

                              const SizedBox(width: 8),

                              // SEND / MIC BUTTON
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: (hasPdf && !_isRecording) ? 8 : 6,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                    onLongPressStart: (_) {
                                      _audioWaveformKey.currentState
                                          ?.startRecording();
                                      _audioWaveformKey.currentState
                                          ?.startRecording();
                                    },
                                    onLongPressEnd: (_) {
                                      _audioWaveformKey.currentState
                                          ?.stopRecording();
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        if (_hasText ||
                                            _selectedPdfFile != null) {
                                          widget.onSend(
                                            widget.messageController.text,
                                            file: _selectedPdfFile,
                                            fileType: _selectedPdfFile != null
                                                ? 'document'
                                                : null,
                                          );
                                          // Clear PDF after sending
                                          _removePdfFile();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(18),
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        padding: const EdgeInsets.all(5),
                                        decoration: ShapeDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.41, 1.00),
                                            end: Alignment(0.51, 0.04),
                                            colors: [
                                              Color(0xFF6595FF),
                                              Color(0xFF3865FF),
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              17.50,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: _isRecording
                                              ? Icon(
                                                  Icons.mic,
                                                  color: Colors.white,
                                                  size: 24,
                                                )
                                              : _hasText
                                              ? Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.white,
                                                  size: 24,
                                                )
                                              : Icon(
                                                  Icons.mic_none,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ],
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

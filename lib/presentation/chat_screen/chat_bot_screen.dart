import 'dart:ui';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/chat_screen/controller/chat_screeen_controller.dart';
import 'package:bandhucare_new/widget/custom_chat_bubbles.dart';
import 'package:bandhucare_new/widget/qustion_suggetion.dart';
import 'package:bandhucare_new/widget/like_deslike_tts.dart';

class ChatMessage {
  final String text;
  final bool isUser; // true for user, false for bot
  final DateTime timestamp;
  final Map<String, dynamic>? file;
  final String? formQuestionHeader;
  String streamedText;
  String? fullText; // Text streamed from bot

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.file,
    this.formQuestionHeader,
    this.streamedText = '',
    this.fullText = '',
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatBotScreen extends StatefulWidget {
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late final ChatScreenController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller if it doesn't exist, otherwise use existing one
    if (Get.isRegistered<ChatScreenController>()) {
      controller = Get.find<ChatScreenController>();
    } else {
      controller = Get.put(ChatScreenController(), permanent: false);
    }
  }

  void _scrollToBottom() {
    if (!controller.scrollController.hasClients) return;
    controller.scrollController.animateTo(
      0.0, // Bottom in reversed ListView
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    // Enable auto-scroll when user manually scrolls to bottom
    controller.shouldAutoScroll.value = true;
  }

  @override
  void dispose() {
    // Remove controller when screen is disposed (only if we created it)
    if (Get.isRegistered<ChatScreenController>()) {
      Get.delete<ChatScreenController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check keyboard visibility using MediaQuery (will rebuild when keyboard appears)
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    // Debug print
    print(
      '🔑 Keyboard Height: $keyboardHeight, Is Visible: $isKeyboardVisible',
    );

    // Get header background color to match status bar
    final headerColor = Color.fromARGB(
      255,
      249,
      250,
      251,
    ); // Match the header container color
    final isLightColor = controller.isLightColor(headerColor);

    // Set status bar to transparent for blur effect
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: isLightColor
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: isLightColor
            ? Brightness.light
            : Brightness.dark, // For iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset:
            true, // Allow body to resize when keyboard appears
        extendBodyBehindAppBar:
            true, // THIS IS CRITICAL - extends content behind AppBar for blur effect
        appBar: ChatScreenAppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.chat_screen_background),
              fit: BoxFit.cover,
            ),
            color: const Color.fromARGB(255, 243, 249, 255),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Chat messages area
              Positioned.fill(
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xFF3865FF),
                          ),
                        )
                      : _buildChatView(keyboardHeight),
                ),
              ),

              // Question suggestions (hide when keyboard is open)
              Positioned(
                left: 0,
                right: 0,
                bottom: 90,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height: isKeyboardVisible
                        ? 0
                        : 90, // Collapse to 0 when keyboard opens
                    child: ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isKeyboardVisible ? 0 : 1,
                        child: IgnorePointer(
                          ignoring: isKeyboardVisible,
                          child: Obx(() {
                            final shouldShow =
                                controller.messages.isNotEmpty &&
                                controller.shouldAutoScroll.value;
                            return shouldShow
                                ? QuestionSuggestions(
                                    onQuestionTap: (question) {
                                      controller.sendChatMessage(question);
                                    },
                                  )
                                : const SizedBox.shrink();
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70, // Height of blur shadow area
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(1),
                        spreadRadius: 5,
                        blurRadius: 50,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom input field
              Positioned(
                left: 0,
                right: 0,
                bottom: -10,
                child: ChatScreenBottom(
                  messageController: controller.messageController,
                  onSend:
                      (text, {file, fileType, originalTranscript, fileUrl}) =>
                          controller.sendChatMessage(
                            text,
                            file: file,
                            fileType: fileType,
                            originalTranscript: originalTranscript,
                            fileUrl: fileUrl,
                          ),
                ),
              ),

              // Scroll to bottom button (appears when scrolled up)
              Obx(
                () => !controller.shouldAutoScroll.value
                    ? Positioned(
                        right: 16,
                        bottom: 90, // Above the input field
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _scrollToBottom,
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF3865FF),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Demo questions to show when there are no messages
  final List<String> _demoQuestions = [
    'I forgot to take my tablet in the morning. Should I take it now?',
    'Why do I feel dizzy after my injection?',
    'Is it okay to take my medicine after food instead of before?',
  ];

  void _handleSuggestionTap(String question) {
    controller.sendChatMessage(question);
  }

  Widget _buildSuggestionsView() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ask me Anything.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.33,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 20),
            ..._demoQuestions.asMap().entries.map((entry) {
              int index = entry.key;
              String question = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < 2 ? 15 : 0),
                child: GestureDetector(
                  onTap: () => _handleSuggestionTap(question),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFECF0FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      question,
                      style: TextStyle(
                        color: const Color(0xFF3865FF),
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 1.44,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView(double keyboardHeight) {
    // Header height: 50 (image) + 15 (top padding) + 15 (bottom padding) = 80px
    // Add top padding so messages appear below header

    return Obx(() {
      // Show suggestions view when there are no messages
      if (controller.messages.isEmpty) {
        return _buildSuggestionsView();
      }

      // Show messages list when there are messages
      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 90,
          bottom: keyboardHeight > 0 ? 100 : 200,
        ),
        reverse: true,
        itemCount:
            controller.messages.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the top (end of reversed list)
          if (controller.isLoadingMore.value &&
              index == controller.messages.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF3865FF),
                  strokeWidth: 2,
                ),
              ),
            );
          }

          final message = controller.messages[index];
          return Padding(
            padding: EdgeInsets.only(top: 15),
            child: message.isUser
                ? _buildUserMessage(message)
                : _buildBotMessage(message),
          );
        },
      );
    });
  }

  Widget _buildUserMessage(ChatMessage message) {
    final hasValidFile =
        message.file != null &&
        message.file!['fileType'] != null &&
        message.file!['fileType'].toString().isNotEmpty;

    // Debug prints
    print('🔍 _buildUserMessage DEBUG:');
    print('   message.text: ${message.text}');
    print('   message.file: ${message.file}');
    print('   message.file != null: ${message.file != null}');
    if (message.file != null) {
      print('   message.file![\'fileType\']: ${message.file!['fileType']}');
      print(
        '   message.file![\'fileType\'] != null: ${message.file!['fileType'] != null}',
      );
      print(
        '   message.file![\'fileType\'].toString().isNotEmpty: ${message.file!['fileType']?.toString().isNotEmpty}',
      );
    }
    print('   hasValidFile: $hasValidFile');

    Widget messageWidget;

    if (hasValidFile) {
      if (message.file!['fileType'] == 'audio') {
        print('✅ RENDERING: AudioChatBubble');
        messageWidget = AudioChatBubble(
          audioUrl: message.file!['fileUrl']?.toString(),
          audioTranscript:
              message.text, // Use text field content (may be edited)
          isLoading: message.file!['fileUrl'] == null,
        );
      } else {
        print('✅ RENDERING: ChatBubblePdf (PDF/Document)');
        messageWidget = ChatBubblePdf(
          fileName: message.file!['fileName']?.toString() ?? 'Document.pdf',
          fileUrl: message.file!['fileUrl']?.toString(),
          caption: message.file!['caption']?.toString() ?? message.text,
          fileSize: null, // Can be extracted from file if needed
          isLoading: message.file!['fileUrl'] == null,
        );
      }
    } else {
      print('✅ RENDERING: Normal Text Message');
      messageWidget = Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: ShapeDecoration(
          color: const Color(0xFF3865FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
            height: 1.44,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    return Align(alignment: Alignment.centerRight, child: messageWidget);
  }

  Widget _buildBotMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: message.file != null && message.file!['fileType'] != null
          ? message.file!['fileType'] == 'audio'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AudioChatBubble(
                        audioUrl: message.file!['fileUrl']?.toString(),
                        audioTranscript: message
                            .text, // Use message text (may be edited for user messages)
                        isLoading: message.file!['fileUrl'] == null,
                      ),
                      LikeDislikeTTS(
                        messageText: message.text,
                        onLikeChanged: (isLiked) {
                          print(
                            'Message feedback: ${isLiked ? "liked" : "disliked"}',
                          );
                        },
                        onTTS: () {
                          print('TTS triggered for audio message');
                        },
                      ),
                    ],
                  )
                : message.file!['fileType'] == 'document'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ChatBubblePdf(
                        fileName:
                            message.file!['fileName']?.toString() ??
                            'Document.pdf',
                        fileUrl: message.file!['fileUrl']?.toString(),
                        caption:
                            message.file!['caption']?.toString() ??
                            message.text,
                        fileSize: null,
                        isLoading: message.file!['fileUrl'] == null,
                      ),
                      LikeDislikeTTS(
                        messageText:
                            message.file!['caption']?.toString() ??
                            message.text,
                        onLikeChanged: (isLiked) {
                          print(
                            'Message feedback: ${isLiked ? "liked" : "disliked"}',
                          );
                        },
                        onTTS: () {
                          print('TTS triggered for document message');
                        },
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFECF0FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            color: Color(0xFF3865FF),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.44,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      LikeDislikeTTS(
                        messageText: message.text,
                        onLikeChanged: (isLiked) {
                          // Handle like/dislike feedback
                          print(
                            'Message feedback: ${isLiked ? "liked" : "disliked"}',
                          );
                        },
                        onTTS: () {
                          // Handle text-to-speech
                          print('TTS triggered for: ${message.text}');
                        },
                      ),
                    ],
                  )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.formQuestionHeader != null &&
                    message.formQuestionHeader!.isNotEmpty) ...{
                  Text(
                    message.formQuestionHeader!,
                    style: TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 5),
                } else ...{
                  SizedBox.shrink(),
                },
                Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE6EBFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                    message.streamedText.isNotEmpty
                        ? message.streamedText
                        : message.text,
                    style: const TextStyle(
                      color: Color(0xFF1D2873),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 1.44,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                LikeDislikeTTS(
                  messageText: message.text,
                  onLikeChanged: (isLiked) {
                    // Handle like/dislike feedback
                    print(
                      'Message feedback: ${isLiked ? "liked" : "disliked"}',
                    );
                  },
                  onTTS: () {
                    // Handle text-to-speech
                    print('TTS triggered for: ${message.text}');
                  },
                ),
              ],
            ),
    );
  }
}

class SendMessageUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.43, 0.00),
              end: Alignment(0.44, 1.00),
              colors: [const Color(0xFF3865FF), const Color(0xFF213C99)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 247,
                child: Text(
                  'Is it okay to take my medicine after food instead of before?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    height: 1.44,
                    decoration: TextDecoration.none,
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

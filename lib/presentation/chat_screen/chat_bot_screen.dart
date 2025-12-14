import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/chat_screen/controller/chat_screeen_controller.dart';
import 'package:bandhucare_new/widget/custom_chat_bubbles.dart';
import 'package:bandhucare_new/widget/qustion_suggetion.dart';

class ChatMessage {
  final String text;
  final bool isUser; // true for user, false for bot
  final DateTime timestamp;
  final Map<String, dynamic>? file; // file information from API

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.file,
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
    // final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Get header background color to match status bar
    final headerColor = Color.fromARGB(
      255,
      249,
      250,
      251,
    ); // Match the header container color
    final isLightColor = controller.isLightColor(headerColor);

    // Set status bar to match header's background color
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: headerColor,
        statusBarIconBrightness: isLightColor
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: isLightColor
            ? Brightness.light
            : Brightness.dark, // For iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: ChatScreenAppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Stack(
            children: [
              // Chat messages area - starts from top
              Positioned(
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xFF3865FF),
                          ),
                        )
                      : _buildChatView(),
                ),
              ),
              // Question suggestions - positioned above input field
              // Only show when at bottom (newest messages visible) - hide when scrolling up
              Positioned(
                left: 0,
                right: 0,
                bottom:
                    90, // Position above the input field (bottom bar height)
                child: Obx(
                  () =>
                      controller.messages.isNotEmpty &&
                          controller.shouldAutoScroll.value
                      ? QuestionSuggestions(
                          onQuestionTap: (question) {
                            controller.sendChatMessage(question);
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ChatScreenBottom(
                  messageController: controller.messageController,
                  onSend: (text, {file, fileType}) => controller
                      .sendChatMessage(text, file: file, fileType: fileType),
                ),
              ),

              // Input field - moves up with keyboard
              // Positioned(
              //   left: 40,
              //   bottom: keyboardHeight > 0
              //       ? keyboardHeight + 19
              //       : 69, // Move up when keyboard is open
              //   child: Container(
              //     width: 344,
              //     height: 50,
              //     clipBehavior: Clip.antiAlias,
              //     decoration: ShapeDecoration(
              //       color: const Color(0x216A8BF3),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //     ),
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           left: 28,
              //           top: 0,
              //           bottom: 0,
              //           child: Align(
              //             alignment: Alignment.centerLeft,
              //             child: SizedBox(
              //               width: 250,
              //               child: Material(
              //                 color: Colors.transparent,
              //                 child: TextField(
              //                   controller: _messageController,
              //                   textAlignVertical: TextAlignVertical.center,
              //                   onSubmitted: (text) => _sendMessage(text),
              //                   decoration: InputDecoration(
              //                     hintText: 'Hi, How can i help you today?',
              //                     hintStyle: TextStyle(
              //                       color: Colors.black.withOpacity(0.32),
              //                       fontSize: 16,
              //                       fontFamily: 'Lato',
              //                       fontWeight: FontWeight.w400,
              //                     ),
              //                     border: InputBorder.none,
              //                     contentPadding: EdgeInsets.zero,
              //                     isDense: true,
              //                   ),
              //                   style: TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 16,
              //                     fontFamily: 'Lato',
              //                     fontWeight: FontWeight.w400,
              //                     decoration: TextDecoration.none,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Positioned(
              //           left: 296,
              //           top: 7,
              //           child: Material(
              //             color: Colors.transparent,
              //             child: InkWell(
              //               onTap: () {
              //                 _sendMessage(_messageController.text);
              //               },
              //               child: Container(
              //                 width: 35,
              //                 height: 35,
              //                 padding: const EdgeInsets.all(5),
              //                 decoration: ShapeDecoration(
              //                   gradient: LinearGradient(
              //                     begin: Alignment(0.41, 1.00),
              //                     end: Alignment(0.51, 0.04),
              //                     colors: [
              //                       const Color(0xFF6595FF),
              //                       const Color(0xFF3865FF),
              //                     ],
              //                   ),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(17.50),
              //                   ),
              //                 ),
              //                 child: Center(
              //                   child: Image.asset(
              //                     'assets/images/imagesarrow-big-up-lines.png',
              //                     width: 24,
              //                     height: 24,
              //                     fit: BoxFit.contain,
              //                     color: Colors.white,
              //                     errorBuilder: (context, error, stackTrace) {
              //                       return Icon(
              //                         Icons.arrow_upward,
              //                         color: Colors.white,
              //                         size: 20,
              //                       );
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Disclaimer text - moves up with keyboard
              // Positioned(
              //   left: 25,
              //   bottom: keyboardHeight > 0
              //       ? keyboardHeight - 12
              //       : 38, // Move up when keyboard is open
              //   child: SizedBox(
              //     width: 359,
              //     child: Text(
              //       'Mitra can make mistakes. Contact doctor in emergency',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         color: const Color(0x4C263441),
              //         fontSize: 12,
              //         fontFamily: 'Lato',
              //         fontWeight: FontWeight.w400,
              //         height: 1.50,
              //         decoration: TextDecoration.none,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSuggestionsView() {
  //   // Header height: 50 (image) + 15 (top padding) + 15 (bottom padding) = 80px
  //   // Add top padding so content appears below header
  //   return SingleChildScrollView(
  //     padding: EdgeInsets.only(
  //       left: 25,
  //       right: 25,
  //       top: 90, // Space for header (80px) + extra spacing (10px)
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 20),
  //         Text(
  //           'Ask me Anything.',
  //           style: TextStyle(
  //             color: Colors.black,
  //             fontSize: 18,
  //             fontFamily: 'Roboto',
  //             fontWeight: FontWeight.w500,
  //             height: 1.33,
  //             decoration: TextDecoration.none,
  //           ),
  //         ),
  //         SizedBox(height: 20),
  //         ...controller.chatbotDemoQustionAns.asMap().entries.map((entry) {
  //           int index = entry.key;
  //           String question = entry.value;
  //           return Padding(
  //             padding: EdgeInsets.only(bottom: index < 2 ? 15 : 0),
  //             child: GestureDetector(
  //               onTap: () => _handleSuggestionTap(question),
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 15,
  //                   vertical: 10,
  //                 ),
  //                 decoration: ShapeDecoration(
  //                   color: const Color(0xFFECF0FE),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(12),
  //                       topRight: Radius.circular(12),
  //                       bottomRight: Radius.circular(12),
  //                     ),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   question,
  //                   style: TextStyle(
  //                     color: const Color(0xFF3865FF),
  //                     fontSize: 16,
  //                     fontFamily: 'Lato',
  //                     fontWeight: FontWeight.w400,
  //                     height: 1.44,
  //                     decoration: TextDecoration.none,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildChatView() {
    // Header height: 50 (image) + 15 (top padding) + 15 (bottom padding) = 80px
    // Add top padding so messages appear below header

    return Obx(
      () => ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 90, // Space for header (80px) + extra spacing (10px)
          // Extra bottom padding: suggestions (90px) + bottom bar (90px) + extra space (20px)
          bottom: controller.messages.isNotEmpty ? 200 : 110,
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
      ),
    );
  }

  Widget _buildUserMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerRight,
      child: message.file != null
          ? message.file!['fileType'] == 'audio'
                ? AudioChatBubble(
                    audioUrl: message.file!['fileUrl']?.toString(),
                    audioTranscript:
                        message.file!['audioTranscript']?.toString() ??
                        message.text,
                    isLoading: message.file!['fileUrl'] == null,
                  )
                : ChatBubblePdf(
                    fileName:
                        message.file!['fileName']?.toString() ?? 'Document.pdf',
                    fileUrl: message.file!['fileUrl']?.toString(),
                    caption:
                        message.file!['caption']?.toString() ?? message.text,
                    fileSize: null, // Can be extracted from file if needed
                    isLoading: message.file!['fileUrl'] == null,
                  )
          : Container(
              constraints: BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: ShapeDecoration(
                color: Color(0xff3865FF),
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
            ),
    );
  }

  Widget _buildBotMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: message.file != null && message.file!['fileType'] != null
          ? message.file!['fileType'] == 'audio'
                ? AudioChatBubble(
                    audioUrl: message.file!['fileUrl']?.toString(),
                    audioTranscript:
                        message.file!['audioTranscript']?.toString() ??
                        message.text,
                    isLoading: message.file!['fileUrl'] == null,
                  )
                : message.file!['fileType'] == 'document'
                ? ChatBubblePdf(
                    fileName:
                        message.file!['fileName']?.toString() ?? 'Document.pdf',
                    fileUrl: message.file!['fileUrl']?.toString(),
                    caption:
                        message.file!['caption']?.toString() ?? message.text,
                    fileSize: null,
                    isLoading: message.file!['fileUrl'] == null,
                  )
                : Container(
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
                  )
          : Container(
              constraints: BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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

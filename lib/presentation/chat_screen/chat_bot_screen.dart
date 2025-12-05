import 'package:bandhucare_new/core/app_exports.dart';

List<Map<String, String>> chatbotDemoQustionAns = [
  {"hii": "hello,How can i help you today?"},
  {"what is your name?": "my name is chatbot"},
  {"what is your age?": "i am 1 year old"},
  {"what is your gender?": "i am a male"},
  {"what is your favorite color?": "i like blue color"},
  {"what is your favorite food?": "i like pizza"},
  {"what is your favorite animal?": "i like dog"},
  {"what is your favorite sport?": "i like cricket"},
  {"what is your favorite movie?": "i like avengers"},
  {
    "i forgot to take my tablet in the morning. Should I take it now?":
        "yes, you should take it now",
  },
  {"Why do I feel dizzy after my injection?": "you should take it now"},
  {
    "Is it okay to take my medicine after food instead of before?":
        "yes, you should take it now",
  },
];

class ChatMessage {
  final String text;
  final bool isUser; // true for user, false for bot
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class ChatBotScreen extends StatefulWidget {
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _showSuggestions = true;
  bool _isLoading = true;
  bool _isSending = false;
  String? _conversationId;
  String _selectedLanguage = 'eng'; // Default language

  final List<String> _suggestionQuestions = [
    'I forgot to take my tablet in the morning. Should I take it now?',
    'Why do I feel dizzy after my injection?',
    'Is it okay to take my medicine after food instead of before?',
  ];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await getChatHistory(page: 1, limit: 10);
      print('Chat History Response: $response');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        // Extract conversationId from data root
        if (data['conversationId'] != null) {
          _conversationId = data['conversationId'] as String;
          print('Conversation ID: $_conversationId');
        }

        final messagesList = data['messages'] as List?;

        if (messagesList != null && messagesList.isNotEmpty) {
          // Flatten messages from date groups
          final List<Map<String, dynamic>> flattenedMessages = [];
          for (var dateGroup in messagesList) {
            final messagesInDate = dateGroup['messages'] as List? ?? [];
            flattenedMessages.addAll(
              messagesInDate.cast<Map<String, dynamic>>(),
            );
          }

          // Sort messages newest to oldest (for reversed list)
          flattenedMessages.sort((a, b) {
            final aTime = DateTime.parse(a['createdAt']);
            final bTime = DateTime.parse(b['createdAt']);
            return bTime.compareTo(aTime); // DESCENDING order
          });

          setState(() {
            _messages = flattenedMessages.map((msg) {
              final isUser = msg['senderType'] == 'patient';
              // Use 'content' field instead of 'text'
              return ChatMessage(
                text:
                    msg['content']?.toString() ?? msg['text']?.toString() ?? '',
                isUser: isUser,
                timestamp: DateTime.parse(msg['createdAt']),
              );
            }).toList();

            _showSuggestions = _messages.isEmpty;
            _isLoading = false;
          });

          // Scroll to top after loading
          Future.delayed(Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        } else {
          setState(() {
            _isLoading = false;
            _showSuggestions = true;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _showSuggestions = true;
        });
        print('Failed to load chat history: ${response['message']}');
      }
    } catch (e) {
      print('Error loading chat history: $e');
      setState(() {
        _isLoading = false;
        _showSuggestions = true;
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isSending) return;

    // If no conversationId, we need to get one first
    // For now, we'll try to send and handle the error
    if (_conversationId == null) {
      Fluttertoast.showToast(
        msg: "Please wait, loading conversation...",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isSending = true;
      // Hide suggestions after first message
      _showSuggestions = false;

      // Add user message immediately
      _messages.insert(0, ChatMessage(text: text, isUser: true));
    });

    // Clear input
    _messageController.clear();

    // Scroll to top (position 0 because list is reversed)
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      final response = await sendMessage(
        conversationId: _conversationId!,
        content: text,
        targetLanguage: _selectedLanguage,
      );

      print('Send Message Response: $response');

      if (response['success'] == true && response['data'] != null) {
        // Bot message is directly in data, not in data['messages']
        final messageData = response['data'];

        // Update conversationId if provided in response
        if (messageData['conversationId'] != null) {
          _conversationId = messageData['conversationId'] as String;
        }

        setState(() {
          // Add bot response
          // Use 'content' field instead of 'text'
          _messages.insert(
            0,
            ChatMessage(
              text:
                  messageData['content']?.toString() ??
                  messageData['text']?.toString() ??
                  'No response',
              isUser: false,
              timestamp: DateTime.parse(messageData['createdAt']),
            ),
          );
          _isSending = false;
        });

        // Scroll to top after bot response
        Future.delayed(Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        setState(() {
          _isSending = false;
        });
        Fluttertoast.showToast(
          msg: response['message'] ?? 'Failed to send message',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Send message failed: ${response['message']}');
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        _isSending = false;
      });
      Fluttertoast.showToast(
        msg: "Error sending message. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _handleSuggestionTap(String question) {
    _sendMessage(question);
  }

  // Helper method to determine if a color is light or dark
  bool _isLightColor(Color color) {
    // Calculate relative luminance (0.0 = dark, 1.0 = light)
    final luminance = color.computeLuminance();
    return luminance > 0.5; // If luminance > 0.5, it's a light color
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
    final isLightColor = _isLightColor(headerColor);

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
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFF3865FF),
                        ),
                      )
                    : _messages.isEmpty && _showSuggestions
                    ? _buildSuggestionsView()
                    : _buildChatView(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ChatScreenBottom(
                  messageController: _messageController,
                  onSend: _sendMessage,
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

  Widget _buildSuggestionsView() {
    // Header height: 50 (image) + 15 (top padding) + 15 (bottom padding) = 80px
    // Add top padding so content appears below header
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 90, // Space for header (80px) + extra spacing (10px)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
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
          ..._suggestionQuestions.asMap().entries.map((entry) {
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
    );
  }

  Widget _buildChatView() {
    // Header height: 50 (image) + 15 (top padding) + 15 (bottom padding) = 80px
    // Add top padding so messages appear below header

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 90, // Space for header (80px) + extra spacing (10px)
        // Extra bottom padding so messages are not hidden behind bottom bar
        bottom: 110, // 90 (bottom bar height) + 20 (extra space)
      ),
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return Padding(
          padding: EdgeInsets.only(top: 15),
          child: message.isUser
              ? _buildUserMessage(message.text)
              : _buildBotMessage(message.text),
        );
      },
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        child: Text(
          text,
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

  Widget _buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
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
          text,
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

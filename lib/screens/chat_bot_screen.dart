import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  final List<String> _suggestionQuestions = [
    'I forgot to take my tablet in the morning. Should I take it now?',
    'Why do I feel dizzy after my injection?',
    'Is it okay to take my medicine after food instead of before?',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getBotResponse(String userMessage) {
    // Convert to lowercase for case-insensitive matching
    String lowerMessage = userMessage.toLowerCase().trim();

    for (var qa in chatbotDemoQustionAns) {
      var question = qa.keys.first.toLowerCase();
      if (lowerMessage.contains(question) || question.contains(lowerMessage)) {
        return qa.values.first;
      }
    }

    return "I'm here to help you with your medical questions. Could you please rephrase your question?";
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      // Hide suggestions after first message
      _showSuggestions = false;

      // Add user message
      _messages.add(ChatMessage(text: text, isUser: true));

      // Get and add bot response
      String response = _getBotResponse(text);
      _messages.add(ChatMessage(text: response, isUser: false));
    });

    // Clear input
    _messageController.clear();

    // Scroll to bottom (position 0 because list is reversed)
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSuggestionTap(String question) {
    _sendMessage(question);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 408,
          height: 913,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 9,
                top: 14.19,
                child: Container(
                  width: 386,
                  height: 41.63,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 18.92,
                        top: 11.35,
                        child: Container(
                          width: 51.09,
                          height: 19.87,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.27),
                            ),
                          ),
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 58.99,
                top: 86,
                child: Container(
                  width: 42.02,
                  height: 42.02,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.10, 0.05),
                      end: Alignment(0.89, 0.96),
                      colors: [
                        const Color(0xFFD6E4FA),
                        const Color(0xFFB9CAFA),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.42),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Mitra',
                      style: TextStyle(
                        color: const Color(0xFF3865FF),
                        fontSize: 12.71,
                        fontFamily: 'Paggoda',
                        fontWeight: FontWeight.w400,
                        height: 0.58,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 784,
                child: Container(
                  width: 344,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0x216A8BF3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 28,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 250,
                            child: Material(
                              color: Colors.transparent,
                              child: TextField(
                                controller: _messageController,
                                textAlignVertical: TextAlignVertical.center,
                                onSubmitted: (text) => _sendMessage(text),
                                decoration: InputDecoration(
                                  hintText: 'Hi, How can i help you today?',
                                  hintStyle: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.32),
                                    fontSize: 16,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 296,
                        top: 7,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _sendMessage(_messageController.text);
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              padding: const EdgeInsets.all(5),
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.41, 1.00),
                                  end: Alignment(0.51, 0.04),
                                  colors: [
                                    const Color(0xFF6595FF),
                                    const Color(0xFF3865FF),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.50),
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/arrow-big-up-lines.png',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 20,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Chat messages area
              Positioned(
                left: 0,
                right: 0,
                top: 150,
                bottom: 120,
                child: _messages.isEmpty && _showSuggestions
                    ? _buildSuggestionsView()
                    : _buildChatView(),
              ),

              Positioned(
                left: 25,
                top: 853,
                child: SizedBox(
                  width: 359,
                  child: Text(
                    'Mitra can make mistakes. Contact doctor in emergency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0x4C263441),
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 15,
                bottom: 90,
                child: Container(
                  width: 48,
                  height: 55,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: Lottie.asset(
                          'assets/bot_animation.json',
                          width: 48,
                          height: 55,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 341,
                top: 86,
                child: Container(
                  width: 43,
                  height: 43,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.76,
                    vertical: 14.62,
                  ),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.50, -0.00),
                      end: Alignment(0.50, 1.00),
                      colors: [
                        const Color(0xFFCDB9F8),
                        const Color(0xFF8A9DF5),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21.50),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.60,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 1.5,
                        children: [
                          // Line 1 - shortest
                          Container(
                            width: 2,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          // Line 2 - medium
                          Container(
                            width: 2,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          // Line 3 - tallest
                          Container(
                            width: 2,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          // Line 4 - medium-short
                          Container(
                            width: 2,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 96,
                child: Container(
                  width: 27,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25),
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
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        // Reverse the index to show newest at bottom
        final reversedIndex = _messages.length - 1 - index;
        final message = _messages[reversedIndex];
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
            spacing: 10,
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

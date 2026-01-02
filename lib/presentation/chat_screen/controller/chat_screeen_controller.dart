import 'dart:async';
import 'dart:io';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/widget/audio_record_animation.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final audioRecorderController = AudioRecorderController();

  var messages = <ChatMessage>[].obs;

  var showSuggestions = true.obs;
  var isLoading = true.obs;
  var isSending = false.obs;
  var isRecordingAudio = false.obs;
  var amplitudeList = <double>[].obs;
  var waveformUpdateCounter = 0.obs;

  var conversationId = RxnString();
  var selectedLanguage = 'eng'.obs;
  var shouldAutoScroll = true.obs;
  var formQuestionHeader = ''.obs;

  // Pagination variables
  int currentPage = 1;
  final int pageLimit = 10;
  var hasMoreMessages = true.obs;
  var isLoadingMore = false.obs;
  var isInitialLoad = true.obs;

  // Scroll debouncing to prevent rapid-fire loading
  Timer? _scrollDebouncer;
  bool _isLoadingInBackground = false;
  Timer? _recordTimer;

  @override
  void onInit() {
    super.onInit();
    // Only load chat history if we don't already have messages (coming from reminders)
    if (messages.isEmpty && conversationId.value == null) {
      loadChatHistory();
    } else if (messages.isNotEmpty) {
      // If we have messages already (from reminders), skip loading history
      isLoading.value = false;
      isInitialLoad.value = false;
    }
    scrollController.addListener(_onScroll);
  }

  // @override
  // void onReady() {
  //   final arg = Get.arguments ?? {};
  //   formQuestionHeader = arg['textMessage'];
  // }

  void _onScroll() {
    if (!scrollController.hasClients || _isLoadingInBackground) return;

    // Cancel previous debouncer
    _scrollDebouncer?.cancel();

    // Update auto-scroll state
    if (scrollController.offset > 50) {
      shouldAutoScroll.value = false;
    } else {
      shouldAutoScroll.value = true;
    }

    // Debounce the load more check
    _scrollDebouncer = Timer(const Duration(milliseconds: 300), () {
      if (!scrollController.hasClients ||
          _isLoadingInBackground ||
          isLoadingMore.value ||
          !hasMoreMessages.value ||
          isLoading.value ||
          isInitialLoad.value) {
        return;
      }

      // Load more when near top (oldest messages)
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreMessages();
      }
    });
  }

  @override
  void onClose() {
    _scrollDebouncer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    audioRecorderController.dispose();
    _recordTimer?.cancel();
    super.onClose();
  }

  Future<void> startAudioRecording(BuildContext context) async {
    isRecordingAudio.value = true;
    amplitudeList.value = [];

    await audioRecorderController.startRecording(context, (updatedList) {
      if (updatedList.isNotEmpty) {
        amplitudeList.value = List.from(updatedList);
        waveformUpdateCounter.value++;
      }
    });
  }

  Future<void> stopAudioRecording() async {
    await audioRecorderController.stopRecording();
    isRecordingAudio.value = false;
    amplitudeList.value = [];
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void scrollToTop({bool animate = true}) {
    if (!scrollController.hasClients) return;

    if (animate) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
      );
    } else {
      scrollController.jumpTo(0.0);
    }
  }

  void scrollToTopAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<ChatScreenController>() &&
          scrollController.hasClients) {
        scrollToTop(animate: true);
      }
    });
  }

  Future<void> loadChatHistory() async {
    isLoading.value = true;
    isInitialLoad.value = true;
    currentPage = 1;
    hasMoreMessages.value = true;
    print("Loading chat history...");

    try {
      final response = await getChatHistory(page: currentPage, limit: 10);
      print("Chat History Response: $response");

      if (response["success"] == true && response["data"] != null) {
        final data = response["data"];
        print("Data received: $data");

        if (data["conversationId"] != null) {
          conversationId.value = data["conversationId"];
          print("Conversation ID: ${conversationId.value}");
        }

        final messagesList = data["messages"] as List?;
        print("Messages list: $messagesList");

        if (messagesList != null && messagesList.isNotEmpty) {
          final List<Map<String, dynamic>> flattened = [];

          for (var dateGroup in messagesList) {
            final list = dateGroup["messages"] as List? ?? [];
            print("Date group messages: $list");
            flattened.addAll(list.cast<Map<String, dynamic>>());
          }

          print("Flattened messages count: ${flattened.length}");

          if (flattened.isNotEmpty) {
            flattened.sort((a, b) {
              try {
                return DateTime.parse(
                  b["createdAt"],
                ).compareTo(DateTime.parse(a["createdAt"]));
              } catch (e) {
                print("Error parsing date: $e");
                return 0;
              }
            });

            messages.value = flattened.map((msg) {
              return _processMessage(msg);
            }).toList();

            print("Messages set: ${messages.length}");

            if (flattened.length < pageLimit) {
              hasMoreMessages.value = false;
            }
          }

          showSuggestions.value = messages.isEmpty;
        } else {
          print("No messages found, showing suggestions");
          showSuggestions.value = true;
          hasMoreMessages.value = false;
        }

        isLoading.value = false;
        isInitialLoad.value = false;
        print("Loading set to false");
        scrollToTopAfterBuild();
      } else {
        print("Response not successful or data is null");
        isLoading.value = false;
        isInitialLoad.value = false;
        showSuggestions.value = true;
        hasMoreMessages.value = false;
        print("Failed to load: ${response["message"]}");
      }
    } catch (e, stackTrace) {
      print("Error fetching chat history: $e");
      print("Stack trace: $stackTrace");
      isLoading.value = false;
      isInitialLoad.value = false;
      showSuggestions.value = true;
      hasMoreMessages.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (isLoadingMore.value ||
        !hasMoreMessages.value ||
        _isLoadingInBackground) {
      return;
    }

    // CRITICAL: Block scroll listener IMMEDIATELY
    _isLoadingInBackground = true;
    isLoadingMore.value = true;
    currentPage++;
    print("🔄 Loading page $currentPage silently in background...");

    try {
      final response = await getChatHistory(
        page: currentPage,
        limit: pageLimit,
      );

      if (response["success"] == true && response["data"] != null) {
        final data = response["data"];
        final messagesList = data["messages"] as List?;

        if (messagesList != null && messagesList.isNotEmpty) {
          final List<Map<String, dynamic>> flattened = [];

          for (var dateGroup in messagesList) {
            final list = dateGroup["messages"] as List? ?? [];
            flattened.addAll(list.cast<Map<String, dynamic>>());
          }

          if (flattened.isNotEmpty) {
            flattened.sort((a, b) {
              try {
                return DateTime.parse(
                  b["createdAt"],
                ).compareTo(DateTime.parse(a["createdAt"]));
              } catch (e) {
                return 0;
              }
            });

            final newMessages = flattened.map((msg) {
              return _processMessage(msg);
            }).toList();

            print("➕ Adding ${newMessages.length} older messages to list");

            // Append older messages to the end - NO SCROLL MANIPULATION
            // Just add messages silently, let Flutter handle scroll naturally
            messages.addAll(newMessages);

            if (flattened.length < pageLimit) {
              hasMoreMessages.value = false;
              print("✅ No more messages to load");
            }

            print("✅ Total messages now: ${messages.length}");
          } else {
            hasMoreMessages.value = false;
          }
        } else {
          hasMoreMessages.value = false;
        }
      } else {
        hasMoreMessages.value = false;
      }
    } catch (e, stackTrace) {
      print("❌ Error loading more messages: $e");
      print("Stack trace: $stackTrace");
      currentPage--; // Revert on error
      hasMoreMessages.value = false;
    }

    // Wait for UI to settle before allowing next load
    await Future.delayed(const Duration(milliseconds: 600));

    isLoadingMore.value = false;

    // Small additional delay to ensure scroll position is stable
    await Future.delayed(const Duration(milliseconds: 100));

    _isLoadingInBackground = false;

    print("✅ Background loading complete - scroll listener re-enabled");
  }

  ChatMessage _processMessage(Map<String, dynamic> msg) {
    final isUser = msg["senderType"] == "patient";
    final fileData = msg["file"] as Map<String, dynamic>?;
    final formQuestionHeader = msg['formTemplateName'] as String?;

    Map<String, dynamic>? fileInfo;
    if (fileData != null &&
        fileData.isNotEmpty &&
        fileData["fileType"] != null &&
        fileData["fileUrl"] != null &&
        fileData["fileName"] != null) {
      fileInfo = {
        'fileType': fileData["fileType"],
        'fileUrl': fileData["fileUrl"],
        'fileName': fileData["fileName"],
        'caption': fileData["caption"],
        'audioTranscript': fileData["audioTranscript"],
      };
    }

    String messageText;
    if (fileInfo != null && fileInfo['fileType'] == 'audio') {
      messageText =
          fileInfo['audioTranscript']?.toString() ??
          fileInfo['caption']?.toString() ??
          msg["content"]?.toString() ??
          "";
    } else if (fileInfo != null && fileInfo['caption'] != null) {
      messageText = fileInfo['caption'].toString();
    } else {
      messageText = msg["content"]?.toString() ?? msg["text"]?.toString() ?? "";
    }

    return ChatMessage(
      formQuestionHeader: formQuestionHeader,
      text: messageText,
      isUser: isUser,
      timestamp:
          DateTime.tryParse(msg["createdAt"]?.toString() ?? "") ??
          DateTime.now(),
      file: fileInfo,
    );
  }

  Future<void> sendChatMessage(
    String text, {
    File? file,
    String? fileType,
  }) async {
    if (text.trim().isEmpty && file == null || isSending.value) return;

    if (conversationId.value == null) {
      Fluttertoast.showToast(
        msg: "Please wait, loading conversation...",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    isSending.value = true;
    showSuggestions.value = false;

    Map<String, dynamic>? fileInfo;
    if (file != null && fileType != null) {
      fileInfo = {'fileType': fileType, 'fileName': file.path.split('/').last};
    }

    messages.insert(0, ChatMessage(text: text, isUser: true, file: fileInfo));
    scrollToTopAfterBuild();
    messageController.clear();

    try {
      final response = await sendMessage(
        conversationId: conversationId.value!,
        content: text,
        targetLanguage: selectedLanguage.value,
        file: file,
        fileType: fileType,
      );

      print("Send Message Response: $response");

      if (response["success"] == true && response["data"] != null) {
        final data = response["data"];

        if (data["conversationId"] != null) {
          conversationId.value = data["conversationId"];
        }

        Map<String, dynamic>? userMessageData;
        if (data["userMessage"] != null) {
          userMessageData = data["userMessage"] as Map<String, dynamic>;
        } else if (data["senderType"] == "patient") {
          userMessageData = data as Map<String, dynamic>;
        }

        if (userMessageData != null &&
            messages.isNotEmpty &&
            messages[0].isUser) {
          final fileData = userMessageData["file"] as Map<String, dynamic>?;

          if (fileData != null) {
            messages[0] = ChatMessage(
              text:
                  fileData["audioTranscript"]?.toString() ??
                  fileData["caption"]?.toString() ??
                  text,
              isUser: true,
              timestamp: messages[0].timestamp,
              file: {
                'fileType': fileData["fileType"],
                'fileUrl': fileData["fileUrl"],
                'fileName': fileData["fileName"],
                'caption': fileData["caption"],
                'audioTranscript': fileData["audioTranscript"],
              },
            );
          }
        }

        Map<String, dynamic>? botMessage;
        if (data["newMessage"] != null) {
          botMessage = data["newMessage"] as Map<String, dynamic>;
        } else if (data["senderType"] == "bot") {
          botMessage = data as Map<String, dynamic>;
        }

        if (botMessage != null) {
          final botMessageFile = botMessage["file"] as Map<String, dynamic>?;
          Map<String, dynamic>? botFile;
          if (botMessageFile != null &&
              botMessageFile.isNotEmpty &&
              botMessageFile["fileType"] != null) {
            botFile = {
              'fileType': botMessageFile["fileType"],
              'fileUrl': botMessageFile["fileUrl"],
              'fileName': botMessageFile["fileName"],
              'caption': botMessageFile["caption"],
              'audioTranscript': botMessageFile["audioTranscript"],
            };
          }

          messages.insert(
            0,
            ChatMessage(
              text:
                  botMessage["content"]?.toString() ??
                  botMessage["text"]?.toString() ??
                  "No response",
              isUser: false,
              timestamp:
                  DateTime.tryParse(
                    botMessage["createdAt"]?.toString() ?? "",
                  ) ??
                  DateTime.now(),
              file: botFile,
            ),
          );
        }

        scrollToTopAfterBuild();
      } else {
        Fluttertoast.showToast(
          msg: response["message"] ?? "Failed to send message",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Send error: $e");
      Fluttertoast.showToast(
        msg: "Error sending message. Try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    isSending.value = false;
  }

  void onSuggestionTap(String question) {
    sendChatMessage(question);
  }

  bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  void onPointerDown(VoidCallback callback) {
    _recordTimer = Timer(Duration(milliseconds: 150), callback);
  }

  void onPointerUp(VoidCallback onTap, VoidCallback onStopRecord) {
    if (_recordTimer?.isActive ?? false) {
      _recordTimer?.cancel();
      onTap();
    } else {
      onStopRecord();
    }
  }

  // void handleBack() {
  //   if (from == 'reminder') {

  //   }
  //   else if(from =='home'){

  //   }
  // }
}

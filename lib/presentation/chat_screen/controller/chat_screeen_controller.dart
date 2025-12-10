import 'dart:io';

import 'package:bandhucare_new/core/app_exports.dart';
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

  @override
  void onInit() {
    super.onInit();

    loadChatHistory();

    scrollController.addListener(() {
      // reversed = true → bottom offset = MIN
      if (scrollController.hasClients &&
          scrollController.offset >
              scrollController.position.minScrollExtent + 50) {
        shouldAutoScroll.value = false;
      } else {
        shouldAutoScroll.value = true;
      }
    });
  }

  // -------------------------------
  // Dispose controllers
  // -------------------------------
  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    audioRecorderController.dispose();
    super.onClose();
  }

  Future<void> startAudioRecording(BuildContext context) async {
    isRecordingAudio.value = true;
    amplitudeList.value = []; // Clear previous data

    await audioRecorderController.startRecording(context, (updatedList) {
      // Always update with new list instance to trigger observable update
      if (updatedList.isNotEmpty) {
        amplitudeList.value = List.from(updatedList);
        waveformUpdateCounter.value++; // Force widget rebuild
      }
    });
  }

  Future<void> stopAudioRecording() async {
    await audioRecorderController.stopRecording();
    isRecordingAudio.value = false;
    amplitudeList.value = []; // Clear waveform data
    // Audio file is saved but not sent automatically
    // TODO: Add UI to send audio file manually if needed
  }

  void scrollToBottom() {
    if (shouldAutoScroll.value && scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> loadChatHistory() async {
    isLoading.value = true;
    print("Loading chat history...");

    try {
      final response = await getChatHistory(page: 1, limit: 10);
      print("Chat History Response: $response");

      if (response["success"] == true && response["data"] != null) {
        final data = response["data"];
        print("Data received: $data");

        // Store conversationId
        if (data["conversationId"] != null) {
          conversationId.value = data["conversationId"];
          print("Conversation ID: ${conversationId.value}");
        }

        final messagesList = data["messages"] as List?;
        print("Messages list: $messagesList");

        if (messagesList != null && messagesList.isNotEmpty) {
          final List<Map<String, dynamic>> flattened = [];

          // Flatten groups
          for (var dateGroup in messagesList) {
            final list = dateGroup["messages"] as List? ?? [];
            print("Date group messages: $list");
            flattened.addAll(list.cast<Map<String, dynamic>>());
          }

          print("Flattened messages count: ${flattened.length}");

          // Sort DESC (because reversed list)
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
              final isUser = msg["senderType"] == "patient";
              final fileData = msg["file"] as Map<String, dynamic>?;

              // Build file info map only when it is a real file message
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

              // For audio messages, use audioTranscript as text
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
                messageText =
                    msg["content"]?.toString() ?? msg["text"]?.toString() ?? "";
              }

              return ChatMessage(
                text: messageText,
                isUser: isUser,
                timestamp:
                    DateTime.tryParse(msg["createdAt"]?.toString() ?? "") ??
                    DateTime.now(),
                file: fileInfo,
              );
            }).toList();

            print("Messages set: ${messages.length}");
          }

          showSuggestions.value = messages.isEmpty;
        } else {
          print("No messages found, showing suggestions");
          showSuggestions.value = true;
        }

        isLoading.value = false;
        print("Loading set to false");
        scrollToBottom();
      } else {
        print("Response not successful or data is null");
        isLoading.value = false;
        showSuggestions.value = true;
        print("Failed to load: ${response["message"]}");
      }
    } catch (e, stackTrace) {
      print("Error fetching chat history: $e");
      print("Stack trace: $stackTrace");
      isLoading.value = false;
      showSuggestions.value = true;
    }
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

    // Prepare file info for user message
    Map<String, dynamic>? fileInfo;
    if (file != null && fileType != null) {
      fileInfo = {'fileType': fileType, 'fileName': file.path.split('/').last};
    }

    // Add user message instantly with file info
    messages.insert(0, ChatMessage(text: text, isUser: true, file: fileInfo));

    scrollToBottom();
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

        // Update the user message with file info from response
        // Handle both structures: data["userMessage"] or data with senderType: "patient"
        Map<String, dynamic>? userMessageData;
        if (data["userMessage"] != null) {
          userMessageData = data["userMessage"] as Map<String, dynamic>;
        } else if (data["senderType"] == "patient") {
          // User message is directly in data
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

        // Insert bot message - handle both response structures
        // Structure 1: data["newMessage"] exists
        // Structure 2: bot message directly in data with senderType: "bot"
        Map<String, dynamic>? botMessage;
        if (data["newMessage"] != null) {
          botMessage = data["newMessage"] as Map<String, dynamic>;
        } else if (data["senderType"] == "bot") {
          // Bot message is directly in data
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

        scrollToBottom();
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
}

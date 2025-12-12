import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bandhucare_new/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/presentation/chat_screen/controller/chat_screeen_controller.dart';

class ChatScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatScreenAppBar({super.key});

  @override
  State<ChatScreenAppBar> createState() => _ChatScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

class _ChatScreenAppBarState extends State<ChatScreenAppBar> {
  final List<Map<String, String>> languages = const [
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
  ];

  late ChatScreenController _controller;
  late Worker _languageWorker;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ChatScreenController>();
    // Listen to language changes and update UI
    _languageWorker = ever(_controller.selectedLanguage, (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _languageWorker.dispose();
    super.dispose();
  }

  void _showLanguagePicker(BuildContext context) {
    final sortedLanguages = List<Map<String, String>>.from(languages)
      ..sort((a, b) => a['name']!.compareTo(b['name']!));

    // Find current selected language index
    int selectedIndex = sortedLanguages.indexWhere(
      (lang) => lang['code'] == _controller.selectedLanguage.value,
    );
    if (selectedIndex == -1) selectedIndex = 0;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header with Done button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.activeBlue,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Language picker
              Expanded(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedIndex,
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      final selectedLang = sortedLanguages[index];
                      _controller.selectedLanguage.value =
                          selectedLang['code']!;
                    },
                    children: sortedLanguages.map((lang) {
                      return Center(
                        child: Text(lang['name']!, textAlign: TextAlign.center),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSelectedLanguageName() {
    final sortedLanguages = List<Map<String, String>>.from(languages)
      ..sort((a, b) => a['name']!.compareTo(b['name']!));

    final selectedLang = sortedLanguages.firstWhere(
      (lang) => lang['code'] == _controller.selectedLanguage.value,
      orElse: () => languages.first,
    );
    return selectedLang['name']!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chatScreenHeader,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.35), width: 1.05),
        ),
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 11, top: 41, bottom: 25),
          child: InkWell(
            onTap: () {
              // Use Navigator for safe navigation without snackbar dependencies
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Icon(Icons.arrow_back_ios_new, size: 22),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 41, bottom: 25),
          child: Image.asset(
            ImageConstant.mitra_logo_header,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFEDF2F7),
        elevation: 0,
        toolbarHeight: 90,
        actions: [
          // Language selector
          InkWell(
            onTap: () => _showLanguagePicker(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 4, top: 41, bottom: 25),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language, size: 22),
                  const SizedBox(width: 4),
                  Text(
                    _getSelectedLanguageName(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 11, top: 41, bottom: 25),
            child: InkWell(
              onTap: () => _showLanguagePicker(context),
              child: Icon(Icons.keyboard_arrow_down, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LikeDislikeTTS extends StatefulWidget {
  final String? messageText; // Optional text for TTS
  final Function(bool)? onLikeChanged; // Callback when like/dislike changes
  final Function()? onTTS; // Callback when TTS is triggered

  const LikeDislikeTTS({
    super.key,
    this.messageText,
    this.onLikeChanged,
    this.onTTS,
  });

  @override
  State<LikeDislikeTTS> createState() => _LikeDislikeTTSState();
}

class _LikeDislikeTTSState extends State<LikeDislikeTTS> {
  bool? _isLiked; // null = no selection, true = liked, false = disliked

  void _handleLike() {
    setState(() {
      if (_isLiked == true) {
        // If already liked, deselect
        _isLiked = null;
      } else {
        // Set to liked
        _isLiked = true;
      }
      widget.onLikeChanged?.call(_isLiked == true);
    });
  }

  void _handleDislike() {
    setState(() {
      if (_isLiked == false) {
        // If already disliked, deselect
        _isLiked = null;
      } else {
        // Set to disliked
        _isLiked = false;
      }
      widget.onLikeChanged?.call(_isLiked == true);
    });
  }

  void _handleTTS() {
    widget.onTTS?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbs Up (Like) Button
          InkWell(
            onTap: _handleLike,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.thumb_up_outlined,
                size: 18,
                color: _isLiked == true
                    ? const Color(0xFF3865FF) // Blue when selected
                    : const Color(0xFF9CA3AF), // Grey when not selected
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Thumbs Down (Dislike) Button
          InkWell(
            onTap: _handleDislike,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.thumb_down_outlined,
                size: 18,
                color: _isLiked == false
                    ? const Color(0xFF3865FF) // Blue when selected
                    : const Color(0xFF9CA3AF), // Grey when not selected
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Speaker/TTS Button
          InkWell(
            onTap: _handleTTS,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.volume_up_outlined,
                size: 18,
                color: const Color(0xFF9CA3AF), // Grey
              ),
            ),
          ),
        ],
      ),
    );
  }
}


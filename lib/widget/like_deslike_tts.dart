import 'package:bandhucare_new/presentation/chat_screen/controller/chat_like_dislike.dart';
import 'package:flutter/material.dart';

class LikeDislikeTTS extends StatefulWidget {
  final String? messageText; // Optional text for TTS
  final Function(bool)? onLikeChanged; // Callback when like/dislike changes
  final Function()? onTTS; // Callback when TTS is triggered
  final String messageId;
  final ChatLikeDislikeController? controller;

  const LikeDislikeTTS({
    super.key,
    this.messageText,
    this.onLikeChanged,
    this.onTTS,
    required this.messageId,
    this.controller,
  });

  @override
  State<LikeDislikeTTS> createState() => _LikeDislikeTTSState();
}

class _LikeDislikeTTSState extends State<LikeDislikeTTS> {
  bool? _isLiked;
  bool? _isDisliked;

  void _handleLike() async {
    // Store previous state
    final previousLiked = _isLiked;

    // Optimistic update: immediately show like (only if not already liked)
    if (_isLiked != true) {
      setState(() {
        _isLiked = true;
        _isDisliked = null; // Clear dislike if present
      });
      widget.onLikeChanged?.call(true);
    }

    // Call API
    try {
      final result = await widget.controller?.likeMessageReversal(
        widget.messageId,
      );

      // Update based on API response
      if (result == null) {
        // API succeeded - keep the optimistic update
        setState(() {
          _isLiked = true;
        });
      } else if (result == false) {
        // API failed - revert to previous state
        setState(() {
          _isLiked = previousLiked;
          _isDisliked = previousLiked == false ? true : null;
        });
        widget.onLikeChanged?.call(previousLiked == true);
      }
    } catch (e) {
      // On exception, revert to previous state
      setState(() {
        _isLiked = previousLiked;
        _isDisliked = previousLiked == false ? true : null;
      });
      widget.onLikeChanged?.call(previousLiked == true);
    }

    // // Store previous state for potential rollback
    // final previousLiked = _isLiked;
    // final previousDisliked = _isDisliked;

    // // Optimistic update: immediately update UI
    // setState(() {
    //   if (_isLiked == true) {
    //     // If already liked, toggle it off
    //     _isLiked = null;
    //     _isDisliked = null;
    //   } else {
    //     // Like the message and clear dislike
    //     _isLiked = true;
    //     _isDisliked = null;
    //   }
    // });

    // // Notify callback
    // widget.onLikeChanged?.call(_isLiked == true);

    // // Call API in parallel
    // try {
    //   bool? result = await widget.controller?.likeMessageReversal(
    //     widget.messageId,
    //   );

    //   // If API call failed (result is not null), revert the optimistic update
    //   if (result != null) {
    //     setState(() {
    //       _isLiked = previousLiked;
    //       _isDisliked = previousDisliked;
    //     });
    //     // Notify callback of reversion - restore previous state
    //     widget.onLikeChanged?.call(previousLiked == true);
    //   }
    //   // If result is null, API call succeeded, so we keep the optimistic update
    // } catch (e) {
    //   // On exception, revert the optimistic update
    //   setState(() {
    //     _isLiked = previousLiked;
    //     _isDisliked = previousDisliked;
    //   });
    //   // Notify callback of reversion - restore previous state
    //   widget.onLikeChanged?.call(previousLiked == true);
    // }
  }

  void _handleDislike() async {
    // Store previous state for potential rollback
    final previousLiked = _isLiked;
    final previousDisliked = _isDisliked;

    // Optimistic update: immediately update UI
    setState(() {
      if (_isDisliked == true || _isLiked == false) {
        // If already disliked, toggle it off
        _isLiked = null;
        _isDisliked = null;
      } else {
        // Dislike the message and clear like
        _isLiked = false;
        _isDisliked = true;
      }
    });

    // Notify callback
    widget.onLikeChanged?.call(_isLiked == false);

    // Call API in parallel
    try {
      bool? result = await widget.controller?.disLikeMessageReversal(
        widget.messageId,
      );

      // If API call failed (result is not null), revert the optimistic update
      if (result != null) {
        setState(() {
          _isLiked = previousLiked;
          _isDisliked = previousDisliked;
        });
        // Notify callback of reversion - restore previous state
        widget.onLikeChanged?.call(previousLiked == true);
      }
      // If result is null, API call succeeded, so we keep the optimistic update
    } catch (e) {
      // On exception, revert the optimistic update
      setState(() {
        _isLiked = previousLiked;
        _isDisliked = previousDisliked;
      });
      // Notify callback of reversion - restore previous state
      widget.onLikeChanged?.call(previousLiked == true);
    }
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
                color: (_isDisliked == true || _isLiked == false)
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

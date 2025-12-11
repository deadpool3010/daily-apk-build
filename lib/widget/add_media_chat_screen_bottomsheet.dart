import 'package:flutter/material.dart';

class AddMediaChatScreenBottomSheet extends StatelessWidget {
  final VoidCallback? onDocumentSelected;

  const AddMediaChatScreenBottomSheet({super.key, this.onDocumentSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,

        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 100,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add Media',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Media options
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 40),
            child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image/Photo button
                _buildMediaButton(
                  icon: Icons.image_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Handle image selection
                  },
                ),

                // Document button
                _buildMediaButton(
                  icon: Icons.description_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    onDocumentSelected?.call();
                  },
                ),

                // Video button
                _buildMediaButton(
                  icon: Icons.videocam_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Handle video selection
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32, color: const Color(0xFF3865FF)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SelectedPdfFile extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback? onDelete;

  const SelectedPdfFile({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF204ECF), // Blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- PDF Icon Box ---
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(child: Icon(Icons.picture_as_pdf, size: 18)),
          ),

          const SizedBox(width: 8),

          // --- File Name & Size ---
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  fileSize,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // --- Delete Icon ---
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Feelings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 226,
          height: 232,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Colors.black.withValues(alpha: 0.14),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 5,
                top: 5.40,
                child: Container(
                  width: 216,
                  height: 133.62,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/flower.png"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 15,
                top: 148,
                child: SizedBox(
                  width: 196,
                  child: Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 178,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEmotionItem('Happy', Icons.sentiment_very_satisfied),
                    _buildEmotionItem('Normal', Icons.sentiment_neutral),
                    _buildEmotionItem(
                      'Scared',
                      Icons.sentiment_very_dissatisfied,
                    ),
                    _buildEmotionItem('Angry', Icons.sentiment_dissatisfied),
                    _buildEmotionItem('Sad', Icons.sentiment_very_dissatisfied),
                    _buildEmotionItem('Nothing', Icons.sentiment_satisfied),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16), // Spacing between cards
        Container(
          width: 226,
          height: 232,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Colors.black.withValues(alpha: 0.14),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 15,
                top: 148,
                child: SizedBox(
                  width: 195,
                  child: Text(
                    'Did you take your medicines ?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: Container(
                  width: 216,
                  height: 134,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/treeimage.png"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 182,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x19398F00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Yes',
                            style: TextStyle(
                              color: const Color(0xFF398F00),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF398F00),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x33F14029),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No',
                            style: TextStyle(
                              color: const Color(0xFFF14029),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.cancel,
                            color: const Color(0xFFF14029),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionItem(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 7,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

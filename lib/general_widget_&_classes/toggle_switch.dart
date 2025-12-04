import 'package:flutter/material.dart';

class SmoothToggle extends StatefulWidget {
  final Function(int)? onChanged;

  const SmoothToggle({super.key, this.onChanged});

  @override
  State<SmoothToggle> createState() => _SmoothToggleState();
}

class _SmoothToggleState extends State<SmoothToggle> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Notify parent of initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged?.call(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 170,
              height: 50,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),

          Row(
            children: [
              _buildTab("My Appointments", 0),
              _buildTab("Your Reminders", 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() => selectedIndex = index);
          widget.onChanged?.call(index);
        },
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: AnimatedDefaultTextStyle(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 14,
                fontWeight: selectedIndex == index
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: selectedIndex == index
                    ? Colors.black
                    : Colors.grey.shade600,
              ),
              child: Text(title, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

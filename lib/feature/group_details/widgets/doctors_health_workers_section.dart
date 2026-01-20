import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:flutter/material.dart';

class DoctorsHealthWorkersSection extends StatefulWidget {
  const DoctorsHealthWorkersSection({super.key});

  @override
  State<DoctorsHealthWorkersSection> createState() =>
      _DoctorsHealthWorkersSectionState();
}

class _DoctorsHealthWorkersSectionState
    extends State<DoctorsHealthWorkersSection> {
  bool _isExpanded = false;

  // Sample data - replace with actual data from API/controller
  final List<Map<String, String>> _members = [
    {'name': 'Mike Mazowski', 'role': 'Doctor', 'avatar': ''},
    {'name': 'Gregory Robertson', 'role': 'Health Worker', 'avatar': ''},
    {'name': 'Dr. Sarah Johnson', 'role': 'Doctor', 'avatar': ''},
    {'name': 'John Smith', 'role': 'Health Worker', 'avatar': ''},
    {'name': 'Dr. Emily Brown', 'role': 'Doctor', 'avatar': ''},
    {'name': 'Michael Davis', 'role': 'Health Worker', 'avatar': ''},
    {'name': 'Dr. Robert Wilson', 'role': 'Doctor', 'avatar': ''},
    {'name': 'Lisa Anderson', 'role': 'Health Worker', 'avatar': ''},
    {'name': 'Dr. David Lee', 'role': 'Doctor', 'avatar': ''},
    {'name': 'Jennifer Taylor', 'role': 'Health Worker', 'avatar': ''},
    {'name': 'Dr. James White', 'role': 'Doctor', 'avatar': ''},
    {'name': 'Patricia Harris', 'role': 'Health Worker', 'avatar': ''},
    {'name': 'Dr. Christopher Martin', 'role': 'Doctor', 'avatar': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Doctors & Health Workers',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isExpanded) ...[
                      // Show avatars when collapsed with overlapping effect
                      SizedBox(
                        width: 50 + (_members.length > 3 ? 20 : 0),
                        height: 28,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ...List.generate(
                              _members.length > 3 ? 3 : _members.length,
                              (index) => Positioned(
                                left: index * 12.0,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: Colors.grey[300],
                                    child: Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (_members.length > 3)
                              Positioned(
                                left: 36.0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    '+${_members.length - 3}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Expanded list
          if (_isExpanded) ...[
            const SizedBox(height: 16),
            ...List.generate(
              _members.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMemberRow(_members[index]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberRow(Map<String, String> member) {
    final isDoctor = member['role'] == 'Doctor';
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.person,
            size: 20,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member['name'] ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                member['role'] ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDoctor ? AppColors.primaryColor : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


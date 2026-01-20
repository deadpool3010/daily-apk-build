import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final String createdDate;
  final String location;
  final bool isActive;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.createdDate,
    required this.location,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caduceus icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Group details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Created date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      createdDate,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Status
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryColor
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive ? 'Active Group' : 'Inactive Group',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? AppColors.primaryColor
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Chevron icon
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[600],
            size: 24,
          ),
        ],
      ),
    );
  }
}


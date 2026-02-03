import 'package:bandhucare_new/core/export_file/app_exports.dart';

class ExpandableGroupCard extends StatefulWidget {
  final String groupName;
  final String createdDate;
  final String location;
  final bool isActive;
  final String? image;
  final String linkedNode;
  final String nodeType;
  final String totalUsers;
  final String contactNo;
  final String contactName;
  final String emailAddress;
  final String hospitalAddress;

  final List<Map<String, String>>? doctorsAndHealthWorkers;

  const ExpandableGroupCard({
    super.key,

    required this.groupName,
    required this.createdDate,
    required this.location,
    required this.isActive,
    this.image,
    required this.linkedNode,
    required this.nodeType,
    required this.totalUsers,
    required this.contactNo,
    required this.contactName,
    required this.emailAddress,
    required this.hospitalAddress,
    this.doctorsAndHealthWorkers,
  });

  @override
  State<ExpandableGroupCard> createState() => _ExpandableGroupCardState();
}

class _ExpandableGroupCardState extends State<ExpandableGroupCard>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isDoctorsSectionExpanded = false;
  late AnimationController _animationController;
  late AnimationController _doctorsAnimationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _doctorsExpandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _doctorsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _doctorsExpandAnimation = CurvedAnimation(
      parent: _doctorsAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _doctorsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE7EEF4),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                  // Also collapse doctors section when main card collapses
                  if (_isDoctorsSectionExpanded) {
                    _isDoctorsSectionExpanded = false;
                    _doctorsAnimationController.reverse();
                  }
                }
              });
            },
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
                  child: ClipOval(
                    child: widget.image != null && widget.image!.isNotEmpty
                        ? Image.network(
                            widget.image!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                ImageConstant.hospitalLogo,
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              );
                            },
                          )
                        : Image.asset(
                            ImageConstant.hospitalLogo,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Group details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.groupName,
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
                            widget.createdDate,
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
                              widget.location,
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
                              color: widget.isActive
                                  ? AppColors.primaryColor
                                  : Color(0xFFFF6A38),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.isActive ? 'Active Group' : 'Completed',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: widget.isActive
                                  ? AppColors.primaryColor
                                  : Color(0xFFFF6A38),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron icon with rotation animation
                RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 0.5).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          // Expanded details section with animation
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 16),
                _buildDetailRow('Linked Node', widget.linkedNode),
                const SizedBox(height: 12),
                _buildDetailRow('Node Type', widget.nodeType),
                const SizedBox(height: 12),
                _buildDetailRow('Total Users', widget.totalUsers),
                const SizedBox(height: 12),
                _buildContactRow(
                  'Contact No',
                  widget.contactNo,
                  widget.contactName,
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Email Address', widget.emailAddress),
                const SizedBox(height: 12),
                _buildDetailRow('Hospital Address', widget.hospitalAddress),
                // Doctors & Health Workers Section
                if (widget.doctorsAndHealthWorkers != null &&
                    widget.doctorsAndHealthWorkers!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(color: Colors.grey, thickness: 0.5),
                  const SizedBox(height: 16),
                  _buildDoctorsSection(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(String label, String contactNo, String contactName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$contactNo ',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '($contactName)',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorsSection() {
    final members = widget.doctorsAndHealthWorkers ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isDoctorsSectionExpanded = !_isDoctorsSectionExpanded;
              if (_isDoctorsSectionExpanded) {
                _doctorsAnimationController.forward();
              } else {
                _doctorsAnimationController.reverse();
              }
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
                  if (!_isDoctorsSectionExpanded) ...[
                    // Show avatars when collapsed with overlapping effect
                    SizedBox(
                      width: 50 + (members.length > 3 ? 20 : 0),
                      height: 28,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ...List.generate(
                            members.length > 3 ? 3 : members.length,
                            (index) => Positioned(
                              left: index * 12.0,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.asset(
                                    ImageConstant.peoples_stories_img_1,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (members.length > 3)
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
                                  '+${members.length - 3}',
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
                  RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _doctorsAnimationController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Expanded list with animation
        SizeTransition(
          sizeFactor: _doctorsExpandAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ...List.generate(
                members.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMemberRow(members[index]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberRow(Map<String, String> member) {
    final isDoctor = member['role'] == 'Doctor';
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            ImageConstant.peoples_stories_img_1,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                member['name'] ?? '',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                member['role'] ?? '',
                style: GoogleFonts.lato(
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

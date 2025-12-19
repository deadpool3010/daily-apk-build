import 'dart:math' as math;

import 'package:bandhucare_new/core/app_exports.dart';

class YourReminders extends StatefulWidget {
  const YourReminders({super.key});

  @override
  State<YourReminders> createState() => _YourRemindersState();
}

class _YourRemindersState extends State<YourReminders> {
  late final YourRemindersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(YourRemindersController());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              // Calendar Header
              _buildCalendarHeader(),
              const SizedBox(height: 16),
              // Horizontal Date Picker
              _buildHorizontalDatePicker(),
              const SizedBox(height: 24),
              // Daily Reminders Header with Filter
              _buildDailyRemindersHeader(),
              const SizedBox(height: 16),
              // Reminder Cards from API
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final filteredReminders = controller.filteredReminders;

                if (filteredReminders.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'No reminders found',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ...filteredReminders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reminder = entry.value;
                      return Column(
                        children: [
                          _buildReminderCard(
                            date: reminder['date'] ?? '',
                            completed: reminder['completed'] ?? 0,
                            total: reminder['total'] ?? 0,
                            percentage: reminder['percentage'] ?? 0,
                            isCompleted: reminder['isCompleted'] ?? false,
                            title: reminder['title'] ?? 'Questionnaire',
                            description: reminder['description'] ?? '',
                            reminderId: reminder['id'] ?? '',
                          ),
                          if (index < filteredReminders.length - 1)
                            const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Obx(
      () => Row(
        children: [
          Text(
            controller.selectedMonth.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to next month
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalDatePicker() {
    final List<Map<String, dynamic>> dates = [
      {'day': 1, 'weekday': 'Sat', 'hasEvent': true},
      {'day': 2, 'weekday': 'Sun', 'hasEvent': true, 'isToday': true},
      {'day': 3, 'weekday': 'Mon', 'hasEvent': true},
      {'day': 4, 'weekday': 'Tue', 'hasEvent': true},
      {'day': 5, 'weekday': 'Wed', 'hasEvent': true},
      {'day': 6, 'weekday': 'Thu', 'hasEvent': true},
      {'day': 7, 'weekday': 'Fri', 'hasEvent': true},
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isToday = date['isToday'] ?? false;
          final hasEvent = date['hasEvent'] ?? false;

          return GestureDetector(
            onTap: () {
              controller.selectDate(DateTime(2025, 11, date['day']));
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Date container with rounded rectangle background
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isToday
                          ? const Color(0xFFE0F2FE)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Day number
                        Text(
                          '${date['day']}'.padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Weekday
                        Text(
                          date['weekday'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Event indicator dot (only show if not today)
                  if (hasEvent && !isToday)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBBF24), // Yellow dot
                        shape: BoxShape.circle,
                      ),
                    ),
                  // "Today" label (only for today)
                  if (isToday)
                    Text(
                      'Today',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0EA5E9),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyRemindersHeader() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Daily Reminders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          // Filter Dropdown - Pill shaped
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6), // Light grey background
              borderRadius: BorderRadius.circular(24), // Pill shape
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButton<String>(
              value: controller.selectedFilter.value,
              underline: const SizedBox(),
              isDense: true,
              icon: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF1F2937),
                ),
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937), // Dark text color
                fontFamily: 'Roboto',
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: ['Unfinished', 'Completed', 'All']
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.updateFilter(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard({
    required String date,
    required int completed,
    required int total,
    required int percentage,
    required bool isCompleted,
    String? title,
    String? description,
    String? reminderId,
  }) {
    final isToday = date.toLowerCase() == 'today';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Progress Row with Background - Full Width
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE5EFFE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF64748B),
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9A9893),
                    shape: BoxShape.circle,
                  ),
                ),
                // Progress Indicators
                Row(
                  children: [
                    Icon(
                      TablerIcons.brand_walmart,
                      size: 14,
                      color: Color(0xFF909090),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$completed/$total completed',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ],
                ),
                // Separator dot
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9A9893),
                    shape: BoxShape.circle,
                  ),
                ),
                // Percentage indicator with circular progress
                Row(
                  children: [
                    // Circular Progress Bar
                    _CircularProgressIndicator(
                      percentage: percentage,
                      isCompleted: isCompleted,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFF0EA5E9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main Content with padding
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Content
                Text(
                  title ?? 'Questionnaire',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    height: 1.5,
                  ),
                ),
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Bottom Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // View Response Button
                    GestureDetector(
                      onTap: () {
                        if (reminderId != null) {
                          controller.viewResponse(reminderId);
                        }
                      },
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/images/response_icon.png',
                            ),
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'View Your Response',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Continue Button (only for unfinished)
                    if (!isCompleted)
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isContinuing.value
                              ? null
                              : () {
                                  HapticFeedback.lightImpact();
                                  if (reminderId != null) {
                                    controller.continueQuestionnaire(
                                      reminderId,
                                    );
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: controller.isContinuing.value
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    children: [
                                      Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Circular Progress Indicator Widget
class _CircularProgressIndicator extends StatelessWidget {
  final int percentage;
  final bool isCompleted;
  final double size;

  const _CircularProgressIndicator({
    required this.percentage,
    required this.isCompleted,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          percentage: percentage,
          isCompleted: isCompleted,
        ),
      ),
    );
  }
}

// Custom Painter for Circular Progress
class _CircularProgressPainter extends CustomPainter {
  final int percentage;
  final bool isCompleted;

  _CircularProgressPainter({
    required this.percentage,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 2.5;

    // Background circle (light grey)
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = isCompleted
          ? const Color(0xFF10B981) // Green for completed
          : const Color(0xFF0EA5E9) // Blue for in progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Checkmark or center dot for completed
    if (isCompleted) {
      // Draw checkmark
      final checkPaint = Paint()
        ..color = const Color(0xFF10B981)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      final checkPath = Path();
      checkPath.moveTo(center.dx - radius * 0.35, center.dy);
      checkPath.lineTo(center.dx - radius * 0.1, center.dy + radius * 0.25);
      checkPath.lineTo(center.dx + radius * 0.35, center.dy - radius * 0.25);

      canvas.drawPath(checkPath, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

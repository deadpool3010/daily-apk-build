import 'dart:math' as math;

import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toastification/toastification.dart';

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
              // _buildHorizontalDatePicker(),
              WeekCalendar(),
              //   SizedBox(height: 24),
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
                            status: reminder['status'] ?? '',
                            date: reminder['date'] ?? '',
                            completed: reminder['completed'] ?? 0,
                            total: reminder['total'] ?? 0,
                            percentage: reminder['percentage'] ?? 0,
                            isCompleted: reminder['isCompleted'] ?? false,
                            title: reminder['title'] ?? 'Questionnaire',
                            description: reminder['description'] ?? '',
                            sessionId: reminder['id'] ?? '',
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
            controller.headerMonthYear.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     // Navigate to next month
          //   },
          //   icon: const Icon(
          //     Icons.arrow_forward_ios,
          //     size: 18,
          //     color: Color(0xFF64748B),
          //   ),
          // ),
        ],
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
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: PopupMenuButton<String>(
              onSelected: controller.updateFilter,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'active', child: Text('active')),
                const PopupMenuItem(
                  value: 'in-progress',
                  child: Text('in-progress'),
                ),
                const PopupMenuItem(
                  value: 'completed',
                  child: Text('completed'),
                ),
                const PopupMenuItem(value: 'missed', child: Text('missed')),
                const PopupMenuItem(value: 'all', child: Text('all')),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.selectedFilter.value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.keyboard_arrow_down, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard({
    required String date,
    required String completed,
    required String total,
    required String percentage,
    required bool isCompleted,
    String? status,
    String? title,
    String? description,
    String? sessionId,
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
            decoration: BoxDecoration(
              color: status == 'completed'
                  ? const Color(0xFFEAFFEF)
                  : status == 'missed'
                  ? const Color(0xFFFFEAEA)
                  : const Color(0xFFE5EFFE),
              borderRadius: const BorderRadius.only(
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
                      percentage: int.parse(percentage),
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
                        // if (reminderId != null) {
                        //   controller.viewResponse(reminderId);
                        // }
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
                      DynamicButton(
                        width: 98,
                        height: 39,
                        color: Color(0xFF2563EB),
                        trailingIcon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                        fontSize: 14,
                        text: status == 'active' ? 'Start' : 'Continue',
                        onPressed: () async {
                          print('sessionId: $sessionId');
                          if (sessionId != null && sessionId.isNotEmpty) {
                            Get.toNamed(
                              AppRoutes.chatbotSplashLoadingScreen,
                              arguments: {
                                'sessionId': sessionId,
                                'mode': 'assignment',
                              },
                            );
                          } else {
                            toastification.show(
                              alignment: Alignment.bottomCenter,
                              autoCloseDuration: const Duration(seconds: 2),

                              style: ToastificationStyle.flat,
                              type: ToastificationType.error,
                              title: Text('Something went wrong'),
                              description: Text('Session ID is Not Found'),
                            );
                          }
                        },
                      ),

                    // Obx(
                    //   () => GestureDetector(
                    //     onTap: controller.isContinuing.value
                    //         ? null
                    //         : () {
                    //             HapticFeedback.lightImpact();
                    //             // if (reminderId != null) {
                    //             //   controller.continueQuestionnaire(
                    //             //     reminderId,
                    //             //   );
                    //             // }
                    //           },
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 10,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         gradient: const LinearGradient(
                    //           colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    //           begin: Alignment.topLeft,
                    //           end: Alignment.bottomRight,
                    //         ),
                    //         borderRadius: BorderRadius.circular(40),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: const Color(
                    //               0xFF3B82F6,
                    //             ).withOpacity(0.3),
                    //             blurRadius: 8,
                    //             offset: const Offset(0, 2),
                    //           ),
                    //         ],
                    //       ),
                    //       child: controller.isContinuing.value
                    //           ? const SizedBox(
                    //               width: 16,
                    //               height: 16,
                    //               child: CircularProgressIndicator(
                    //                 strokeWidth: 2,
                    //                 valueColor: AlwaysStoppedAnimation<Color>(
                    //                   Colors.white,
                    //                 ),
                    //               ),
                    //             )
                    //           : const Row(
                    //               children: [
                    //                 Text(
                    //                   'Continue',
                    //                   style: TextStyle(
                    //                     fontSize: 13,
                    //                     fontWeight: FontWeight.w600,
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //                 SizedBox(width: 4),
                    //                 Icon(
                    //                   Icons.arrow_forward,
                    //                   size: 16,
                    //                   color: Colors.white,
                    //                 ),
                    //               ],
                    //             ),
                    //     ),
                    //   ),
                    // ),
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

class WeekCalendar extends StatefulWidget {
  const WeekCalendar({super.key});

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late final YourRemindersController controller;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    controller = Get.put(YourRemindersController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TableCalendar(
            pageAnimationEnabled: false,
            //   rowHeight: ,
            rowHeight: 85,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                controller.updateDate(
                  DateFormat('yyyy-MM-dd').format(focusedDay),
                );
                HapticFeedback.selectionClick();
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerVisible: false,
            daysOfWeekVisible: false,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildDateCell(day, false, false);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDateCell(day, true, false);
              },
              todayBuilder: (context, day, focusedDay) {
                //  bool isSelected = isSameDay(_selectedDay, day);
                return _buildDateCell(day, true, true);
              },
            ),
            calendarStyle: CalendarStyle(
              canMarkersOverflow: true,

              cellMargin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            ),
          ),

          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildDateCell(DateTime day, bool isSelected, bool isToday) {
    final dayName = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ][day.weekday % 7];

    return Container(
      height: 80,
      width: 50,
      //margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFE0F2FE) : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(height: 25),
          Container(
            width: 35,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday && !isSelected
                  ? Color(0xFFE5EFFE)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: GoogleFonts.roboto(
                color: isSelected ? Colors.black : Colors.black,
                fontSize: 18,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            dayName,
            style: GoogleFonts.roboto(
              color: isSelected ? Colors.black : Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
